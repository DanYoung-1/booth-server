//
//  EmailResponseContent.swift
//  App
//
//  Created by Daniel Young on 3/7/19.
//

import Foundation

/* You don't want people using others emails to send them pictures. Must confirm email address before use.
 Limit client requests from this form. 
 This form must not be misused.
 Email address sends a 4 digit key
 Type 4 digit key in boothpad
 4 digit key request and response
 */

struct EmailResponseContent {
    let status: String // registered, created, login,
}

struct DigitKeyConfirmationResponseContent {
    
}

//Bearer
//Bearer authorization simply contains a token. A bearer authorization header containing the token cn389ncoiwuencr would look like this:
struct SessionToken { // How do we manage session token, authtoken in vapor? refresh
    
}

/*
 Authentication middleware is responsible for reading the credentials from the request and fetching the identifier user. This usually means checking the "Authorization" header, parsing the credentials, and doing a database lookup.
 
 If you would like to ensure that a certain model's authentication has succeeded before running your route, you must add an instance of GuardAuthenticationMiddleware.
 */
