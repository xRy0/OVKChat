//
//  VKCreateAlbumRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 09.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"
#import "VKAlbum.h"

enum VKAlbumPrivacy {
    VKAlbumPrivacyAll = 0,
    VKAlbumPrivacyFriends = 1,
    VKAlbumPrivacyEachOther = 2,
    VKAlbumPrivacyMe = 3
};

typedef enum VKAlbumPrivacy VKAlbumPrivacy;

enum VKCommentPrivacy {
    VKCommentPrivacyAll = 0,
    VKCommentPrivacyFriends = 1,
    VKCommentPrivacyEachOther = 2,
    VKCommentPrivacyMe = 3
};

typedef enum VKCommentPrivacy VKCommentPrivacy;

typedef void (^VKCreateAlbumRequestResultBlock)(VKAlbum *album);

@interface VKCreateAlbumRequest : VKRequest {
    VKCreateAlbumRequestResultBlock _resultBlock;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *note;
@property (nonatomic, assign) VKAlbumPrivacy privacy;
@property (nonatomic, assign) VKCommentPrivacy commentPrivacy;
@property (nonatomic, assign) NSInteger groupID;

- (void)startWithResultBlock:(VKCreateAlbumRequestResultBlock)aResultBlock failureBlock:(VKRequestFailureBlock)aFailureBlock;

@end
