//
//  dns.m
//  EchoServer
//
//  Created by Shavit Tzuriel on 1/22/19.
//  Copyright © 2019 Shavit. All rights reserved.
//

#import "dns.h"

@implementation DNS

struct addrinfo *res;
struct addrinfo hints;

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setVars];
    }
    return self;
}

-(void) setVars {
    self.hostname = NULL;
    self.service = NULL;
    self.results = NULL;
    _errorCode = 0;
}

- (void)addrWithHostname:(NSString *)lHostname Service:(NSString *)lService andHints:(struct addrinfo *)lHints {
    [self setVars];
    self.hostname = lHostname;
    self.service = lService;
    
    struct addrinfo *res;
    
    _errorCode = getaddrinfo([_hostname UTF8String],
                                [_service UTF8String],
                             lHints, &res);
    self.results = res;
}

- (void)nameWithSockaddr:(struct sockaddr *)saddr {
    [self setVars];
    char host[1024];
    char serv[20];
    
    _errorCode = getnameinfo(saddr, sizeof saddr, host, sizeof host, serv, sizeof serv, 0);
    self.hostname = [NSString stringWithUTF8String:host];
    self.service = [NSString stringWithUTF8String:serv];
}

- (NSString *)errorString {
    return [NSString stringWithCString:gai_strerror(_errorCode)
                              encoding:NSASCIIStringEncoding];
}

- (void)setResults:(struct addrinfo *)lResults {
    freeaddrinfo(self.results);
    _results = lResults;
}

/**
 Find the host byte order
 */
-( EndianType) byteOrder {
    union {
        short sNum;
        char cNum[sizeof(short)];
    } un;
    un.sNum = 0x0102;
    if (sizeof(short) == 2) {
        if (un.cNum[0] == 1 && un.cNum[1] == 2) {
            return ENDIAN_BIG;
        } else if (un.cNum[0] == 2 && un.cNum[1] == 1) {
            return ENDIAN_LITTLE;
        } else {
            return ENDIAN_UNKNOWN;
        }
    } else {
        return ENDIAN_UNKNOWN;
    }
}

@end
