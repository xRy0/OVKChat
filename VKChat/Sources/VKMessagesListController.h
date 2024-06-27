//
//  VKDialogController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 14.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKMessage.h"
#import "VKDialog.h"
#import "VKMessagesHistoryRequest.h"
#import "VKSendMessageRequest.h"
#import "VKGetMessageByIDRequest.h"
#import "VKSetActivityRequest.h"
#import "VKImageController.h"
#import "VKTileBackgroundView.h"
#import "VKMarkAsReadRequest.h"
#import "VKProfileRequest.h"
#import "VKMessagesInfoCell.h"
#import "VKMessageLeftCell.h"
#import "VKMessageRightCell.h"
#import "VKMessagesInfoCell.h"
#import "VKMessageGroupCell.h"
#import "VKCaptchaController.h"
#import "VKMessagesListView.h"
#import "NSScrollView+Utilites.h"
#import "VKLoadMoreView.h"
#import "VKMessageTextView.h"

@interface VKMessagesListController : NSObject <NSTextFieldDelegate, VKCaptchaControllerDelegate, VKDialogDelegate> {
    IBOutlet NSTableView *view;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet VKTileBackgroundView *tileView;
    IBOutlet NSView *messageView;
    IBOutlet NSView *shadowView;
    IBOutlet NSScrollView *listView;
    IBOutlet VKMessagesListView *contentView;
    IBOutlet VKMessageTextView *messageTextView;
    IBOutlet NSScrollView *messageScrollView;
    NSDate *lastActivity;
    NSDate *lastTyping;
    VKImageController *imageController;
    VKCaptchaController *captchaController;
    BOOL isUserTyping;
    NSInteger typingUserID;
    NSMutableArray *_items;
    BOOL _isLoadMore;
    NSInteger deletedRow;
    BOOL _isRequestInProgress;
    NSMutableDictionary *_unsendMessages;
}

@property (nonatomic, retain) VKDialog *dialog;

- (void)refresh;
- (void)sendMessage:(NSString *)message captchaID:(NSInteger)captchaID captchaText:(NSString *)captchaText;

- (IBAction)sendMessage:(id)sender;

@end
