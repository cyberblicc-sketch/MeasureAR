import Foundation

@objc(ARViewManager)
class ARViewManager: RCTViewManager {
    
    override static func requiresMainQueueSetup() -> Bool {
        return true
    }
    
    override func view() -> UIView! {
        return ARView()
    }
    
    // Expose the onDistanceChange event to React Native
    @objc func constantsToExport() -> [AnyHashable : Any]! {
        return ["onDistanceChange": "onDistanceChange"]
    }
}
