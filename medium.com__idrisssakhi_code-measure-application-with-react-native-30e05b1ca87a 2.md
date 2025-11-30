[Sitemap](/sitemap/sitemap.xml)

[Open in app](https://rsci.app.link/?%24canonical_url=https%3A%2F%2Fmedium.com%2Fp%2F30e05b1ca87a&%7Efeature=LoOpenInAppButton&%7Echannel=ShowPostUnderUser&%7Estage=mobileNavBar&source=post_page---top_nav_layout_nav-----------------------------------------)

Sign up

[Sign in](/m/signin?operation=login&redirect=https%3A%2F%2Fmedium.com%2F%40idrisssakhi%2Fcode-measure-application-with-react-native-30e05b1ca87a&source=post_page---top_nav_layout_nav-----------------------global_nav------------------)

[](/?source=post_page---top_nav_layout_nav-----------------------------------------)

[Write](/m/signin?operation=register&redirect=https%3A%2F%2Fmedium.com%2Fnew-story&source=---top_nav_layout_nav-----------------------new_post_topnav------------------)

[Search](/search?source=post_page---top_nav_layout_nav-----------------------------------------)

Sign up

[Sign in](/m/signin?operation=login&redirect=https%3A%2F%2Fmedium.com%2F%40idrisssakhi%2Fcode-measure-application-with-react-native-30e05b1ca87a&source=post_page---top_nav_layout_nav-----------------------global_nav------------------)

# Code Measure application with React Native

[](/@idrisssakhi?source=post_page---byline--30e05b1ca87a---------------------------------------)

[Idriss Sakhi](/@idrisssakhi?source=post_page---byline--30e05b1ca87a---------------------------------------)

5 min read

·

Aug 18, 2024

[](/m/signin?actionUrl=https%3A%2F%2Fmedium.com%2F_%2Fvote%2Fp%2F30e05b1ca87a&operation=register&redirect=https%3A%2F%2Fmedium.com%2F%40idrisssakhi%2Fcode-measure-application-with-react-native-30e05b1ca87a&user=Idriss+Sakhi&userId=52a83ddc94b9&source=---header_actions--30e05b1ca87a---------------------clap_footer------------------)

\--

1

[](/m/signin?actionUrl=https%3A%2F%2Fmedium.com%2F_%2Fbookmark%2Fp%2F30e05b1ca87a&operation=register&redirect=https%3A%2F%2Fmedium.com%2F%40idrisssakhi%2Fcode-measure-application-with-react-native-30e05b1ca87a&source=---header_actions--30e05b1ca87a---------------------bookmark_footer------------------)

Listen

Share

In this article, I’ll guide you step-by-step on how to integrate augmented reality (AR) into your React Native application to measure object sizes, take pictures of these measurements, and store them locally.

## Final Result:

Imagine being able to measure the size of objects using just your camera!

Measuring object size with camera

## Prerequisites:

* React Native running application
* Xcode
* Android studio
* iPhone 8 or above
* Android phone with depth sensor

## Before starting:

When I first embarked on this project, I searched for existing libraries that could help achieve object measurement in React Native. I found several AR libraries, but they mainly focused on placing 3D models in space, none offering the specific measurement functionality I needed.

## Initial Attempts:

I initially tried implementing this functionality using a regular camera library like `react-native-vision-camera` combined with the gyroscope sensor to detect the angle from the start to the end of an object. I found formulas online to calculate an object’s height, as shown below:

Calculate object size (source: <https://stackoverflow.com/questions/8698889/how-to-measure-height-width-and-distance-of-object-using-camera> )

However, this method had significant limitations, relying on many assumptions like the phone’s position relative to the ground and the object’s distance from the camera. These assumptions led to inaccurate measurements.

## Shifting Gears:

I quickly realized that using the phone’s sensors to detect an object’s distance from the camera would yield better results. That’s when I discovered the world position API, which, with the help of an AR camera, can calculate an object’s position in a 3D space. This makes distance calculation straightforward.

## iOS Integration: ARKit

We’ll create a native view in iOS that scans the 3D world with the camera, allowing users to tap and draw 3D nodes to measure the distance between them.

To summarize, we’ll set up the following nodes and scenes:

* **Augmented Reality Scene** ( `ARSCNView` ): This will serve as the main scene for rendering the AR content.
* **Two 3D Nodes** ( `SCNNode` ): Representing the start and end points of the measurement.
* **Connecting Line** ( `SCNNode` ): A line drawn between the two nodes to visually represent the measurement.
* **Text Node** ( `SCNNode` ): Displays the measured distance.

We’ll also need a tap listener to capture the position of each node. Additionally, I included a pan listener to allow users to adjust the nodes after the distance is drawn. The final implementation is encapsulated within a file named `ArView.swift` .

As seen in the previous code, we are invoking various methods and events, such as `onDataChangeEvent` . To manage the communication between the native side and the React Native JavaScript side, we need to define a `ViewManager` . This `ViewManager` will handle the connection, allowing us to bridge native functionality with the React Native interface seamlessly.

Lastly, since we’re coding in Swift, we need to create an Objective-C class to map those functions, enabling seamless interaction between the Swift code and React Native. Here’s how you can do that:

For the iOS side, everything should be set up correctly. Just ensure that you have a bridging header in your project, as it’s essential for making the Objective-C and Swift code work together. Without this, the integration won’t function properly. Now, let’s move on to the Android implementation

## Android Implementation:

On Android, things get a bit more complex. We’ll add an external SDK and create a native view and module to handle screenshots. Not all Android devices are compatible, so we’ll ensure to check for OpenGL version compatibility.

* Add needed package, inside `android/app/build.gradle`

```
dependencies {  
  ...  
  
    implementation 'com.google.ar.sceneform:core:1.17.1'  
    implementation 'com.google.ar.sceneform.ux:sceneform-ux:1.17.1'  
    implementation 'androidx.lifecycle:lifecycle-runtime-ktx:2.8.4'  
  ...  
}
```

* During my experience, I noticed that plane detection on Android is more effective when you explicitly specify the plane direction (horizontal or vertical). This difference is why certain view properties vary between iOS and Android.
* To begin, the first step is to create the representation of our AR view.


* As you can see, we have the `RnArView` , which we need to define.


* We’re also referencing some layouts and views that we created as XML representations to display the distance between two anchors. To do this, add the following view inside `res/layout` :

```
<?xml version="1.0" encoding="utf-8"?>  
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"  
    android:layout_width="wrap_content"  
    android:layout_height="wrap_content"  
    android:orientation="vertical">  
  
    <TextView  
        android:id="@+id/distanceTextView"  
        android:layout_width="wrap_content"  
        android:layout_height="wrap_content"  
        android:textColor="@android:color/white"  
        android:textSize="13sp"  
        android:textStyle="bold" />  
</LinearLayout>
```

* The `checkIsSupportedDevice` function is crucial because not all Android phones are compatible or have the correct OpenGL version. Additionally, we need to ensure our application is AR-ready by making specific declarations in the manifest file.

```
<manifest xmlns:android="http://schemas.android.com/apk/res/android">  
  
    <uses-feature  
      android:name="android.hardware.camera"  
      android:required="false" />  
    <uses-feature android:name="android.hardware.camera.ar" android:required="true" />  
  
    <uses-permission android:name="android.permission.CAMERA" />  
    ...  
</manifest>
```

* In my implementation, I handled the camera permission check on the React Native side, so I didn’t include it in the native code. However, you can add a simple method in the native side to verify camera permissions before starting the AR session.
* Additionally, in `RnArView` , there’s a call to the `sendEvent` method on line 349. Recent React Native versions have deprecated the old way of sending events to the JS side, so we need to create an `Emitter` module to remain compliant.


* Now, let’s create the module that will allow us to take snapshots.


* The final step is to add the `ViewManager` we created to the list of view managers and the AR module to the list of modules in your React Native setup.
* For example, in your `MainApplication.java` (or equivalent file), you would do something like this:

```
@Override  
protected List<ReactPackage> getPackages() {  
  return Arrays.<ReactPackage>asList(  
      new MainReactPackage(),  
      new RnArViewManager(),  // Add your ViewManager here  
      new ArModule()           // Add your AR module here  
  );  
}
```

* Once this is done, we can proceed to the React Native side to start using these components.

## React Native implementation:

Now that we’ve set up the native modules for both iOS and Android, it’s time to integrate these features into our React Native application. In this section, we’ll create custom components to interact with our AR views and manage the communication between JavaScript and native code. We’ll also explore how to handle user interactions, trigger AR sessions, and display the measurements on the screen. By the end, you’ll have a fully functional AR measurement tool within your React Native app.

* ArView


* simple use case

## Conclusion:

By following this tutorial, you’ll have the tools to measure object sizes accurately with React Native. Feel free to reach out for freelance opportunities or any questions!

* [My website](https://skh-techlabs.com/)
* [LinkedIn](https://www.linkedin.com/in/idris-sakhi-304713a9/)

[React Native Ruler](/tag/react-native-ruler?source=post_page-----30e05b1ca87a---------------------------------------)

[React Native Development](/tag/react-native-development?source=post_page-----30e05b1ca87a---------------------------------------)

[React Native Measure](/tag/react-native-measure?source=post_page-----30e05b1ca87a---------------------------------------)

[Augmented Reality](/tag/augmented-reality?source=post_page-----30e05b1ca87a---------------------------------------)

[React Native Tutorial](/tag/react-native-tutorial?source=post_page-----30e05b1ca87a---------------------------------------)

[](/m/signin?actionUrl=https%3A%2F%2Fmedium.com%2F_%2Fvote%2Fp%2F30e05b1ca87a&operation=register&redirect=https%3A%2F%2Fmedium.com%2F%40idrisssakhi%2Fcode-measure-application-with-react-native-30e05b1ca87a&user=Idriss+Sakhi&userId=52a83ddc94b9&source=---footer_actions--30e05b1ca87a---------------------clap_footer------------------)

\-- [](/m/signin?actionUrl=https%3A%2F%2Fmedium.com%2F_%2Fvote%2Fp%2F30e05b1ca87a&operation=register&redirect=https%3A%2F%2Fmedium.com%2F%40idrisssakhi%2Fcode-measure-application-with-react-native-30e05b1ca87a&user=Idriss+Sakhi&userId=52a83ddc94b9&source=---footer_actions--30e05b1ca87a---------------------clap_footer------------------)

\--

1

[](/m/signin?actionUrl=https%3A%2F%2Fmedium.com%2F_%2Fbookmark%2Fp%2F30e05b1ca87a&operation=register&redirect=https%3A%2F%2Fmedium.com%2F%40idrisssakhi%2Fcode-measure-application-with-react-native-30e05b1ca87a&source=---footer_actions--30e05b1ca87a---------------------bookmark_footer------------------)

[](/@idrisssakhi?source=post_page---post_author_info--30e05b1ca87a---------------------------------------)

[](/@idrisssakhi?source=post_page---post_author_info--30e05b1ca87a---------------------------------------)

[## Written by Idriss Sakhi](/@idrisssakhi?source=post_page---post_author_info--30e05b1ca87a---------------------------------------)

[14 followers](/@idrisssakhi/followers?source=post_page---post_author_info--30e05b1ca87a---------------------------------------)

· [3 following](/@idrisssakhi/following?source=post_page---post_author_info--30e05b1ca87a---------------------------------------)

React Native Developer 😁

## Responses (1)

[](https://policy.medium.com/medium-rules-30e5502c4eb4?source=post_page---post_responses--30e05b1ca87a---------------------------------------)

See all responses
