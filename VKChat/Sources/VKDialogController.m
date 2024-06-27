//
//  VKDialogController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 10.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDialogController.h"

@implementation VKDialogController

@synthesize dialog;

- (void)dealloc {
    [dialog release];
    [super dealloc];
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    
    [dialog addDelegate:messagesController];
}

- (void)refresh {
    if (dialog.isChat) {
        self.window.title = dialog.title;
    } else {
        VKProfile *profile = [[dialog profiles] objectAtIndex:0];
        self.window.title = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
    }
    
    messagesController.dialog = dialog;
    [messagesController refresh];
}

- (void)windowWillClose:(NSNotification *)notification {
    [dialog removeDelegate:messagesController];
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
    dialog.isActive = YES;
}

- (void)windowDidResignMain:(NSNotification *)notification {
    dialog.isActive = NO;
}

@end
