//
//  MainView.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import SwiftUI

struct MainView: View {
    @ObservedObject public var viewModel: MainViewModel
    @State var isDisplayMatchedView = false
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
                .scaledToFill().yOffset(0)
            
            ZStack {
                VStack(alignment: .center) {
                    ZStack{
                        let users = viewModel.fetchedUsers
                        if users.count == 0 {
                            CFText("Come back later we can find more matches for you!", color: .white)
                        } else{
                            ForEach(users.reversed(), id: \.id){ user in
                                // Card View...
                                StackCardView(user: user, isDisplayMatchedView: $isDisplayMatchedView)
                                    .environmentObject(viewModel)
                            }
                        }
                    }
                    .padding()
                    .height(UIScreen.mainHeight*0.75)
                    .topPadding(UIScreen.mainHeight/9)
                    .overlay(alignment: .bottom) {
                        buttonActionView
                    }
                }
                .infinityFrame(.top)
                .background(
                    Image("background")
                        .resizable()
                        .edgesIgnoringSafeArea(.all)
                        .scaledToFill()
                )
            }
        }
        .ignoresSafeArea()
        .onAppear {
            Task {
                _ = try? await viewModel.fetchUsers()
            }
        }
        .fullScreenCover(isPresented: $isDisplayMatchedView) {
            // Show Match View
        }
    }
    
    var buttonActionView: some View {
        VStack {
            HStack(spacing: 15){
                CFButton {
                    doSwipe(rightSwipe: false, superLike: false)
                } label: {
                    Image("ic_dislike")
                }
                
                CFButton {
                    doSwipe(rightSwipe: false, superLike: true)
                } label: {
                    Image("ic_biglike")
                }
                
                CFButton {
                    doSwipe(rightSwipe: true, superLike: false)
                } label: {
                    Image("ic_like")
                }
            }
            .width(260)
            .height(70)
            .yOffset(35)
            .padding(.bottom)
        }
    }
    
    // removing cards when doing Swipe....
    func doSwipe(rightSwipe: Bool = false, superLike: Bool){
        
        guard let displayingUser = viewModel.displayingUser else{
            return
        }
        
        // Using Notification to post and receiving in Stack Cards...
        NotificationCenter.default.post(name: NSNotification.Name("ACTIONFROMBUTTON"), object: nil, userInfo: [
            "id": displayingUser.id ?? "",
            "rightSwipe": rightSwipe,
            "superLike": superLike
        ])
    }
}
