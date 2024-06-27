//
//  VKSaveAudioRequest.h
//  VKChat
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"
#import "VKSong.h"

typedef void (^VKSaveAudioRequestResultBlock)(VKSong *song);

@interface VKSaveAudioRequest : VKRequest {
    VKSaveAudioRequestResultBlock _resultBlock;
}

@property (nonatomic, copy) NSString *audio;
@property (nonatomic, assign) NSInteger serverID;
@property (nonatomic, copy) NSString *hash;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;

- (void)startWithResultBlock:(VKSaveAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
