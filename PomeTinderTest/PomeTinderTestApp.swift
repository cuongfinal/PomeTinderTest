//
//  PomeTinderTestApp.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import SwiftUI

@main
struct PomeTinderTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
struct Configuration: ServiceConfiguration {
    struct Interceptor: RequestInterceptor {
        func refreshToken() async throws {
            //
        }
    }
    var environment: NetworkEnvironment = .testing(url: "http://google.com")
    
    var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        configuration.timeoutIntervalForResource = 15
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        configuration.urlCache = .shared
        return URLSession(configuration: configuration)
    }
    
    var interceptor: RequestInterceptor = Interceptor()
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application ( _ application : UIApplication ,
                       didFinishLaunchingWithOptions launchOptions : [ UIApplication . LaunchOptionsKey : Any ]? = nil ) -> Bool {
        

        let serviceConfig = Configuration()
        let repo = iOSRepositories(env: serviceConfig)
        repo.registerDI()
        
        return true
    }
}
