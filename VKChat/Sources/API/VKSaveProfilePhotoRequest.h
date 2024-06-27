//
//  VKSaveProfilePhotoRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 28.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKSaveProfilePhotoRequestResultBlock)(NSString *hash, NSURL *url);

@interface VKSaveProfilePhotoRequest : VKRequest {
    NSInteger serverID;
    NSString *photo;
    NSString *hash;
    VKSaveProfilePhotoRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger serverID;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *hash;

- (void)startWithResultBlock:(VKSaveProfilePhotoRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
