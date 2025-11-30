import UIKit
import ARKit
import SceneKit

@objc(ARView)
class ARView: UIView, ARSCNViewDelegate {
    
    var arView: ARSCNView!
    var startNode: SCNNode?
    var endNode: SCNNode?
    var lineNode: SCNNode?
    
    // React Native event emitter
    @objc var onDistanceChange: RCTDirectEventBlock?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupARView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        arView.frame = self.bounds
    }
    
    private func setupARView() {
        arView = ARSCNView(frame: self.bounds)
        arView.delegate = self
        self.addSubview(arView)
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        arView.session.run(configuration)
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: arView)
        
        // Perform a hit test to find a real-world surface
        let hitTestResults = arView.hitTest(location, types: .featurePoint)
        
        guard let hitResult = hitTestResults.first else { return }
        
        let position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y,
            hitResult.worldTransform.columns.3.z
        )
        
        placeAnchor(at: position)
    }
    
    private func placeAnchor(at position: SCNVector3) {
        let sphere = SCNSphere(radius: 0.01) // 1cm sphere
        sphere.firstMaterial?.diffuse.contents = UIColor.red
        let node = SCNNode(geometry: sphere)
        node.position = position
        
        if startNode == nil {
            // First point
            arView.scene.rootNode.addChildNode(node)
            startNode = node
            endNode = nil
            lineNode?.removeFromParentNode()
            lineNode = nil
            
            // Emit event to JS to indicate state change
            if let onDistanceChange = onDistanceChange {
                onDistanceChange(["distance": 0.0, "status": "Start point placed"])
            }
            
        } else if endNode == nil {
            // Second point
            arView.scene.rootNode.addChildNode(node)
            endNode = node
            
            // Calculate distance and draw line
            calculateDistance()
            
            // Reset for next measurement
            startNode = nil
            endNode = nil
            
        } else {
            // Should not happen with the logic above, but for safety, clear and start new
            startNode?.removeFromParentNode()
            endNode?.removeFromParentNode()
            lineNode?.removeFromParentNode()
            startNode = nil
            endNode = nil
            lineNode = nil
            
            placeAnchor(at: position)
        }
    }
    
    private func calculateDistance() {
        guard let start = startNode?.position, let end = endNode?.position else { return }
        
        let distance = start.distance(to: end)
        
        // Draw line
        lineNode = line(from: start, to: end)
        arView.scene.rootNode.addChildNode(lineNode!)
        
        // Emit event to JS
        if let onDistanceChange = onDistanceChange {
            onDistanceChange(["distance": distance, "status": "Measurement complete"])
        }
    }
    
    // Helper function to draw a line between two SCNVector3 points
    private func line(from: SCNVector3, to: SCNVector3) -> SCNNode {
        let vector = to - from
        let length = vector.length()
        
        let lineGeometry = SCNBox(width: 0.005, height: 0.005, length: CGFloat(length), chamferRadius: 0)
        lineGeometry.firstMaterial?.diffuse.contents = UIColor.blue
        
        let lineNode = SCNNode(geometry: lineGeometry)
        lineNode.position = SCNVector3(from.x + vector.x / 2, from.y + vector.y / 2, from.z + vector.z / 2)
        lineNode.look(at: to, up: arView.scene.rootNode.worldUp, localFront: SCNVector3(0, 0, 1))
        
        return lineNode
    }
}

// MARK: - SCNVector3 Extensions for distance calculation
extension SCNVector3 {
    func distance(to vector: SCNVector3) -> Float {
        let x = self.x - vector.x
        let y = self.y - vector.y
        let z = self.z - vector.z
        return sqrtf(x * x + y * y + z * z)
    }
    
    func length() -> Float {
        return sqrtf(x * x + y * y + z * z)
    }
    
    static func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
        return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
    }
}
