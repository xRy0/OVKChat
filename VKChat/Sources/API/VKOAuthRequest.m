//
//  VKOAuthRequest.m
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKOAuthRequest.h"

@implementation VKOAuthRequest

@synthesize appID;
@synthesize appSecret;
@synthesize username;
@synthesize password;
@synthesize displayType;
@synthesize redirectURI;
@synthesize needNotify;
@synthesize needFriends;
@synthesize needPhotos;
@synthesize needAudio;
@synthesize needVideo;
@synthesize needDocs;
@synthesize needNotes;
@synthesize needPages;
@synthesize needOffers;
@synthesize needQuestions;
@synthesize needWall;
@synthesize needGroups;
@synthesize needMessages;
@synthesize needNotifications;
@synthesize needStats;
@synthesize needAds;
@synthesize needOffline;
@synthesize needStatus;

- (id)init {
    self = [super init];
    
    if (self) {
        self.appID = @"";
        self.redirectURI = @"about:blank";
        displayType = VKDisplayTypePage;
        needNotify = NO;
        needFriends = NO;
        needPhotos = NO;
        needAudio = NO;
        needVideo = NO;
        needDocs = NO;
        needNotes = NO;
        needPages = NO;
        needOffers = NO;
        needQuestions = NO;
        needWall = NO;
        needGroups = NO;
        needMessages = NO;
        needNotifications = NO;
        needStats = NO;
        needAds = NO;
        needOffline = NO;
    }
    
    return self;
}

- (void)setUsername:(NSString *)aUsername {
    [username release];
    username = [[aUsername stringByEscapingForURLArgument] copy];
}

- (NSURL *)oathURL {
    //NSString *oauthLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%@&redirect_uri=%@", appID, redirectURI];
    //NSString *oauthLink = [NSString stringWithFormat:@"https://api.vk.com/oauth/token?grant_type=password&client_id=%@&client_secret=%@&username=%@&password=%@", VK_APP_ID, VK_APP_SECRET, username, password];
    NSString *oauthLink = [NSString stringWithFormat:[NSString stringWithFormat:@"%@%@", API_URL, @"/authorize?client_name=%s&redirect_uri=%@&v=5.1"], "OVKChat", redirectURI];
    NSString *type = @"page";
    
    switch (displayType) {
        case VKDisplayTypePage:
            type = @"page";
            break;
        case VKDisplayTypePopup: 
            type = @"popup";
            break;
            
        case VKDisplayTypeTouch:
            type = @"touch";
            break;
            
        case VKDisplayTypeWap:
            type = @"wap";
            break;
            
        default:
            type = @"page";
            break;
    }
    
    oauthLink = [oauthLink stringByAppendingFormat:@"&display=%@", type];
    
    NSString *scope = @"";
    NSInteger rights = 0;
    
    if (needNotify) {
        scope = [scope stringByAppendingString:@"notify,"];
        rights = rights + 1;
    }
    
    if (needFriends) {
        scope = [scope stringByAppendingString:@"friends,"];
        rights = rights + 2;
    }
    
    if (needPhotos) {
        scope = [scope stringByAppendingString:@"photos,"];
        rights = rights + 4;
    }
    
    if (needAudio) {
        scope = [scope stringByAppendingString:@"audio,"];
        rights = rights + 8;
    }
    
    if (needVideo) {
        scope = [scope stringByAppendingString:@"video,"];
        rights = rights + 6;
    }
    
    if (needDocs) {
        scope = [scope stringByAppendingString:@"docs,"];
        rights = rights + 131072;
    }
    
    if (needNotes) {
        scope = [scope stringByAppendingString:@"notes,"];
        rights = rights + 2048;
    }
    
    if (needPages) {
        scope = [scope stringByAppendingString:@"pages,"];
        rights = rights + 2048;
    }
    
    if (needOffers) {
        scope = [scope stringByAppendingString:@"offers,"];
    }
    
    if (needQuestions) {
        scope = [scope stringByAppendingString:@"questions,"];
        rights = rights + 64;
    }
    
    if (needWall) {
        scope = [scope stringByAppendingString:@"wall,"];
        rights = rights + 8192;
    }
    
    if (needGroups) {
        scope = [scope stringByAppendingString:@"groups,"];
        rights = rights + 262144;
    }
    
    if (needMessages) {
        scope = [scope stringByAppendingString:@"messages,"];
        rights = rights + 4096;
    }
    
    if (needNotifications) {
        scope = [scope stringByAppendingString:@"notifications,"];
        rights = rights + 524288;
    }
    
    if (needStats) {
        scope = [scope stringByAppendingString:@"stats,"];
        rights = rights + 1048576;
    }
    
    if (needAds) {
        scope = [scope stringByAppendingString:@"ads,"];
        rights = rights + 32768;
    }
    
    if (needOffline) {
        scope = [scope stringByAppendingString:@"offline,"];
    }
    
    if (needStatus) {
        rights = rights + 1024;
    }
    
    scope = [scope stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];

    oauthLink = [oauthLink stringByAppendingFormat:@"&scope=%@", scope];
    oauthLink = [oauthLink stringByAppendingString:@"&response_type=token"];
    NSLog(@"%@", oauthLink);
    
    return [NSURL URLWithString:oauthLink];
}

@end
