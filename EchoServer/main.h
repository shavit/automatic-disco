//
//  main.h
//  EchoServer
//
//  Created by Shavit Tzuriel on 1/21/19.
//  Copyright © 2019 Shavit. All rights reserved.
//

#ifndef main_h
#define main_h

#include <iostream>
#include <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BSDClientErrorCode) {
    NOERROR,
    SOCKETERROR,
    CONNECTERROR,
    READERROR,
    WRITEERROR
};

#define MAXLINE 4096;

@interface BSDSocketClient : NSObject

@property (nonatomic) int errorCode, sockfd;

-(instancetype) initWithAddress : (NSString *) addr andPort : (int)port;

-(ssize_t) writterToSocket: (int)sockfdNum withChar: (NSString *)vptr;

-(NSString *) recvFromSocket: (int)lsockfd withMaxChar: (int)max;

@end

#endif /* main_h */
