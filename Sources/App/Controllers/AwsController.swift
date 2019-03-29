import S3
import Vapor

/// Class responsible for handling AWS S3
final class S3Controller: RouteCollection {
    
    // MARK: - Properties
    private let awsConfig: AWSConfig
    
    // MARK: - Inits
    init(awsConfig: AWSConfig) {
        self.awsConfig = awsConfig
    }
    
    // MARK: - Instance methods
    func boot(router: Router) throws {
        let group = router.grouped(Path.base.rawValue)
        group.get(use: preparePresignedUrl)
    }
    
}

// MARK: - Extension with Paths
extension S3Controller {
    
    enum Path: String {
        
        case base = "aws"
        // GET: - "/aws" - gets presigned URL for uploading image
        
    }
    
}

// MARK: - Extension with preparePresignedUrl method
extension S3Controller {
    
    func preparePresignedUrlForFolder(_ request: Request, photoStackId: UUID) throws -> String {
        
        let newFolderPath = photoStackId.uuidString + "/"
        
        guard let url = URL(string: newFolderPath) else {
            throw Abort(.internalServerError)
        }
        
        let headers = ["x-amz-acl": "public-read"]
        
        let s3 = try request.makeS3Signer()
        let result = try s3.presignedURL(for: .PUT, url: url, expiration: Expiration.hour, headers: headers)
        
        guard let presignedUrl = result?.absoluteString else {
            throw Abort(.internalServerError)
        }
        
        return presignedUrl
    }
    
    /// Prepares presigned URL, user should send PUT request with image to this URL
    func preparePresignedUrl(_ request: Request) throws -> String {
        let baseUrl = awsConfig.url
        let imagePath = awsConfig.imagePath
        let newFilename = UUID().uuidString + ".png"
        print(imagePath)
        print(newFilename)
        
        guard var url = URL(string: baseUrl) else {
            throw Abort(.internalServerError)
        }
        url.appendPathComponent(imagePath)
        url.appendPathComponent(newFilename)
        
        let headers = ["x-amz-acl": "public-read"]
        
        let s3 = try request.makeS3Signer()
        let result = try s3.presignedURL(for: .PUT, url: url, expiration: Expiration.hour, headers: headers)
        
        guard let presignedUrl = result?.absoluteString else {
            throw Abort(.internalServerError)
        }
        
        return presignedUrl
    }
}
