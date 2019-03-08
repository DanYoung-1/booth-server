//// Using the API
//
//// You can use all of the available parameters here to build your SendGridEmail Usage in a route closure would be as followed:
//
//import SendGrid
//
//let email = SendGridEmail(personalizations: Personalization(to: EmailAddress(email: "lactatingbillhonkey@gmail.com")), from: EmailAddress(email: "dsy8@icloud.com"), content: "stuff in content")
//let sendGridClient = try req.make(SendGridClient.self)
//
//try sendGridClient.send([email], on: req.eventLoop)


// Error handling

// If the request to the API failed for any reason a SendGridError is thrown and has an errors property that contains an array of errors returned by the API. Simply ensure you catch errors thrown like any other throwing function

