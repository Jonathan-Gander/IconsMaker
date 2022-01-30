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
    @State private var currentSize: CGFloat
    @State private var generated = false
    
    private let initialSize: CGFloat = 240
    private let exportDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    
    init() {
        _currentSize = State(initialValue: initialSize)
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Button(action: {
                    generated = false
                    
                    // Search for biggest requested size
                    let maxSize = max(sizes.map( { $0.size }).max()!, 2048)
                    
                    Task {
                        await generateImages(maxSize: maxSize)
                    }
                }, label: {
                    Text("Generate image(s)")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                })
                
                if generated {
                    Text("Image(s) generated in directory:\n\(exportDirectory.path)\n\nRead log in Xcode for details.")
                        .font(.caption)
                        .textSelection(.enabled)
                        .padding()
                }
                
                icon
            }
        }
    }
    
    func generateImages(maxSize: CGFloat) async {
        currentSize = await maxSize / UIScreen.main.scale
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            // Create image from (bigest) view
            let baseImage = icon.snapshot()
            
            for imageSize in sizes {
                // Resize image to current size
                guard let resizedImage = baseImage.resize(imageSize.size, imageSize.size) else {
                    fatalError("Could not generate resized image for size \(imageSize.size).")
                }
                        
                guard let data = resizedImage.pngData() else {
                    fatalError("Could not convert resized image for size \(imageSize.size) in PNG.")
                }
                
                let path = exportDirectory.appendingPathComponent("\(imageSize.filename).png")
                do {
                    try data.write(to: path)
                }
                catch {
                    fatalError("Could not generate image \(imageSize.filename)")
                }
                print("🌄 '\(imageSize.filename)' generated")
            }
            
            currentSize = initialSize
            generated = true
            
            print("**************\n✅")
            print("Files are here: \(exportDirectory.path)")
            print("cd \(exportDirectory.path)")
            print("open \(exportDirectory.path)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
