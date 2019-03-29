//
//  UserController.swift
//  App
//
//  Created by Daniel Young on 3/11/19.
//

import Vapor

final class UserController {
   
    /// Returns a list of all `Book`s.
    func index(_ req: Request) throws -> Future<[User]> {
        return User.query(on: req).all()
    }
    
    func create(_ req: Request) throws -> Future<User> {
        return try req.content.decode(User.self).flatMap { user in
            return user.save(on: req)
        }
    }
}
