
//use S3Client

import S3

//let s3 = try req.makeS3Client() // or req.make(S3Client.self) as? S3
//s3.put(...)
//s3.get(...)
//s3.delete(...)
//
//S3Signer.Config(accessKey: "AKIAJK6D3XPJY3W5RMZA",
//                secretKey: "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",
//                region: Region(name: RegionName.usWest2,
//                               hostName: "127.0.0.1:9000", // what would the hostname be on dev server?
//                               useTLS: false)
//
//// if you only want to use the signer
//
//import S3Signer
//
//let s3 = try req.makeS3Signer() // or req.make(S3Signer.self)
//s3.headers()
//
///// S3 client Protocol ---- Available methods
//
//public protocol S3Client: Service {
//    
//    /// Get list of objects
//    func buckets(on: Container) throws -> Future<BucketsInfo>
//    
//    /// Create a bucket
//    func create(bucket: String, region: Region?, on container: Container) throws -> Future<Void>
//    
//    /// Delete a bucket
//    func delete(bucket: String, region: Region?, on container: Container) throws -> Future<Void>
//    
//    /// Get bucket location
//    func location(bucket: String, on container: Container) throws -> Future<Region>
//    
//    /// Get list of objects
//    func list(bucket: String, region: Region?, on container: Container) throws -> Future<BucketResults>
//    
//    /// Get list of objects
//    func list(bucket: String, region: Region?, headers: [String: String], on container: Container) throws -> Future<BucketResults>
//    
//    /// Upload file to S3
//    func put(file: File.Upload, headers: [String: String], on: Container) throws -> EventLoopFuture<File.Response>
//    
//    /// Upload file to S3
//    func put(file url: URL, destination: String, access: AccessControlList, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(file url: URL, destination: String, bucket: String?, access: AccessControlList, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(file path: String, destination: String, access: AccessControlList, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(file path: String, destination: String, bucket: String?, access: AccessControlList, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(string: String, destination: String, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(string: String, destination: String, access: AccessControlList, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(string: String, mime: MediaType, destination: String, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(string: String, mime: MediaType, destination: String, access: AccessControlList, on: Container) throws -> Future<File.Response>
//    
//    /// Upload file to S3
//    func put(string: String, mime: MediaType, destination: String, bucket: String?, access: AccessControlList, on: Container) throws -> Future<File.Response>
//    
//    /// Retrieve file data from S3
//    func get(fileInfo file: LocationConvertible, on container: Container) throws -> Future<File.Info>
//    
//    /// Retrieve file data from S3
//    func get(fileInfo file: LocationConvertible, headers: [String: String], on container: Container) throws -> Future<File.Info>
//    
//    /// Retrieve file data from S3
//    func get(file: LocationConvertible, on: Container) throws -> Future<File.Response>
//    
//    /// Retrieve file data from S3
//    func get(file: LocationConvertible, headers: [String: String], on: Container) throws -> Future<File.Response>
//    
//    /// Delete file from S3
//    func delete(file: LocationConvertible, on: Container) throws -> Future<Void>
//    
//    /// Delete file from S3
//    func delete(file: LocationConvertible, headers: [String: String], on: Container) throws -> Future<Void>
//}
//
//public func routes(_ router: Router) throws {
//    
//    // Get all available buckets
//    router.get("buckets")  { req -> Future<BucketsInfo> in
//        let s3 = try req.makeS3Client()
//        return try s3.buckets(on: req)
//    }
//    
//    // Create new bucket
//    router.put("bucket")  { req -> Future<String> in
//        let s3 = try req.makeS3Client()
//        return try s3.create(bucket: "api-created-bucket", region: .euCentral1, on: req).map(to: String.self) {
//            return ":)"
//            }.catchMap({ (error) -> (String) in
//                if let error = error.s3ErrorMessage() {
//                    return error.message
//                }
//                return ":("
//                }
//        )
//    }
//    
//    // Locate bucket (get region)
//    router.get("bucket/location")  { req -> Future<String> in
//        let s3 = try req.makeS3Client()
//        return try s3.location(bucket: "bucket-name", on: req).map(to: String.self) { region in
//            return region.hostUrlString()
//            }.catchMap({ (error) -> (String) in
//                if let error = error as? S3.Error {
//                    switch error {
//                    case .errorResponse(_, let error):
//                        return error.message
//                    default:
//                        return "S3 :("
//                    }
//                }
//                return ":("
//                }
//        )
//    }
//    // Delete bucket
//    router.delete("bucket")  { req -> Future<String> in
//        let s3 = try req.makeS3Client()
//        return try s3.delete(bucket: "api-created-bucket", region: .euCentral1, on: req).map(to: String.self) {
//            return ":)"
//            }.catchMap({ (error) -> (String) in
//                if let error = error.s3ErrorMessage() {
//                    return error.message
//                }
//                return ":("
//                }
//        )
//    }
//    
//    // Get list of objects
//    router.get("files")  { req -> Future<BucketResults> in
//        let s3 = try req.makeS3Client()
//        return try s3.list(bucket: "booststore", region: .usEast1, headers: [:], on: req).catchMap({ (error) -> (BucketResults) in
//            if let error = error.s3ErrorMessage() {
//                print(error.message)
//            }
//            throw error
//        })
//    }
//    
//    // Demonstrate work with files
//    router.get("files/test") { req -> Future<String> in
//        let string = "Content of my example file"
//        
//        let fileName = "file-hu.txt"
//        
//        let s3 = try req.makeS3Client()
//        do {
//            // Upload a file from string
//            return try s3.put(string: string, destination: fileName, access: .publicRead, on: req).flatMap(to: String.self) { putResponse in
//                print("PUT response:")
//                print(putResponse)
//                // Get the content of the newly uploaded file
//                return try s3.get(file: fileName, on: req).flatMap(to: String.self) { getResponse in
//                    print("GET response:")
//                    print(getResponse)
//                    print(String(data: getResponse.data, encoding: .utf8) ?? "Unknown content!")
//                    // Get info about the file (HEAD)
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
//            }
//        } catch {
//            print(error)
//            fatalError()
//        }
//    }
//}
