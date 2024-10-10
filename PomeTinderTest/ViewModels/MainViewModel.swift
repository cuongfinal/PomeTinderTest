//
//  MainViewModel.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation

public class MainViewModel: ObservableObject {
    @LazyInjected var userRepo: UserRepository
    
    @Published var fetchedUsers: [UserInfo] = []
    @Published var displayingUsers: [UserInfo]?
    @Published var displayingUser: UserInfo?
    
    private var cancelBag = CancelBag()
    
    func fetchUsers() async throws {
        do {
            let randomMatches = try await userRepo.getRandomMatches()
            fetchedUsers = randomMatches
            displayingUser = fetchedUsers.first
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getIndex(user: UserInfo) -> Int{
        let index = fetchedUsers.firstIndex(where: { currentUser in
            return user.id == currentUser.id
        }) ?? 0
        
        return index
    }
    
    func handleUserSwipeLeft(targetUser: UserInfo) async {
        // Logic for Swift Left
        updateDisplayedUser(targetUser)
    }
    
    func handleUserSwipeRight(targetUser: UserInfo) async {
        // Logic for Swift Right
        updateDisplayedUser(targetUser)
    }
    
    func handleUserSuperLike(targetUser: UserInfo) async {
        // Logic for Swift Up
        updateDisplayedUser(targetUser)
    }
    
    func updateDisplayedUser(_ targetUser: UserInfo) {
        let nextUserIndex = getIndex(user: targetUser) + 1
        if nextUserIndex < fetchedUsers.count {
            displayingUser = fetchedUsers[nextUserIndex]
        }
    }
}
