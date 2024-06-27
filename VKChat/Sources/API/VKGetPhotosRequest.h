//
//  VKGetPhotosRequest.h
//  VKChat
//
//  Created by Sergey Lenkov on 29.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKPhoto.h"

typedef void (^VKGetPhotosRequestResultBlock)(NSArray *photos);

@interface VKGetPhotosRequest : VKRequest {
    VKGetPhotosRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger groupID;
@property (nonatomic, assign) NSInteger albumID;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;

- (void)startWithResultBlock:(VKGetPhotosRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
