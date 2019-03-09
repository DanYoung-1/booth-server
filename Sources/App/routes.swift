import Vapor
import S3

/// Register your application's routes here.
public func routes(_ router: Router) throws {
    router.get("photoStack") { request in
        return "Welcome to the photoStack endpoint!"
    }
    
    router.post("photoStack") { request in
        return "uploadUserImage"
    }
    
    /*func uploadUserImage(_ req: Request) throws -> Future<HTTPStatus> {
        
        let directory = DirectoryConfig.detect()
        let workPath = directory.workDir

        let name = UUID().uuidString + ".jpg"
        let imageFolder = "Public/images" // user folder
        let saveURL = URL(fileURLWithPath: workPath).appendingPathComponent(imageFolder, isDirectory: true).appendingPathComponent(name, isDirectory: false)
        
        return req.content.get(FileContent.self, at: "file").map { payload in
            do {
                let s3 = try req.makeS3Client()
                try put(url: saveURL, destination: "", access: S3.AccessControlList.publicRead, on: Container)
                try put(url: saveURL, destination: String, bucket: "my-booth-bucket", access: S3.AccessControlList.publicRead, on: Container)
//                try payload.file.data.write(to: saveURL)
                return .ok
            } catch {
                throw Abort(.internalServerError, reason: "Unable to write multipart form data to file. Underlying error \(error)")
            }
        }
    }*/
    
    // Demonstrate work with files
    router.get("files/test") { req -> Future<String> in
        let string = "Content of my example file"
        
        let fileName = "file-hu.txt"
        
        let s3 = try req.makeS3Client()
        do {
            // Upload a file from string
            return try s3.put(string: string, destination: fileName, access: .publicRead, on: req).flatMap(to: String.self) { putResponse in
                print("PUT response:")
                print(putResponse)
                return req.future("test value")
                // Get the content of the newly uploaded file
//                return try s3.get(file: fileName, on: req).flatMap(to: String.self) { getResponse in
//                    print("GET response:")
//                    print(getResponse)
//                    print(String(data: getResponse.data, encoding: .utf8) ?? "Unknown content!")
                    // Get info about the file (HEAD)
//                    return try s3.get(fileInfo: fileName, on: req).flatMap(to: String.self) { infoResponse in
//                        print("HEAD/Info response:")
//                        print(infoResponse)
//                        // Delete the file
//                        return try s3.delete(file: fileName, on: req).map() { response in
//                            print("DELETE response:")
//                            print(response)
//                            let json = try JSONEncoder().encode(infoResponse)
//                            return String(data: json, encoding: .utf8) ?? "Unknown content!"
//                            }.catchMap({ error -> (String) in
//                                if let error = error.s3ErrorMessage() {
//                                    return error.message
//                                }
//                                return ":("
//                                }
//                        )
//                    }
//                }
            }
        } catch {
            print(error)
            fatalError()
        }
    }
}

//struct FileContent: Content {
//    let file: File
//}

/*
 
 https://docs.vapor.cloud/storage/store-files-on-s3/
 Each applications files can only be modified/deleted/added by that particular application.
 These can be accessed as environment variables in a JSON file like this:
 {
 "bucket": "$AWS_S3_BUCKET",
 "accessKey": "$AWS_ACCESS_KEY",
 "secretKey": "$AWS_SECRET_KEY",
 "region": "eu-west-1",
 }
 For now region is always eu-west-1
 When you upload the files, you should always start with adding your application slug e.g.:
 my-cool-app/my-folder/my-file.txt
 
 GuardAuthenticationMiddleware
 https://api.vapor.codes/auth/latest/Authentication/Classes/GuardAuthenticationMiddleware.html
 Stateless Authentication
 https://docs.vapor.codes/3.0/auth/api/
 
 public init(_ container: Container, defaultBucket: String, config: S3Signer.S3Signer.Config)

 */
