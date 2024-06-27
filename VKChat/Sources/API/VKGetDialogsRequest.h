//
//  VKDialogsRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKRequest.h"
#import "VKMessage.h"
#import "VKDialog.h"

typedef void (^VKGetDialogsRequestResultBlock)(NSArray *messages);

@interface VKGetDialogsRequest : VKRequest {
    VKGetDialogsRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger previewLength;

- (void)startWithResultBlock:(VKGetDialogsRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
