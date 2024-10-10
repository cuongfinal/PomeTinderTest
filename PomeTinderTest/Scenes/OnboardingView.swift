//
//  OnboardingView.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        Text("Welcome to Tinder Test App!")
        
        Button(action: {
            coordinator.push(page: .main)
        }, label: {
            Text("Start App")
        })
    }
}
