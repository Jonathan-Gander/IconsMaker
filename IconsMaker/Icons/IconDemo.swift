//
//  IconDemo.swift
//  IconsMaker
//
//  Created by Jonathan Gander on 29.01.22.
//
//  IMPORTANT NOTE: This IconDemo is just a demo. I'm not a designer, don't judge me!
//

import SwiftUI

struct IconDemo: View {
    @Binding var size: CGFloat
    
    var body: some View {
        ZStack {
            
            // Background
            Rectangle()
                .fill(LinearGradient(colors: [Color(hex: "00e4ff"), Color(hex: "3b9cff")],
                                     startPoint: .top, endPoint: .bottom))
            
            // Shape
            IconDemoShape()
                .stroke(LinearGradient(gradient: Gradient(colors: [Color(hex: "f4f4f4"), Color(hex: "f2f2f2")]), startPoint: .topTrailing, endPoint: .bottom),
                        lineWidth: size / 10)
                .frame(width: size, height: size)
        }
        .frame(width: size, height: size)
        .clipped()
        .drawingGroup()
    }
}

struct IconDemoShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let size: CGFloat = rect.maxX / 2
        
        path.addEllipse(in: CGRect(
            x: rect.midX - size / 2,
            y: rect.midY - size / 2,
            width: size,
            height: size
        ))
        
        return path
    }
}

struct IconDemo_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray
            IconDemo(size: .constant(240))
        }
    }
}
