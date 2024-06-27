//
//  VKMessagesController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKDialogsListController.h"

@interface VKMessagesController : NSViewController {
    IBOutlet VKDialogsListController *dialogsController;
}

- (void)refresh;
- (void)setDialogsInactive;

@end
