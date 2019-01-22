//
//  main.cpp
//  EchoServer
//
//  Created by Shavit Tzuriel on 1/21/19.
//  Copyright © 2019 Shavit. All rights reserved.
//

#include "main.h"
#import <sys/types.h>
#import <arpa/inet.h>

@implementation BSDSocketClient

- (id) initWithAddress:(NSString *)addr andPort:(int)port {
    self = [super init];
    if (self) {
        struct sockaddr_in servaddr;
        
        self.errorCode = NOERROR;
        if ( (self.sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
            self.errorCode = SOCKETERROR;
        } else {
            memset(&servaddr, 0, sizeof(servaddr));
            servaddr.sin_family = AF_INET;
            servaddr.sin_port = htons(port);
            inet_pton(AF_INET, [addr cStringUsingEncoding:NSUTF8StringEncoding], &servaddr.sin_addr);
            
            if (connect(self.sockfd, (struct sockaddr *) &servaddr, sizeof(servaddr)) < 0) {
                self.errorCode = CONNECTERROR;
            }
        }
    }
    
    return self;
}

- (ssize_t)writterToSocket:(int)sockfdNum withChar:(NSString *)vptr {
    size_t nleft;
    ssize_t nwritten;
    
}

- (NSString *)recvFromSocket:(int)lsockfd withMaxChar:(int)max {
    
}

@end

int main(int argc, const char * argv[]) {
    // insert code here...
    std::cout << "Hello, World!\n";
    return 0;
}
