//
//  VKAccessToken.m
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAccessToken.h"

static NSString *_token;
static NSDate *_expires;
static NSInteger _userID;

@implementation VKAccessToken

+ (void)setToken:(NSString *)token {
    [_token release];
    _token = [token copy];
}

+ (void)setExpires:(NSDate *)expires {
    [_expires release];
    _expires = [expires retain];
}

+ (void)setUserID:(NSInteger)userID {
    _userID = userID;
}

+ (NSString *)token {
    return _token;
}

+ (NSDate *)expires {
    return _expires;
}

+ (NSInteger)userID {
    return _userID;
}

+ (BOOL)isValid {
    if (_token == nil) {
        return NO;
    }
    
    if ([_expires timeIntervalSince1970] > [[NSDate date] timeIntervalSince1970]) {
        return NO;
    }
    
    return YES;
}

+ (void)load {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _token = [[defaults objectForKey:@"Token"] copy];
    _expires = [[defaults objectForKey:@"TokenExpires"] retain];
    _userID = [defaults integerForKey:@"UserID"];
}

+ (void)save {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:_token forKey:@"Token"];
    [defaults setObject:_expires forKey:@"TokenExpires"];
    [defaults setInteger:_userID forKey:@"UserID"];
    
    [defaults synchronize];
}

+ (void)clear {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"Token"];
    [defaults removeObjectForKey:@"TokenExpires"];
    [defaults removeObjectForKey:@"UserID"];
    
    [defaults synchronize];
    
    [_token release];
    _token = nil;
}

@end
