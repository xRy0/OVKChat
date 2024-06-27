//
//  VKGetCityByIdRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 27.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"

typedef void (^VKGetCityByIdRequestResultBlock)(NSString *name);

@interface VKGetCityByIdRequest : VKRequest {
    NSInteger cityID;
    VKGetCityByIdRequestResultBlock _resultBlock;
}

@property (nonatomic, assign) NSInteger cityID;

- (void)startWithResultBlock:(VKGetCityByIdRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
