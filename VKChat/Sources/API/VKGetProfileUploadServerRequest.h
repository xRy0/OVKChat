//
//  VKGetProfileUploadServerRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 28.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKGetProfileUploadServerRequestResultBlock)(NSURL *url);

@interface VKGetProfileUploadServerRequest : VKRequest {
    VKGetProfileUploadServerRequestResultBlock _resultBlock;
}

- (void)startWithResultBlock:(VKGetProfileUploadServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
