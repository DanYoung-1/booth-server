import Vapor
import S3
import Foundation
import Leaf

/// Register your application's routes here.
public func routes(_ router: Router, awsConfig: AWSConfig) throws {
    
    let userController = UserController()
    router.get("users", use: userController.index)
    router.post("users", use: userController.create)
    
    let photoStackController = PhotoStackController()
    router.get("photoStack", use: photoStackController.index)
    router.post("photoStack", use: photoStackController.create)
    
    router.get("/") { request in
        return "welcome to the Root.\n"
    }
    
    router.get("view") { req -> Future<View> in
        let data = ["image": "https://s3-us-west-2.amazonaws.com/booth36e1d9234676048918259805cfd637ee8-dev/public/4/12B399A2-E342-4EAC-A4BD-7CC093193757.jpeg"]
        return try req.view().render("PhotoStrip", data)
    }
    
    router.get("photoStacks") { request in
        return try uploadUserImage(request)
    }
    
    func uploadUserImage(_ req: Request) -> String{
     
        let string = "Content of my example file"
        
        let fileName = "file-hu.txt"
        do {

        let s3 = try req.makeS3Client()
            // Upload a file from stringnt
            try s3.buckets(on: req).flatMap(to: String.self) { bucketResponse in
                print("buckets response:")
                print(bucketResponse)
                return req.future("test value")
            }
        } catch {
            print(error)
            fatalError()
        }
        return ""
    }
}

/*
 Client request -
 curl localhost:8080/aws
 returns a url to upload png file
 
 
 */
