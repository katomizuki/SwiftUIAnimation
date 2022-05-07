//
//  HomeView.swift
//  SwiftUIAnimation
//
//  Created by ミズキ on 2022/05/07.
//

import SwiftUI

struct HomeView: View {
    // 現在見ているindex
    @State var currentIndex: Int = 0
    // 投稿を入れる用の配列
    @State var posts: [Post] = []
    @State var currentTab = "Slide Show"
    @Namespace var animation
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    
                }, label: {
                    Label {
                        Text("Back")
                            .fontWeight(.semibold)
                    } icon: {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                    }
                    .foregroundColor(.primary)
                })
                Text("My Wishes")
                    .font(.title)
                    .fontWeight(.black)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            HStack(spacing: 0) {
                TabButton(title: "Slide",
                          animation: animation,
                          currentTab: $currentTab)
                TabButton(title: "List",
                          animation: animation,
                          currentTab: $currentTab)
            }.background(Color.black.opacity(0.04),
                         in: RoundedRectangle(cornerRadius: 15))
                .padding(.horizontal)
             // Snap Coursole 現在のindexを引数に入れてあげる
            SnapCarousel(index: $currentIndex,
                         items: posts) { post in
                // GeometryReader applelogoを入れる。
                // 画像を設定。　proxy.size
                GeometryReader { proxy in
                    let size = proxy.size
                    Image(systemName: "applelogo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width)
                        .cornerRadius(12)
                }
            }.padding(.vertical, 40)
            
            HStack(spacing: 10) {
                // Indicatorを表示する
                ForEach(posts.indices, id: \.self) { index in
                    // まるを作成　現在のindexをかどうかを判定して色を変える。また、大きさも変える。animationをspring（）にする
                    Circle()
                        .fill(Color.black.opacity(currentIndex == index ? 1 : 0.1))
                        .frame(width: 10, height: 10)
                        .scaleEffect(currentIndex == index ? 1.4 : 1)
                        .animation(.spring(), value: currentIndex == index)
                }
            }
        }.frame(maxHeight: .infinity, alignment: .top)
            .onAppear {
                //初期化処理時にPostを入れる
                for index in 1...5 {
                    posts.append(Post(postImage: "post\(index)"))
                }
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

struct TabButton: View {
    var title: String
    var animation: Namespace.ID
    
    @Binding var currentTab: String
    
    var body: some View {
        Button(action: {
            withAnimation(.spring()) {
                currentTab = title
            }
        }, label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(currentTab == title ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(
                    ZStack {
                        if currentTab == title {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                                .matchedGeometryEffect(id: "TAB", in: animation)
                        }
                    }
                )
        })
    }
}
