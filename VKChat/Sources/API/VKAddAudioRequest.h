//
//  VKAddAudioRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 26.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKAddAudioRequestResultBlock)(NSInteger audioID);

@interface VKAddAudioRequest : VKRequest {
    NSInteger audioID;
    NSInteger userID;
    NSInteger groupID;
    VKAddAudioRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger audioID;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger groupID;

- (void)startWithResultBlock:(VKAddAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
