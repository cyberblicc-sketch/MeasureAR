#import <React/RCTViewManager.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(ARViewManager, RCTViewManager)

// Expose the onDistanceChange event prop
RCT_EXPORT_VIEW_PROPERTY(onDistanceChange, RCTDirectEventBlock)

@end

// We don't need a separate module for now, but we'll keep the file for structure
@interface RCT_EXTERN_MODULE(ARMeasurementModule, NSObject)

@end
