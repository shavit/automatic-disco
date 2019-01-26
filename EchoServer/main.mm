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

/*
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
    const char *ptr = [vptr cStringUsingEncoding:NSUTF8StringEncoding];
    
    nleft = sizeof(ptr);
    size_t n = nleft;
    while (nleft > 0) {
        if ((nwritten = write(sockfdNum, ptr, nleft)) <= 0) {
            if (nwritten < 0 && errno == EINTR) {
                nwritten = 0;
            } else {
                self.errorCode = WRITEERROR;
                return(-1);
            }
        }
        
        nleft -= nwritten;
        ptr += nwritten;
    }
    
    return (n);
}

- (NSString *)recvFromSocket:(int)lsockfd withMaxChar:(int)max {
    char recvline[max];
    ssize_t n;
    
    if ((n = recv(lsockfd, recvline, max-1, 0)) > 0) {
        recvline[n] = '\0';
        return [NSString stringWithCString:recvline encoding:NSUTF8StringEncoding];
    } else {
        self.errorCode = READERROR;
        return @"Server terminated";
    }
}

@end
*/

int performAddressResolution() {
    struct addrinfo *res; // Temporary store when looping through the linked list
    struct addrinfo hints; // Hints for the type of addresses
    
    memset(&hints, 0, sizeof hints); // Ensure that the memory address is not corrupt
    hints.ai_family = AF_UNSPEC;
    hints.ai_socktype = SOCK_STREAM; // Limit to socket streams
    
    DNS *ai = [[DNS alloc] init];
    [ai addrWithHostname: @"livestream.com" Service: @"443" andHints: &hints];
    if (ai.errorCode != 0) {
        NSLog(@"Error:  %@", [ai errorString]);
        return -1;
    }
    
    struct addrinfo *results = ai.results;
    for (res = results; res != NULL; res = res->ai_next) {
        void *addr;
        NSString *ipver = @"";
        char ipstr[INET6_ADDRSTRLEN];
        
        if (res->ai_family == AF_INET) {
            struct sockaddr_in *ipv4 = (struct sockaddr_in*) res->ai_addr;
            addr = &(ipv4->sin_addr);
            ipver = @"IPv4";
        } else if (res->ai_family == AF_INET6) {
            struct sockaddr_in6 *ipv6 = (struct sockaddr_in6 *) res->ai_addr;
            addr = &(ipv6->sin6_addr);
            ipver = @"IPv6";
        } else {
            continue;
        }
        
        inet_ntop(res->ai_family, addr, ipstr, sizeof(ipstr));
        NSLog(@"Result: %@ %s", ipver, ipstr);
        
        DNS *aiTmp = [[DNS alloc] init];
        [aiTmp nameWithSockaddr:res->ai_addr];
        if (aiTmp.errorCode == 0) {
            NSLog(@"%@ %@", aiTmp.hostname, aiTmp.service);
        }
    }
    
    freeaddrinfo(results);
    
    return 0;
}

int main(int argc, const char * argv[]) {
    int addrRes;
    
    addrRes = performAddressResolution();
    NSLog(@"Address resolution: %d", addrRes);
    
    return 0;
}
