# IconsMaker

Are you like me? You can develop great apps but you're not able to use design tools to create nice icons! SwiftUI is so great to create shapes. So why not create your icon with SwiftUI code and have an app to generate all PNG images directly in all different sizes? That's what `IconsMaker` does!

I build it because I needed. And I'm sure it will be usefull for many of you guys!

## Usage

Simply `git clone` or download my project. Open it with Xcode.

In `ContentView` you have a property named `icon`. It just loads a `IconDemo` View (see below for detail). It is the icon you want to generate images from.  
You also have a `sizes` property that stores all sizes you want to generate (as `ImageSize` struct). You can also set a filename for each size. Note that default sizes are all icons needed for an iOS app.  
All other code in `ContentView` is for images generating. You don't need to change anything.

In file `Tools.swift`, it is just extensions and struct I need. Nothing to do here.

### Icon drawing
What is interesting for you is `IconDemo`. It is where you will create your own icon. You can modify everything here but please note:

- `size` Binding is used by `ContentView` to modify your icon size and generate an image from. You have to use it to size your icon.
- You also need to use this `size` value for all shapes you want to draw. Otherwise, if you set constant values it will not change in different scale and your icon will be weird.

### Images generating
When your icon is perfect, launch the app in iOS Simulator and tap on `Generate image(s)` blue button. It will generate all images from your `sizes` property.

Look in your Xcode log to get path for each created image.

And that's all!

## Screenshot
<img width="300" alt="Screenshot1" src="https://user-images.githubusercontent.com/1695222/151670215-16277a94-d68e-4f5a-99ee-cbb7b4782eb4.png">


## Licence
Be free to use `IconsMaker` for your icons!

If you use it, please let me know. You can [contact me here](https://contact.gander.family?locale=en).
