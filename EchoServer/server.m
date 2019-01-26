//
//  server.m
//  EchoServer
//
//  Created by Shavit Tzuriel on 1/26/19.
//  Copyright © 2019 Shavit. All rights reserved.
//

#import "server.h"
#import <sys/types.h>
#import <arpa/inet.h>

@implementation Server

- (instancetype)initOnPort:(int)port {
    self = [super init];
    
    if (self) {
        struct sockaddr_in servaddr;
        self.errorCode = NOERROR;
        
        // Create the socket
        self.listenfd = socket(AF_INET, SOCK_STREAM, 0);
        if (self.listenfd < 0) {
            self.errorCode = SOCKETERROR;
        } else {
            memset(&servaddr, 0, sizeof(servaddr));
            servaddr.sin_family = AF_INET;
            servaddr.sin_addr.s_addr = htonl(INADDR_ANY);
            servaddr.sin_port = htons(port);
            
            if (bind(self.listenfd, (struct sockaddr *)&servaddr, sizeof(servaddr)) < 0) {
                self.errorCode = BINDERROR;
            } else {
                if ((listen(self.listenfd, LISTENQ)) < 0) {
                    self.errorCode = LISTENERROR;
                }
            }
        }
    }
    
    return self;
}

- (void)echoServerListenWithDescriptor:(int)lfd {
    
}

@end
