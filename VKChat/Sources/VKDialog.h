//
//  VKDialog.h
//  VKMessages
//
//  Created by Sergey Lenkov on 14.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <Growl/Growl.h>
#import "VKProfile.h"
#import "VKMessage.h"
#import "VKMessagesHistoryRequest.h"
#import "VKProfileRequest.h"
#import "VKGetMessageByIDRequest.h"

@class VKDialog;

@protocol VKDialogDelegate <NSObject>

- (void)dialogDidFinishedUpdateMessages:(VKDialog *)dialog;
- (void)dialog:(VKDialog *)dialog didFailUpdateMessages:(NSError *)error;
- (void)dialogDidReceivedNewMessages:(VKDialog *)dialog;
- (void)dialogDidDeleteMessage:(VKDialog *)dialog;

@end

@interface VKDialog : NSObject {
    NSMutableArray *_messages;
    NSMutableArray *_unsendMessages;
    NSMutableArray *_profiles;
    NSMutableArray *_delegates;
    BOOL _isRequestInProgress;
    BOOL _isMessagesLoaded;
	BOOL _newMessageReceived;
}

@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, retain) NSDate *lastUpdate;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSArray *messages;
@property (nonatomic, retain) NSArray *unsendMessages;
@property (nonatomic, assign) NSInteger offset;
@property (nonatomic, assign) BOOL isAllMessagesLoaded;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) BOOL isHasUnread;
@property (nonatomic, assign) BOOL isChat;
@property (nonatomic, assign) BOOL isPhoto;
@property (nonatomic, assign) BOOL isAudio;
@property (nonatomic, assign) BOOL isMessage;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, assign) BOOL isDocument;
@property (nonatomic, assign) BOOL isMap;
@property (nonatomic, retain) NSArray *users;
@property (nonatomic, retain) NSArray *profiles;
@property (nonatomic, retain) NSArray *delegates;
@property (nonatomic, assign) BOOL isActive;

- (id)initWithDictionary:(NSDictionary *)dict;

- (void)clearMessages;
- (void)addMessages:(NSArray *)aMessages;
- (void)addMessage:(VKMessage *)aMessage;

- (void)addUnsendMessage:(NSString *)aMessage;
- (void)removeUnsendMessage:(NSString *)aMessage;

- (void)addProfile:(VKProfile *)profile;
- (void)removeProfiles;

- (void)addDelegate:(id)delegate;
- (void)removeDelegate:(id)delegate;

- (NSComparisonResult)compareLastUpdate:(VKDialog *)dialog;

- (void)updateMessages;

@end
