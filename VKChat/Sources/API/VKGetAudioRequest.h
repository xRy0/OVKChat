//
//  VKGetAudioRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKSong.h"

typedef void (^VKGetAudioRequestResultBlock)(NSArray *songs);

@interface VKGetAudioRequest : VKRequest {
    VKGetAudioRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger groupID;
@property (nonatomic, assign) NSInteger albumID;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;

- (void)startWithResultBlock:(VKGetAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end