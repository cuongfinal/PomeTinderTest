//
//  UserRepository.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation

protocol UserRepository: WebRepository {
    func getRandomMatches() async throws -> [UserInfo]
}

struct UserRepositoryImpl {
    let session: URLSession
    let baseURL: String
    let bgQueue = DispatchQueue(label: "bg_user_queue") // , attributes: .concurrent
    var interceptor: RequestInterceptor?
    
    init(configuration: ServiceConfiguration) {
        self.session = configuration.urlSession
        self.baseURL = configuration.environment.url
    }
}

extension UserRepositoryImpl {
    enum API: ResourceType {
        case randomMatch
        
        var endPoint: Endpoint {
            switch self {
            case .randomMatch:
                return .get(path: "user/random-match")
            }
        }
        
        var task: HTTPTask {
            switch self {
            case .randomMatch:
                return .requestParameters(encoding: .jsonEncoding, urlParameters: nil)
            default:
                return .requestParameters(bodyParameters: nil, encoding: .jsonEncoding)
            }
        }
        
        var headers: HTTPHeaders? {
            nil
        }
    }
}

extension UserRepositoryImpl: UserRepository {
    func getRandomMatches() async throws -> [UserInfo] {
        let randomUsers: [UserInfo] = try await execute(endpoint: API.randomMatch, isFullPath: false, logLevel: .debug, localJSONFileName: "randomMatches")
        return randomUsers
    }
}
