//
//  Coordinator.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import SwiftUI

class Coordinator: ObservableObject {
    @Published var path: NavigationPath = NavigationPath()
    
    func push(page: AppScreens) {
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    @ViewBuilder
    func build(page: AppScreens) -> some View {
        switch page {
        case .main:
            let vm = MainViewModel()
            MainView(viewModel: vm)
        case .onboarding: OnboardingView()
        }
    }
}
