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
            memset(&servaddr, 0, sizeof(servaddr)); // Ensure that the memory address is not corrupt
            servaddr.sin_family = AF_INET;
            servaddr.sin_addr.s_addr = htonl(INADDR_ANY); // Convert the byte order from host to network
            servaddr.sin_port = htons(port); // Convert the byte order from network to host
            
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
    int connfd;
    socklen_t cln;
    struct sockaddr_in clnaddr;
    char buf[MAXLINE];
    
    // Block
    for ( ; ; ) {
        cln = sizeof(clnaddr);
        if ((connfd = accept(lfd, (struct sockaddr *)&clnaddr, &cln)) < 0) {
            if (errno != EINTR) {
                self.errorCode = ACCEPTINGERROR;
                NSLog(@"Error accepting a connection");
            }
        } else {
            self.errorCode = NOERROR;
            NSString *connStr = [NSString stringWithFormat:@"New connection: %s | %d", inet_ntop(AF_INET, &clnaddr.sin_addr, buf, sizeof(buf)), ntohs(clnaddr.sin_port)];
            NSLog(@"%@", connStr);
            
            // Create a thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                [self strServer: @(connfd)];
            });
        }
    }
}

- (void) strServer: (NSNumber *) sockfdNum {
    ssize_t n;
    char buf[MAXLINE];
    
    int sockfd = [sockfdNum intValue];
    // Leave the connection open while there is data to read
    while ((n = recv(sockfd, buf, MAXLINE-1, 0)) > 0) {
        [self written:sockfd char:buf size: n];
        buf[n] = '\0'; // Terminate the buffer, then convert to a string
        NSLog(@"%s", buf);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"textreceived" object:[NSString stringWithCString:buf encoding:NSUTF8StringEncoding]];
    }
    NSLog(@"Closing socket");
    close(sockfd);
}

- (ssize_t) written:(int)sockfdNum char:(const void *)vptr size:(size_t)n {
    size_t nleft;
    ssize_t nwritten;
    const char *ptr; // Beginning of string
    
    ptr = vptr;
    nleft = n;
    while (nleft > 0) {
        if ((nwritten = write(sockfdNum, ptr, nleft)) <= 0) {
            if (nwritten < 0 && errno == EINTR) {
                nwritten = 0;
            } else {
                return -1;
            }
        }
        
        nleft -= nwritten;
        ptr += nwritten;
    }
    
    return n;
}

@end
