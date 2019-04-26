//
//  PhotoStackController.swift
//  App
//
//  Created by Daniel Young on 3/11/19.
//

import Vapor
import SendGrid

/// Controls basic CRUD operations on `Video`.
final class VideoController {
  
    /// Returns a list of all `Book`s.
    func index(_ req: Request) throws -> Future<[Video]> {
        return Video.query(on: req).all()
    }
    
    /// Saves a decoded `PhotoStack` to the database.
    func create(_ req: Request) throws -> Future<Video> {
        let futureVideo = try req.content.decode(Video.self)

        let futureUser = futureVideo.flatMap(to: User.self) { video in
            return video.user.get(on: req)
        }

        let futureHtmlDoc = futureVideo.flatMap(to: View.self) { video in
            let data = ["video": video.url]
            return try req.view().render("Video", data)
        }.map(to: String.self) { view in
            return String(decoding: view.data, as: UTF8.self)
        }

        _ = futureUser.and(futureHtmlDoc).map() { (arg) in
            let (user, htmlDoc) = arg
            let email = SendGridEmail(personalizations: [Personalization(to: [EmailAddress(email: "dsy8@icloud.com")])],
                                from: EmailAddress(email: user.email),
                                subject: "Video",
                                content: [["type": "text/html","value":htmlDoc]])

            let sendGridClient = try req.make(SendGridClient.self)
            _ = try sendGridClient.send([email], on: req.eventLoop)
        }

        return futureVideo.save(on: req)
    }
    
    /// Deletes a parameterized `PhotoStack`.
    func delete(_ req: Request) throws -> Future<HTTPStatus> {
        return try req.parameters.next(PhotoStack.self).flatMap { photoStack in
            return photoStack.delete(on: req)
        }.transform(to: .ok)
    }
}
