//
//  CardInfoView.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import SwiftUI

struct CardInfoView: View {
    var userInfo: UserInfo
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                RenderIf(userInfo.getAge() > 0) {
                    CFText("\(userInfo.name ?? ""), \(String(userInfo.getAge()))", .system(size: 18, weight: .bold))
                }
            }.bottomPadding(50)
        }
        .infinityWidth()
    }
}
