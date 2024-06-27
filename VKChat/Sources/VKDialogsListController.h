//
//  VKDialogsController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKDialog.h"
#import "VKDialogCell.h"
#import "VKDialogInfoCell.h"
#import "VKMessagesListController.h"
#import "VKNewMessageController.h"
#import "VKTrackingTableView.h"
#import "VKDeleteDialogRequest.h"
#import "VKGetDialogsRequest.h"
#import "VKProfileRequest.h"
#import "VKDialogController.h"
#import "PXListView.h"

@interface VKDialogsListController : NSObject <PXListViewDelegate> {
    IBOutlet VKMessagesListController *messagesController;
    IBOutlet NSSearchField *searchField;
    IBOutlet NSProgressIndicator *progressIndicator;
    IBOutlet PXListView	*listView;
    BOOL isDialogsLoaded;
	BOOL isLoadingError;
    NSMutableArray *_dialogs;
    NSMutableArray *_filteredDialogs;
    VKNewMessageController *messageController;
    NSInteger deleteRowIndex;
	NSInteger lastSelectedRowIndex;
    NSUserDefaults *defaults;
    NSInteger offset;
    NSInteger count;
    NSInteger totalProfilesCount;
    BOOL isRequestInProgress;
    NSString *infoText;
    NSMutableDictionary *profilesInProgress;
    NSMutableArray *openDialogs;
	BOOL isNeedReloadDialogs;
}

@property (nonatomic, retain) NSArray *dialogs;

- (void)refresh;
- (void)setDialogsInactive;

- (IBAction)newDialog:(id)sender;
- (IBAction)search:(id)sender;

@end
