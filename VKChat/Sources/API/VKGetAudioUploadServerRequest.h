//
//  VKGetAudioUploadServerRequest
//  VKChat
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKGetAudioUploadServerRequestResultBlock)(NSURL *url);

@interface VKGetAudioUploadServerRequest : VKRequest {
    VKGetAudioUploadServerRequestResultBlock _resultBlock;
}

- (void)startWithResultBlock:(VKGetAudioUploadServerRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
