//
//  VKDialogController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 10.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKDialog.h"
#import "VKMessagesListController.h"

@interface VKDialogController : NSWindowController {
    IBOutlet VKMessagesListController *messagesController;
}

@property (nonatomic, retain) VKDialog *dialog;

- (void)refresh;

@end
