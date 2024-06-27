//
//  VKUserProfileRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 11.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKProfile.h"

typedef void (^VKProfileRequestResultBlock)(VKProfile *profile);

@interface VKProfileRequest : VKRequest {
    VKProfileRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;

- (void)startWithResultBlock:(VKProfileRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
