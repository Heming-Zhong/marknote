//
//  Usersetting.swift
//  marknote
//
//  Created by 钟赫明 on 2021/6/7.
//

import Foundation
import Combine

/// use userdefault.standard to store user settings
/// link: https://www.simpleswiftguide.com/how-to-use-userdefaults-in-swiftui/
/// For a unique, static preference object, using this rather than Core Data Entity is a better choice
class Usersettings: ObservableObject {
    @Published var user: String {
        didSet {
            UserDefaults.standard.set(user, forKey: "user")
        }
    }
    
    @Published var token: String {
        didSet {
            UserDefaults.standard.set(token, forKey: "token")
        }
    }
    
    @Published var branch: String {
        didSet {
            UserDefaults.standard.set(branch, forKey: "branch")
        }
    }
    
    @Published var type: String {
        didSet {
            UserDefaults.standard.set(type, forKey: "type")
        }
    }
    
    @Published var repo: String {
        didSet {
            UserDefaults.standard.set(repo, forKey: "repo")
        }
    }
    
    @Published var url: String {
        didSet {
            UserDefaults.standard.set(url, forKey: "url")
        }
    }
    
    init() {
        self.user = UserDefaults.standard.object(forKey: "user") as? String ?? ""
        self.token = UserDefaults.standard.object(forKey: "token") as? String ?? ""
        self.repo = UserDefaults.standard.object(forKey: "repo") as? String ?? ""
        self.branch = UserDefaults.standard.object(forKey: "branch") as? String ?? ""
        self.type = UserDefaults.standard.object(forKey: "type") as? String ?? ""
        self.url = UserDefaults.standard.object(forKey: "url") as? String ?? ""
    }
}
