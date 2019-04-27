import Vapor
import S3
import Foundation
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    
    let userController = UserController()
    router.get("user", use: userController.index)
    router.post("user", use: userController.create)
    
    let photoStackController = PhotoStackController()
    router.get("photoStack", use: photoStackController.index)
    router.post("photoStack", use: photoStackController.create)
    
    let videoController = VideoController()
    router.get("video", use: videoController.index)
    router.post("video", use: videoController.create)
    
    router.get("/") { request in
        return "welcome to the Root.\n"
    }
    
    router.get("view") { req -> Future<View> in
        let data = ["image": "https://s3-us-west-2.amazonaws.com/booth36e1d9234676048918259805cfd637ee8-dev/public/4/12B399A2-E342-4EAC-A4BD-7CC093193757.jpeg"]
        return try req.view().render("PhotoStrip", data)
    }
}

/*
 Client request -
 curl localhost:8080/aws
 returns a url to upload png file
 
 
 */
