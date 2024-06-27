//
//  VKCreateAlbumRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 09.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKCreateAlbumRequest.h"

@implementation VKCreateAlbumRequest

@synthesize title;
@synthesize note;
@synthesize privacy;
@synthesize commentPrivacy;
@synthesize groupID;

- (void)dealloc {
    [title release];
    [note release];
    [_resultBlock release];
    [super dealloc];
}

- (id)init {
    self = [super init];
    
    if (self) {
        self.title = @"";
        self.note = @"";
        self.privacy = VKAlbumPrivacyFriends;
        self.commentPrivacy = VKAlbumPrivacyFriends;
        self.groupID = -1;
    }
    
    return self;
}

- (void)startWithResultBlock:(VKCreateAlbumRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock {
    _resultBlock = [aResultBlock copy];
    _failureBlock = [aFailureBlock copy];
    
    _method = @"photos.createAlbum";
    
    [self addParamWithKey:@"title" value:[self.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self addParamWithKey:@"privacy" value:[NSString stringWithFormat:@"%d", self.privacy]];
    [self addParamWithKey:@"comment_privacy" value:[NSString stringWithFormat:@"%d", self.commentPrivacy]];
    
    if ([self.note length] > 0) {
        [self addParamWithKey:@"description" value:[self.note stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    
    if (self.groupID > 0) {
        [self addParamWithKey:@"gid" value:[NSString stringWithFormat:@"%ld", self.groupID]];
    }
    
    [self start];
}

- (void)parseResponse {
    [super parseResponse];
    
    if (!_error) {
        VKAlbum *album = [[[VKAlbum alloc] initWithDictionary:[_response objectForKey:@"response"]] autorelease];
        
        if (_resultBlock) {
            _resultBlock(album);
        }
    }
}

@end
