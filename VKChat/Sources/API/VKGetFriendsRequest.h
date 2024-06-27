//
//  VKGetFriendsRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"
#import "VKProfile.h"

typedef void (^VKGetFriendsRequestResultBlock)(NSArray *friends);

@interface VKGetFriendsRequest : VKRequest {
    VKGetFriendsRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (void)startWithResultBlock:(VKGetFriendsRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
