// swift-tools-version:4.2
import PackageDescription

let package = Package(
    name: "booth-server",
    dependencies: [
        // 💧 A server-side Swift web framework.

        .package(url: "https://github.com/vapor/vapor.git", from: "3.3.0"),

        .package(url: "https://github.com/vapor/fluent-sqlite.git", from: "3.0.0"),

		.package(url: "https://github.com/vapor/multipart.git", from: "3.0.3"),

		// AWS S3 Client for Vapor 3
       .package(url: "https://github.com/LiveUI/S3", from: "3.0.0-RC3.2"),
		
	   // Vapor Swift Extensions
	   .package(url: "https://github.com/vapor-community/vapor-ext.git", from: "0.3.3"),


        // SendGrid-powered mail backend for Vapor
        .package(url: "https://github.com/vapor-community/sendgrid-provider.git", from: "3.0.6"),
        
        // Leaf HTML Templater
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.2")
	],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "VaporExt", "S3", "FluentSQLite", "SendGrid", "Leaf"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)

