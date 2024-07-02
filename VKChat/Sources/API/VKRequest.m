//
//  VKRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

@implementation VKRequest

@synthesize accessToken = _accessToken;
@synthesize showResponseLog;
@synthesize showRequestLog;

- (void)dealloc {
    [_accessToken release];
    [_apiURI release];
    [_parameters release];
    [_method release];
    [_request release];
    [_failureBlock release];
    [_error release];
    [_response release];

    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        [self _init];
    }
    
    return self;
}

- (void)_init {
    _apiURI = [[NSString stringWithFormat:@"%@%@", API_URL, @"/method"] copy];
    _parameters = [[NSMutableArray alloc] init];
    _method = @"";
    _accessToken = @"";
    _version = @"5.0";
    _responseType = VKRequestResponseTypeJSON;
    _error = nil;
    
    self.showResponseLog = YES;
    self.showRequestLog = YES;
}

- (void)addParamWithKey:(id)key value:(id)value {
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:value, @"value", key, @"key", nil];
    [_parameters addObject:dict];
}

- (void)start {
    NSString *params = @"";
    
    for (NSDictionary *dict in _parameters) {
        params = [params stringByAppendingFormat:@"%@=%@&", [dict objectForKey:@"key"], [dict objectForKey:@"value"]];
    }
    
    if (_responseType == VKRequestResponseTypeXML) {
        _method = [_method stringByAppendingString:@".xml"];
    }
    
    NSURL *url = [NSURL URLWithString:[[NSString stringWithFormat:@"%@/%@?%@access_token=%@&v=%@", _apiURI, _method, params, _accessToken, _version] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if ([_method  isEqual: @"messages.send"] || [_method  isEqual: @"status.set"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?%@access_token=%@&v=%@", _apiURI, _method, params, _accessToken, _version]];
    }
    _request = [[ASIHTTPRequest alloc] initWithURL:url];
    _request.timeOutSeconds = 60;
    _request.delegate = self;

    if (showRequestLog) {
        NSLog(@"SEND REQUST TO : %@", [url absoluteString]);
    }
    
    [_request startAsynchronous];
}

- (void)parseResponse {
    NSDictionary *dict = [_response objectForKey:@"error"];
    
    if (showResponseLog) {
        NSLog(@"%@", _method);
        NSLog(@"%@", _response);
    }
    
    if (dict) {
        int code = [[dict objectForKey:@"error_code"] intValue];
    
        NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
        [errorDetails setValue:[dict objectForKey:@"error_msg"] forKey:NSLocalizedDescriptionKey];
        
        if (code == 14) {
            [errorDetails setValue:[dict objectForKey:@"captcha_sid"] forKey:VK_ERROR_CAPTCHA_ID];
            [errorDetails setValue:[dict objectForKey:@"captcha_img"] forKey:VK_ERROR_CAPTCHA_IMG];
        }
        
        _error = [[NSError errorWithDomain:VK_ERROR_DOMAIN code:code userInfo:errorDetails] retain];
        
        if (_failureBlock) {
            _failureBlock(_error);
        }
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (_responseType == VKRequestResponseTypeJSON) {
        _response = [[request.responseString JSONValue] retain];
    }
    
    [self parseResponse];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    if (_failureBlock) {
        _failureBlock(request.error);
    }
}

@end
