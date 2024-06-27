//
//  VKSavePhotoRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 24.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"
#import "VKPhoto.h"

typedef void (^VKSavePhotoRequestResultBlock)(NSArray *photos);

@interface VKSavePhotosRequest : VKRequest {
    VKSavePhotoRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger albumID;
@property (nonatomic, assign) NSInteger serverID;
@property (nonatomic, copy) NSString *photosList;
@property (nonatomic, copy) NSString *hash;

- (void)startWithResultBlock:(VKSavePhotoRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
