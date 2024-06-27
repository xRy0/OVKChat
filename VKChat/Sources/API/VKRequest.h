//
//  VKRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "VKAccessToken.h"

enum VKRequestResponseType {
    VKRequestResponseTypeJSON = 0,
    VKRequestResponseTypeXML = 1
};

typedef enum VKRequestResponseType VKRequestResponseType;

typedef void (^VKRequestFailureBlock)(NSError *error);

@interface VKRequest : NSObject <ASIHTTPRequestDelegate> {
    NSString *_apiURI;
    NSString *_method;
    NSString *_accessToken;
    NSString *_version;
    NSMutableArray *_parameters;
    ASIHTTPRequest *_request;
    VKRequestFailureBlock _failureBlock;
    VKRequestResponseType _responseType;
    id _response;
    NSError *_error;
}

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, assign) BOOL showResponseLog;
@property (nonatomic, assign) BOOL showRequestLog;

- (void)start;
- (void)addParamWithKey:(id)key value:(id)value;
- (void)parseResponse;
- (void)_init;

@end
