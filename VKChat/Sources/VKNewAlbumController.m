//
//  VKNewAlbumController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 09.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKNewAlbumController.h"

@implementation VKNewAlbumController

- (void)awakeFromNib {
    self.window.title = VK_STR_NEW_ALBUM;
    [cancelButton setTitle:VK_STR_CANCEL];
    [doneButton setTitle:VK_STR_CREATE_NEW_ALBUM];
    
    [privacyButton removeAllItems];
    
    [privacyButton addItemWithTitle:VK_STR_RIGHTS_ALL];
    [privacyButton addItemWithTitle:VK_STR_RIGHTS_FRIENDS];
    [privacyButton addItemWithTitle:VK_STR_RIGHTS_EACHOTHER];
    [privacyButton addItemWithTitle:VK_STR_RIGHTS_ME];
    
    [commentPrivacyButton removeAllItems];
    
    [commentPrivacyButton addItemWithTitle:VK_STR_RIGHTS_ALL];
    [commentPrivacyButton addItemWithTitle:VK_STR_RIGHTS_FRIENDS];
    [commentPrivacyButton addItemWithTitle:VK_STR_RIGHTS_EACHOTHER];
    [commentPrivacyButton addItemWithTitle:VK_STR_RIGHTS_ME];
    
    privacyLabel.stringValue = VK_STR_ALBUM_RIGHTS;
    commentPrivacyLabel.stringValue = VK_STR_COMMENTS_RIGHTS;
    
    [[titleField cell] setPlaceholderString:VK_STR_ALBUM_NAME_PLACEHOLDER];
    [[descriptionField cell] setPlaceholderString:VK_STR_ALBUM_DESC_PLACEHOLDER];
}

- (IBAction)done:(id)sender {
    __block VKCreateAlbumRequest *request = [[VKCreateAlbumRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.title = titleField.stringValue;
    request.note = descriptionField.stringValue;
    request.privacy = privacyButton.indexOfSelectedItem;
    request.commentPrivacy = commentPrivacyButton.indexOfSelectedItem;
    
    VKCreateAlbumRequestResultBlock resultBlock = ^(VKAlbum *album) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_UPDATE_ALBUMS object:nil];
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
