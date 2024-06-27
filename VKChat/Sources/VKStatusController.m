//
//  VKStatusController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 21.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKStatusController.h"

@implementation VKStatusController

- (void)awakeFromNib {
    self.window.title = VK_STR_STATUS;
    
    [cancelButton setTitle:VK_STR_CANCEL];
    [doneButton setTitle:VK_STR_CHANGE];
    
    [[statusField cell] setPlaceholderString:VK_STR_STATUS_PLACEHOLDER];
}

- (IBAction)done:(id)sender {
    __block VKSetStatusRequest *request = [[VKSetStatusRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.text = statusField.stringValue;
    
    VKSetStatusRequestResultBlock resultBlock = ^(NSString *status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_STATUS object:status];
        [self cancel:nil];
        
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (IBAction)cancel:(id)sender {
    [self close];
    [NSApp endSheet:self.window];
    [self.window orderOut:self];
}

@end
