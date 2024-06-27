//
//  VKDeleteDialogRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKDeleteDialogRequestResultBlock)();

@interface VKDeleteDialogRequest : VKRequest {
    VKDeleteDialogRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) NSInteger limit;

- (void)startWithResultBlock:(VKDeleteDialogRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
