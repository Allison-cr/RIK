//
//  UsersModel.swift
//  RIK
//
//  Created by Alexander Suprun on 19.09.2024.
//

import Foundation
import RealmSwift

struct Users: Codable {
    let id: Int
    let sex: String
    let username: String
    let isOnline: Bool
    let age: Int
    let files: [File]
}

struct File: Codable {
    let id: Int
    let url: String
    let type: String
}


struct UsersResponse: Codable {
    let users: [Users]
}

class UserFile: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}


class UserObject: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var sex: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var isOnline: Bool = false
    @objc dynamic var age: Int = 0
    let files = List<UserFile>()

    override static func primaryKey() -> String? {
        return "id"
    }
}
