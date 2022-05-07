//
//  SnapCoursole.swift
//  SwiftUIAnimation
//
//  Created by ミズキ on 2022/05/07.
//

import SwiftUI

struct SnapCarousel<Content: View, T: Identifiable>: View {
    var content: (T) -> Content
    var list: [T]
    
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15,
         trailingSpace: CGFloat = 100,
         index: Binding<Int>,
         items: [T],@ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    
    var body: some View {
        GeometryReader { proxy in
            
            //
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(DragGesture().updating($offset, body: { value, out, _ in
                out = value.translation.width
            }).onEnded({ value in
                //
                let offsetX = value.translation.width
                print(offsetX)
                // were going to convert the  translation into progress
                let progress = -offsetX / width
                let roundIndex = progress.rounded()
                
                // setting min...
                currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                print(currentIndex)
                print(progress)
                // updating index
                currentIndex = index
                
            }).onChanged({ value in
                //
                let offsetX = value.translation.width
                print(offsetX)
                // were going to convert the  translation into progress
                let progress = -offsetX / width
                let roundIndex = progress.rounded()
                
                // setting min...
                index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                print(currentIndex)
                print(progress)

            })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
}
