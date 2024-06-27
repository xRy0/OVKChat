//
//  VKSetActivityRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKSetActivityRequestResultBlock)();

@interface VKSetActivityRequest : VKRequest {
    VKSetActivityRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *type;

- (void)startWithResultBlock:(VKSetActivityRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
