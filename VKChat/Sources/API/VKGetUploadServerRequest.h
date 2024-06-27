//
//  VKGetUploadServer.h
//  VKMessages
//
//  Created by Sergey Lenkov on 24.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKGetUploadServerRequestResultBlock)(NSURL *url, NSInteger albumID);

@interface VKGetUploadServerRequest : VKRequest {
    VKGetUploadServerRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger albumID;
@property (nonatomic, assign) NSInteger groupID;

- (void)startWithResultBlock:(VKGetUploadServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
