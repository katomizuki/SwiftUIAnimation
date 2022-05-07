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
            
            // 左右の幅とカード間のスペース
            let width = proxy.size.width - (trailingSpace - spacing)
            let adjustMentWidth = (trailingSpace / 2) - spacing
            
            HStack(spacing: spacing) {
                ForEach(list) { item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                        .offset(y: getOffset(item: item,
                                             width: width))
                }
            }
            .padding(.horizontal, spacing)
            .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex != 0 ? adjustMentWidth : 0) + offset)
            .gesture(DragGesture().updating($offset, body: { value, out, _ in
                out = value.translation.width
            })
                .onEnded({ value in
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
                
            })
                    .onChanged({ value in
                // どれくらい移動したか
                let offsetX = value.translation.width
                print(offsetX)
                // were going to convert the  translation into progress
                // 全体の幅とどれくらい動かしたかを割ることで進捗具合がわかる
                let progress = -offsetX / width
                // これを四捨五入することでroundIndexを
                let roundIndex = progress.rounded()
                
                // setting min...
                // 現在のインデックスと移動したインデックスをたしたものと、listの長さの小さい方を選択して、かつ、0よりはおおきいほうであれば
                index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                print(currentIndex)
                print(progress)

            })
            )
        }
        .animation(.easeInOut, value: offset == 0)
    }
    
    func getOffset(item: T, width: CGFloat) -> CGFloat {
        let progress = ((offset < 0 ? offset : -offset) / width) * 60
        let topOffset = -progress < 60 ? progress : -(progress + 120)
        let previous = getIndex(item: item) - 1 == currentIndex ? (offset < 0 ? topOffset : -topOffset) : 0
        let next = getIndex(item: item) + 1 == currentIndex ? (offset < 0 ? -topOffset : topOffset) : 0
        let checkBetween = currentIndex >= 0 && currentIndex < list.count ? (getIndex(item: item) - 1 == currentIndex ? previous : next) : 0
        // checking current if so shifting view top
        return getIndex(item: item) == currentIndex ? -60 - topOffset : checkBetween
    }
    
    func getIndex(item: T) -> Int {
        let index = list.firstIndex { currentItem in
            return currentItem.id == item.id
        } ?? 0
        return index
    }
}
