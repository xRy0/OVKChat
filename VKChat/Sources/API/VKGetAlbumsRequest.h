//
//  VKAlbumsRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKAlbum.h"

typedef void (^VKGetAlbumsRequestResultBlock)(NSArray *albums);

@interface VKGetAlbumsRequest : VKRequest {
    VKGetAlbumsRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger groupID;

- (void)startWithResultBlock:(VKGetAlbumsRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
