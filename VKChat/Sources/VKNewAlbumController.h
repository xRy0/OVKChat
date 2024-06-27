//
//  VKNewAlbumController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 09.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKCreateAlbumRequest.h"

@interface VKNewAlbumController : NSWindowController {
    IBOutlet NSTextField *titleField;
    IBOutlet NSTextField *descriptionField;
    IBOutlet NSPopUpButton *privacyButton;
    IBOutlet NSPopUpButton *commentPrivacyButton;
    IBOutlet NSButton *doneButton;
    IBOutlet NSButton *cancelButton;
    IBOutlet NSTextField *privacyLabel;
    IBOutlet NSTextField *commentPrivacyLabel;
}

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
