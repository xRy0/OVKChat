//
//  VKMenuController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 12.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKMenuCell.h"
#import "VKMenuItem.h"
#import "VKMessagesController.h"
#import "VKAudioController.h"
#import "VKPhotoController.h"

@class VKPhotoController, VKMessagesController;

@interface VKMenuController : NSObject {
    IBOutlet NSTableView *view;
    IBOutlet NSView *contentView;
    IBOutlet VKTileBackgroundView *backgroundView;
    NSMutableArray *_menu;
    VKMessagesController *messagesController;
    VKAudioController *audioController;
    VKPhotoController *photoController;
    NSUserDefaults *defaults;
    VKMenuItem *currentItem;
}

- (void)refresh;
- (void)refreshView;

- (IBAction)selectMessages:(id)sender;
- (IBAction)selectAudio:(id)sender;
- (IBAction)selectPhotos:(id)sender;

@end
