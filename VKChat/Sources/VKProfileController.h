//
//  VKProfileController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 12.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "VKProfile.h"
#import "VKStatus.h"
#import "VKAccessToken.h"
#import "VKStatusController.h"
#import "VKGetProfileUploadServerRequest.h"
#import "VKSaveProfilePhotoRequest.h"
#import "ASIFormDataRequest.h"

@interface VKProfileController : NSViewController {
    IBOutlet NSButton *avatarButton;
    IBOutlet NSButton *nameButton;
    IBOutlet NSButton *statusButton;
    IBOutlet NSMenu *popupMenu;
    IBOutlet NSMenuItem *profileMenuItem;
    IBOutlet NSMenuItem *logoutMenuItem;
    IBOutlet NSImageView *statusIcon;
    IBOutlet NSImageView *avatarBack;
    VKStatusController *statusController;
}

- (void)setProfile:(VKProfile *)profile;
- (void)setStatus:(VKStatus *)status;

- (IBAction)showMenu:(id)sender;
- (IBAction)changeStatus:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)selectAvatar:(id)sender;
- (IBAction)showProfile:(id)sender;

@end
