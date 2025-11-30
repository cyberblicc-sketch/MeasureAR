package com.sensortoolkitar.ar;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.SimpleViewManager;
import com.facebook.react.uimanager.ThemedReactContext;
import com.facebook.react.uimanager.annotations.ReactProp;

import java.util.Map;

public class ARViewManager extends SimpleViewManager<ARView> {

    public static final String REACT_CLASS = "ARView";

    @NonNull
    @Override
    public String getName() {
        return REACT_CLASS;
    }

    @NonNull
    @Override
    protected ARView createViewInstance(@NonNull ThemedReactContext reactContext) {
        return new ARView(reactContext);
    }

    @Nullable
    @Override
    public Map<String, Object> getExportedCustomBubblingEventTypeConstants() {
        return Map.of(
                "onDistanceChange", Map.of(
                        "phasedRegistrationNames", Map.of("bubbled", "onDistanceChange")
                )
        );
    }
}
