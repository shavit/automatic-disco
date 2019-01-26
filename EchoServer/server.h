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
 Constructor method
 */
- (id)initOnPort: (int)port;

/**
 Start the server
 */
- (void)echoServerListenWithDescriptor: (int)lfd;

@end

#endif /* server_h */
