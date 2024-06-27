//
//  VKStatusController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 21.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKSetStatusRequest.h"

@interface VKStatusController : NSWindowController {
    IBOutlet NSTextField *statusField;
    IBOutlet NSButton *doneButton;
    IBOutlet NSButton *cancelButton;
}

- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end
