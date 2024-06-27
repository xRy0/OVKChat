//
//  VKMessagesController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessagesController.h"

@implementation VKMessagesController

- (void)refresh {
    [dialogsController refresh];
}

- (void)setDialogsInactive {
    [dialogsController setDialogsInactive];
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (proposedPosition <= VK_SPLIT_DIALOGS_MIN_SIZE) {
        return VK_SPLIT_DIALOGS_MIN_SIZE;
    }
    
    if (proposedPosition >= VK_SPLIT_DIALOGS_MAX_SIZE) {
        return VK_SPLIT_DIALOGS_MAX_SIZE;
    }
    
    return proposedPosition;
}

@end
