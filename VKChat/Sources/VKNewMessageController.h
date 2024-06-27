//
//  VKNewDialogController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKRequest.h"
#import "VKGetFriendsRequest.h"
#import "VKSendMessageRequest.h"

@interface VKNewMessageController : NSWindowController {
    IBOutlet NSComboBox *friendsButton;
    IBOutlet NSTextField *messageField;
    IBOutlet NSButton *doneButton;
    IBOutlet NSButton *cancelButton;
    IBOutlet NSTextField *toLabel;
    NSArray *_friends;
    NSMutableArray *_filteredFriends;
}

- (void)refresh;

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
