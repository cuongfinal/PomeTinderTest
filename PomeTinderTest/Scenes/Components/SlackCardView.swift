//
//  SlackCardView.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import SwiftUI

struct StackCardView: View {
    @EnvironmentObject var viewModel: MainViewModel
    var user: UserInfo
    
    // Gesture Properties...
    @State var verticalOffset: CGFloat = 0
    @State var horizontalOffset: CGFloat = 0
    @GestureState var isDragging: Bool = false
    @State var endSwipe: Bool = false
    @Binding var isDisplayMatchedView: Bool
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            let index = CGFloat(viewModel.getIndex(user: user))
            // Showing Next two cards at top like a Stack...
            let topOffset = (index <= 2 ? index : 2) * 15
            
            ZStack(alignment: .bottom) {
                AsyncImage(url: URL(string: user.avatar ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size.width - topOffset, height: size.height)
                            .offset(y: -topOffset)
                    } else {
                        Image(user.avatarPlaceholder)
                            .resizable()
                            .scaledToFit()
                            .frame(width: size.width - topOffset, height: size.height)
                            .offset(y: -topOffset)
                    }
                }
                CardInfoView(userInfo: user)
            }
            .infinityFrame(.center)
        }
        .offset(x: horizontalOffset)
        .offset(y: verticalOffset)
        .rotationEffect(.init(degrees: getRotation(angle: 8)))
        .contentShape(Rectangle().trim(from: 0, to: endSwipe ? 0 : 1))
        .gesture(
            DragGesture()
                .updating($isDragging, body: { value, state, _ in
                    state = true
                })
                .onChanged({ value in
                    let horizontalTranslation = value.translation.width
                    let verticalTranslation = value.translation.height
                    
                    // Prioritize vertical swipe for this logic
                    if abs(verticalTranslation) > abs(horizontalTranslation) {
                        verticalOffset = isDragging ? verticalTranslation : 0
                        horizontalOffset = 0 // reset horizontal offset
                    } else {
                        horizontalOffset = isDragging ? horizontalTranslation : 0
                        verticalOffset = 0 // reset vertical offset
                    }
                })
                .onEnded({ value in
                    let width = getRect().width - 50
                    let height = getRect().height - 50
                    let horizontalTranslation = value.translation.width
                    let verticalTranslation = value.translation.height
                    
                    
                    withAnimation {
                        // Determine swipe direction based on magnitude of translation
                        if abs(verticalTranslation) > abs(horizontalTranslation) {
                            // Vertical swipe (upwards)
                            if -verticalTranslation > height / 2 { // negative value for upwards
                                verticalOffset = -height
                                endSwipeActions()

                                superLike(user: user)
                            } else {
                               verticalOffset = .zero
                           }
                        } else {
                            // Horizontal swipes
                            if abs(horizontalTranslation) > width / 2 {
                                horizontalOffset = (horizontalTranslation > 0 ? width : -width) * 2
                                endSwipeActions()
                                
                                if horizontalTranslation > 0 {
                                    rightSwipe(user: user)
                                } else {
                                    leftSwipe(user: user)
                                }
                            } else {
                                horizontalOffset = .zero
                            }
                        }
                    }
                })
        )
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ACTIONFROMBUTTON"), object: nil)) { data in
            guard let info = data.userInfo else{
                return
            }
            
            let id = info["id"] as? String ?? ""
            let rightSwipe = info["rightSwipe"] as? Bool ?? false
            let superLike = info["superLike"] as? Bool ?? false
            
            let width = getRect().width - 50
            let height = getRect().height - 50

            
            if user.id == id {
                // removing card...
                withAnimation{
                    if superLike {
                        verticalOffset = -height
                    } else {
                        horizontalOffset = (rightSwipe ? width : -width) * 2
                    }
                    endSwipeActions()
                    
                    if superLike {
                        self.superLike(user: user)
                    } else if rightSwipe{
                        self.rightSwipe(user: user)
                    } else {
                        self.leftSwipe(user: user)
                    }
                }
            }
        }
        .onTapGesture {
            // Show Detail
        }
    }
    
    // Rotation...
    func getRotation(angle: Double)->Double{
        let rotation = (horizontalOffset / (getRect().width - 50)) * angle
        return rotation
    }
    
    func endSwipeActions(){
        withAnimation(.none) { endSwipe = true }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if let _ = viewModel.fetchedUsers.first {
                
               let _ = withAnimation {
                   viewModel.fetchedUsers.removeFirst()
                }
            }
        }
    }
    
    func leftSwipe(user: UserInfo) {
        Task {
            await viewModel.handleUserSwipeLeft(targetUser: user)
        }
    }
    
    func rightSwipe(user: UserInfo) {
        Task {
            _ = await viewModel.handleUserSwipeRight(targetUser: user)
        }
    }
    
    func superLike(user: UserInfo) {
        Task {
            _ = await viewModel.handleUserSuperLike(targetUser: user)
        }
    }
}

// Extending View to get Bounds....
extension View{
    func getRect() -> CGRect{
        return UIScreen.main.bounds
    }
}
