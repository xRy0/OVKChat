//
//  VKOAuthRequest.h
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

enum VKDisplayType {
    VKDisplayTypePage = 0,
    VKDisplayTypePopup = 1,
    VKDisplayTypeTouch = 2,
    VKDisplayTypeWap = 3,
};

typedef enum VKDisplayType VKDisplayType;

@interface VKOAuthRequest : NSObject

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, assign) VKDisplayType displayType;
@property (nonatomic, copy) NSString *redirectURI;
@property (nonatomic, assign) BOOL needNotify;
@property (nonatomic, assign) BOOL needFriends;
@property (nonatomic, assign) BOOL needPhotos;
@property (nonatomic, assign) BOOL needAudio;
@property (nonatomic, assign) BOOL needVideo;
@property (nonatomic, assign) BOOL needDocs;
@property (nonatomic, assign) BOOL needNotes;
@property (nonatomic, assign) BOOL needPages;
@property (nonatomic, assign) BOOL needOffers;
@property (nonatomic, assign) BOOL needQuestions;
@property (nonatomic, assign) BOOL needWall;
@property (nonatomic, assign) BOOL needGroups;
@property (nonatomic, assign) BOOL needMessages;
@property (nonatomic, assign) BOOL needNotifications;
@property (nonatomic, assign) BOOL needStats;
@property (nonatomic, assign) BOOL needAds;
@property (nonatomic, assign) BOOL needOffline;
@property (nonatomic, assign) BOOL needStatus;

- (NSURL *)oathURL;

@end
