//
//  server.h
//  EchoServer
//
//  Created by Shavit Tzuriel on 1/26/19.
//  Copyright © 2019 Shavit. All rights reserved.
//

#ifndef server_h
#define server_h

#import <Foundation/Foundation.h>

#define LISTENQ 1024
#define MAXLINE 4096

// Defines the underlying type for the error codes as NSUInteger
typedef NS_ENUM(NSUInteger, BSDServerErrorCode) {
    NOERROR,
    SOCKETERROR,
    BINDERROR,
    LISTENERROR,
    ACCEPTINGERROR
};

@interface Server: NSObject

@property (nonatomic) int errorCode, listenfd;

/**
 Construct and start the server
 
 Setup a socket by calling socket(), bind() and listen().
 
    * TCP SOCK_STREAM
    * UDP SOCK_DGRAM
 */
- (id)initOnPort: (int)port;

/**
 Handle connections
 
 Start a new thread to handle each connection
 */
- (void)echoServerListenWithDescriptor: (int)lfd;

@end

#endif /* server_h */
