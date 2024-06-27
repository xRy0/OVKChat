//
//  ASIWebDAVRequest.h
//  S3Sync
//
//  Created by Sergey Lenkov on 07.03.11.
//  Copyright 2011 Positive Team. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "NSDate+Utilites.h"
#import "RegexKitLite.h"
#import "NSString+HTML.h"

@interface ASIWebDAVRequest : ASIHTTPRequest {
    
}

+ (NSString *)username;
+ (void)setUsername:(NSString *)newUsername;
+ (NSString *)password;
+ (void)setPassword:(NSString *)newPassword;
+ (NSString *)host;
+ (void)setHost:(NSString *)newHost;

+ (id)requestWithPath:(NSString *)path;
+ (id)PUTRequestForData:(NSData *)data withPath:(NSString *)path;
+ (id)PUTRequestForFile:(NSString *)filePath withPath:(NSString *)path;
+ (id)PROPFINDRequestWithPath:(NSString *)path;
+ (id)MKCOLRequestWithPath:(NSString *)path;
+ (id)DELETERequestWithPath:(NSString *)path;

+ (NSString *)urlWithPath:(NSString *)path;
+ (NSString *)stringByURLEncodingForWebDAVPath:(NSString *)path;

- (NSDictionary *)properties;

@end
