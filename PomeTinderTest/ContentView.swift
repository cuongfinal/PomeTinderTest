//
//  ContentView.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = Coordinator()
      
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .onboarding)
                .navigationDestination(for: AppScreens.self) { page in
                    coordinator.build(page: page)
                }
        }
        .environmentObject(coordinator)
    }
}

#Preview {
    ContentView()
}
