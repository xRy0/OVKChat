//
//  VKNewDialogController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 22.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKNewMessageController.h"

@implementation VKNewMessageController

- (void)awakeFromNib {
    self.window.title = VK_STR_NEW_MESSAGE;
    [cancelButton setTitle:VK_STR_CANCEL];
    [doneButton setTitle:VK_STR_SEND];
    
    [[messageField cell] setPlaceholderString:VK_STR_MESSAGE_PLACEHOLDER];
    toLabel.stringValue = VK_STR_SEND_TO;
    
    [friendsButton setEnabled:NO];
    [doneButton setEnabled:NO];
    
    _filteredFriends = [[NSMutableArray alloc] init];
}

- (void)dealloc {
    [_filteredFriends release];
    [super dealloc];
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    
    if (![self.window setFrameUsingName:@"NewMessage"]) {
		[self.window center];
	}
    
    [self refresh];
}

- (void)refresh {
    if ([_friends count] == 0) {
        [_filteredFriends removeAllObjects];
        
        [friendsButton removeAllItems];
        [friendsButton setEnabled:NO];
        
        [[friendsButton cell] setPlaceholderString:VK_STR_LOADING];
        
        [doneButton setEnabled:NO];
        
        __block VKGetFriendsRequest *request = [[VKGetFriendsRequest alloc] init];
        
        request.accessToken = [VKAccessToken token];

        VKGetFriendsRequestResultBlock resultBlock = ^(NSArray *friends) {
            [_friends release];
            _friends = [friends retain];
            
            for (VKProfile *friend in _friends) {
                [friendsButton addItemWithObjectValue:[NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName]];
                [_filteredFriends addObject:friend];
            }
            
            [[friendsButton cell] setPlaceholderString:@""];
            [friendsButton setEnabled:YES];
            
            [doneButton setEnabled:YES];
            
            [friendsButton becomeFirstResponder];
            
            [request release];
        };
        
        VKRequestFailureBlock failureBlock = ^(NSError *error) {
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            
            [request release];
        };
        
        [request startWithResultBlock:resultBlock failureBlock:failureBlock];
    }
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    [friendsButton removeAllItems];
    [_filteredFriends removeAllObjects];
    
    for (VKProfile *friend in _friends) {
        NSString *name = [NSString stringWithFormat:@"%@ %@", friend.firstName, friend.lastName];
        
        if ([friendsButton.stringValue length] == 0) {
            [friendsButton addItemWithObjectValue:name];
            [_filteredFriends addObject:friend];
        } else {
            NSRange range = [[name lowercaseString] rangeOfString:[friendsButton.stringValue lowercaseString]];
            
            if (range.location != NSNotFound) {
                [friendsButton addItemWithObjectValue:name];
                [_filteredFriends addObject:friend];
            }
        }
    }
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)done:(id)sender {
    VKProfile *friend = [_filteredFriends objectAtIndex:friendsButton.indexOfSelectedItem];

    __block VKSendMessageRequest *request = [[VKSendMessageRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.userID = friend.identifier;
    request.message = messageField.stringValue;
    
    VKSendMessageRequestResultBlock resultBlock = ^(NSInteger identifier) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_NEED_UPDATE_MESSAGES object:nil];
        [self cancel:nil];
        
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        NSAlert *alert = [NSAlert alertWithError:error];
        [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        
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
