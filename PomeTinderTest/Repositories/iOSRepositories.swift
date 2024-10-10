//
//  iOSRepositories.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation

enum NetworkEnvironment {
    case testing(url: String)
    case production(url: String)
    case dev(url: String)
    
    var url: String {
        switch self {
        case .testing(let url), .production(let url), .dev(let url):
            return url
        }
    }
}

protocol RequestInterceptor {
    func refreshToken() async throws
}


protocol ServiceConfiguration {
    var environment: NetworkEnvironment { get }
    var urlSession: URLSession { get }
    var interceptor: RequestInterceptor { get }
}

final class iOSRepositories<T: ServiceConfiguration>  {

    var env: T
    
    /// Initializes a new instance
    public init(env: T) {
        // Initialize instance here as needed
        self.env = env
    }
    
    /// Registers DI
    public func registerDI() {
        print("iOSRepositories registerDI")
        
        Resolver.register {
            UserRepositoryImpl(configuration: self.env)
        }.implements(UserRepository.self)
    }
}
