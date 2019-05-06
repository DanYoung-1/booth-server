# Booth

[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)

[![Build Status](https://travis-ci.org/joemccann/dillinger.svg?branch=master)](https://travis-ci.org/joemccann/dillinger)

Booth is a iOS app for iPad that sends image and video emails using the Sendgrid service, AWS S3 cloud-storage and a Vapor server application.

- Enter an email into the Booth iOS App
- Capture images
- Receive email with images or .mp4 video
- Each image is processed with event watermark 

### Tech

Booth uses the following 3rd-party libraries to work properly:

* [Swift 5](https://swift.org/about/) - a general-purpose programming language built using a modern approach to safety, performance, and software design patterns
* [Vapor](https://github.com/vapor) - Modular server framework for Swift and Linux. Non-blocking Asyncronous IO
* [Sendgrid](https://sendgrid.com/) - Email Delivery Service
* [Amazon S3](https://aws.amazon.com/s3/) - Simple Storage Service
* [Amazon EC2](https://aws.amazon.com/ec2/) - Elastic Compute Cloud - Ubuntu Instance
* [AWS Amplify](https://aws-amplify.github.io) - AWS Backend Configuration Tool

### Installation
#### Server
##### Initialize and Configure Server Instance
1. Login to AWS Console and select EC2 (Elastic Cloud Compute)
2. Select Launch Instance
3. Select Ubuntu Server 18.04
5. From the Instances Panel, click the Security Group for your instance
6. Select Inbound. Select Edit. 
7. Add Custom TCP rule (Port: 8080, source: 0.0.0.0/0, description: vapor)
8. Add SSH rule (Port: 22, source: 0.0.0.0/0, description: ssh)
9. In Networks & Security Menu Section, select Elastic IP. Click allocate new address. Associate the new IP address with your instance.
10. In Networks & Security Menu Section, select Key Pair. Create Key Pair. 
11. SSH to your instance with ssh -i 'Path to key' ubuntu@'Instance Public DNS URL'

##### Install Server Application
1. Follow the instructions at https://docs.vapor.codes/3.0/install/ubuntu/ to install Vapor and Swift on Ubuntu
2. git clone 'https://github.com/DanYoung-1/booth-server' and cd into directory
3. vapor build 
4. swift run Run --hostname 0.0.0.0 --port 8080
todo: environment variables (sendgrid)

#### AWS Auth and Storage Configuration
##### Create an AWS IAM user
1. Login to AWS Console and select IAM (Identity Access Management)
2. Select 'User' section and select 'Add User'
3. Give a user name and select Access Type 'Programmatic Access'
4. Select 'Attach existing policies directly' and select the AdministratorAccess and AmazonS3FullAccess policies
5. Create user. Note the accessKeyId and secretAccessKey

##### Initialize backend resources with Amplify CLI
1. Follow the instructions to install the Amplify CLI - https://aws-amplify.github.io/docs/
2. "amplify init" in Booth iOS Project directory
3. Follow CLI instructions
4. For app type, Select iOS 
5. For AWS Profile, Select No 
6. Add accessKeyId and secretAccessKey 
7. Enter "amplify add storage". Select "Content". add Cognito Auth. Use default configuration. Use default category label and default bucket name.
8. Give Auth users and Guests access, Authenticated users read/write and guest users read access.
9. Enter "amplify push" to provision backend resources in the cloud
10. Open .xcworkstation, drag copy the awsconfiguration into the xcode project directory

##### Adjust S3 Bucket Permissions
1. Select Bucket with Project name ending in 'dev'
2. Select Permissions then Bucket Policy.
3. Enter the following policy and select Save.
```
{
"Version": "2012-10-17",
"Statement": [
{
"Sid": "AddPerm",
"Effect": "Allow",
"Principal": "*",
"Action": "s3:GetObject",
"Resource": "arn:aws:s3:::booth36e1d9234676048918259805cfd637ee8-dev/*"
}
]
}
```
##### Remove backend resources amplify
1. "amplify remove" to remove all local and cloud resources (really? didn't delete the buckets)

### Docker
Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the Dockerfile if necessary. When ready, simply use the Dockerfile to build the image.

```sh
cd dillinger
docker build -t joemccann/dillinger:${package.json.version} .
```
This will create the dillinger image and pull in the necessary dependencies. Be sure to swap out `${package.json.version}` with the actual version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on your host. In this example, we simply map port 8000 of the host to port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart="always" <youruser>/dillinger:${package.json.version}
```

Verify the deployment by navigating to your server address in your preferred browser.

```sh
127.0.0.1:8000
```

### Todos

- Write MORE Tests
- Add Night Mode

License
----

Copyright Dan Young Enterprises
