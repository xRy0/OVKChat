//
//  VKAudioSearchRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 25.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"
#import "VKSong.h"

enum VKSearchAudioOrderType {
    VKSearchAudioOrderTypeDate = 0,
    VKSearchAudioOrderTypeDuration = 1,
    VKSearchAudioOrderTypeRate = 2
};

typedef enum VKSearchAudioOrderType VKSearchAudioOrderType;

typedef void (^VKSearchAudioRequestResultBlock)(NSArray *songs);

@interface VKSearchAudioRequest : VKRequest {
    NSString *query;
    BOOL autoComplete;
    VKSearchAudioOrderType sort;
    BOOL isHasLyrics;
    NSInteger count;
    NSInteger offset;
    VKSearchAudioRequestResultBlock _resultBlock;
}

@property (nonatomic, copy) NSString *query;
@property (nonatomic, assign) BOOL autoComplete;
@property (nonatomic, assign) VKSearchAudioOrderType sort;
@property (nonatomic, assign) BOOL isHasLyrics;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger offset;

- (void)startWithResultBlock:(VKSearchAudioRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
