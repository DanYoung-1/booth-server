//
//  EmailFunctions.swift
//  App
//
//  Created by Daniel Young on 4/26/19.
//

import Vapor
import SendGrid

func sendEmail(toEmail: String, htmlDoc: String, req: Request)  throws {
    let email = SendGridEmail(personalizations: [Personalization(to: [EmailAddress(email: toEmail)])],
                              from: EmailAddress(email: "dsy8@icloud.com"),
                              subject: "Video",
                              content: [["type": "text/html","value":htmlDoc]])
    let sendGridClient = try req.make(SendGridClient.self)
    do {
        try sendGridClient.send([email], on: req.eventLoop)
            .whenFailure { error in print("future", error) }
    } catch let error as SendGridError {
        print(error)
    }
}
