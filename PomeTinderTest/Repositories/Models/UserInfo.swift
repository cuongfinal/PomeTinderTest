//
//  UserInfo.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation

enum GenderType: Int {
    case male = 1
    case female = 2
    case other = 3
    case both = 4
}

struct UserInfoPagingModel: Codable {
    let data: [UserInfo]?
    let current: Int?
    let pageSize: Int?
    let total: Int?
}

struct UserInfo: Codable, Equatable, Identifiable {
    static func == (lhs: UserInfo, rhs: UserInfo) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: String?
    let name: String?
    let age: Int?
    var email: String?
    var phoneNumber: String?
    let gender: Int?
    let birthdate: String?
    let aboutMe: String?
    let avatar: String?
    
    func getAge() -> Int {
        if let age = self.age {
            return age
        }
        guard let ageFromBirthDay = birthdate?.toDate() else {
            return -1
        }
        return ageFromBirthDay.calculateDiff(to: Date())
    }
    
    var genderType: GenderType {
        return GenderType(rawValue: gender ?? 1) ?? .male
    }
    
    var avatarPlaceholder: String {
        return genderType == .male ? "avatar-male-placeholder" : "avatar-female-placeholder"
    }
}

struct TokenInfo: Codable {
    let access_token: String
    let expires_in: Int
    let refresh_token: String
}
