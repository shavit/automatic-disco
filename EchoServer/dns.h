//
//  dns.h
//  EchoServer
//
//  Created by Shavit Tzuriel on 1/22/19.
//  Copyright © 2019 Shavit. All rights reserved.
//

#ifndef dns_h
#define dns_h

#import <Foundation/Foundation.h>

#import <netdb.h>
#import <netinet/in.h>
#import <netinet6/in6.h>

@interface DNS : NSObject

typedef NS_ENUM(NSUInteger, EndianType) {
    ENDIAN_UNKNOWN,
    ENDIAN_LITTLE,
    ENDIAN_BIG
};

@property (nonatomic, strong) NSString *hostname, *service;
@property (nonatomic) struct addrinfo *results;
@property (nonatomic) struct sockaddr *sa;
@property (nonatomic, readonly) int errorCode;

-(void) addrWithHostname: (NSString*)Hostname Service:
    (NSString *)lService andHints: (struct addrinfo*)lHints;
-(void)nameWithSockaddr: (struct sockaddr *)saddr;

-(NSString *)errorString;

@end

#endif /* dns_h */
