//
//  ContentView.swift
//  IconsMaker
//
//  Created by Jonathan Gander on 29.01.22.
//

import SwiftUI

struct ContentView: View {

    var icon: some View {
        
        // Load your Icon here:
        IconDemo(size: $currentSize)
    }
    
    // Set all sizes your need
    let sizes: [ImageSize] = [
        ImageSize(size: 1024, filename: "icon-appstore-1024@1x"),
        ImageSize(size: 40, filename: "icon-iphone-notification-20@2x"),
        ImageSize(size: 60, filename: "icon-iphone-notification-20@3x"),
        ImageSize(size: 58, filename: "icon-iphone-settings-29@2x"),
        ImageSize(size: 87, filename: "icon-iphone-settings-29@3x"),
        ImageSize(size: 80, filename: "icon-iphone-spotlight-40@2x"),
        ImageSize(size: 120, filename: "icon-iphone-spotlight-40@3x"),
        ImageSize(size: 120, filename: "icon-iphone-app-60@2x"),
        ImageSize(size: 180, filename: "icon-iphone-app-60@3x"),
        ImageSize(size: 20, filename: "icon-ipad-notification-20@1x"),
        ImageSize(size: 40, filename: "icon-ipad-notification-20@2x"),
        ImageSize(size: 29, filename: "icon-ipad-settings-29@1x"),
        ImageSize(size: 58, filename: "icon-ipad-settings-29@2x"),
        ImageSize(size: 40, filename: "icon-ipad-spotlight-40@1x"),
        ImageSize(size: 80, filename: "icon-ipad-spotlight-40@2x"),
        ImageSize(size: 76, filename: "icon-ipad-app-76@1x"),
        ImageSize(size: 152, filename: "icon-ipad-app-76@2x"),
        ImageSize(size: 167, filename: "icon-ipadpro-app-83-5@2x")
    ]
    
    
    // MARK: -
    @State private var currentSize: CGFloat = 240
    @State private var generated = false
    
    private let exportDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    generated = false
                    Task {
                        await generateImage(withSizes: sizes, currentIndex: 0)
                    }
                }, label: {
                    Text("Generate image(s)")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
                
                if generated {
                    Text("Image(s) generated in directory:\n\(exportDirectory)\n\nRead log in Xcode for details.")
                        .font(.caption)
                        .textSelection(.enabled)
                        .padding()
                }
                
                icon
            }
        }
    }

    // Recursive functions to generate an image
    func generateImage(withSizes sizes: [ImageSize], currentIndex: Int) async {
        guard currentIndex < sizes.count else { return }
        
        let imageSize = sizes[currentIndex]
        
        // Set size of Icon to real size (taking into account current screen scale)
        currentSize = await imageSize.size / UIScreen.main.scale
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let image = icon.snapshot()
            
            if let data = image.pngData() {
                let path = exportDirectory.appendingPathComponent("\(imageSize.filename).png")
                do {
                    try data.write(to: path)
                }
                catch {
                    print("❌ Could not generate image \(imageSize.filename)")
                    return
                }
                
                print("\(imageSize.filename) saved at path \(path)")
                
                // Call next icon to generate
                if currentIndex + 1 < sizes.count {
                    Task {
                        await generateImage(withSizes: sizes, currentIndex: currentIndex + 1)
                    }
                }
                else {
                    generated = true
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
