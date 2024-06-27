//
//  VKAccessToken.h
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAccessToken : NSObject {

}

+ (void)setToken:(NSString *)token;
+ (NSString *)token;
+ (void)setExpires:(NSDate *)expires;
+ (NSDate *)expires;
+ (void)setUserID:(NSInteger)userID;
+ (NSInteger)userID;

+ (BOOL)isValid;

+ (void)save;
+ (void)clear;

@end
