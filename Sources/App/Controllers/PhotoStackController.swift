//
//  PhotoStackController.swift
//  App
//
//  Created by Daniel Young on 3/11/19.
//

import Vapor
import SendGrid

/// Controls basic CRUD operations on `PhotoStack.
final class PhotoStackController {
  
    /// Returns a list of all `Book`s.
    func index(_ req: Request) throws -> Future<[PhotoStack]> {
        return PhotoStack.query(on: req).all()
    }
    
    /// Saves a decoded `PhotoStack` to the database.
    func create(_ req: Request) throws -> Future<PhotoStack> {
        return try req.content.decode(PhotoStack.self).flatMap { photoStack in
            
            
            
            let data = ["image": photoStack.urls.first]
            return try req.view().render("PhotoStrip", data).flatMap { view -> EventLoopFuture<(PhotoStack)> in
                let htmlDoc = String(decoding: view.data, as: UTF8.self)
                let user = try photoStack.user.get(on: req).wait()
                let email = SendGridEmail(
                    personalizations: [Personalization(
                        to: [EmailAddress(email: "dsy8@icloud.com")])],
                    from: EmailAddress(email: user.email),
                    subject: "Photostrip",
                    content: [["type": "text/html","value":htmlDoc]]
                )
                let sendGridClient = try req.make(SendGridClient.self)
                _ = try sendGridClient.send([email], on: req.eventLoop)
                return photoStack.save(on: req)
            }
        }
    }
    
    /// Deletes a parameterized `PhotoStack`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(PhotoStack.self).flatMap { photoStack in
            return photoStack.delete(on: req)
        }.transform(to: .ok)
    }
}
