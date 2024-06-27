//
//  VKAppDelegate.h
//  VKMessages
//
//  Created by Sergey Lenkov on 08.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"
#import "VKLoginController.h"
#import "VKAccessToken.h"
#import "VKProfileRequest.h"
#import "VKStatusRequest.h"
#import "VKProfileController.h"
#import "VKMenuController.h"
#import "VKPlayerController.h"
#import "VKSetOnlineRequest.h"
#import "VKLongPullConnection.h"
#import "VKPrefsController.h"
#import "VKGetMessageRequest.h"
#import "VKUserProfileController.h"
#import "VKDropStatusBarView.h"

@class VKMenuController;

@interface VKAppDelegate : NSObject <NSApplicationDelegate, VKLoginControllerDelegate, NSMenuDelegate, NSUserNotificationCenterDelegate> {
    IBOutlet VKMenuController *menuController;
    IBOutlet NSView *playerView;
    IBOutlet NSView *mainView;
    IBOutlet NSMenu *statusBarMenu;
    IBOutlet NSMenuItem *messagesMenuItem;
    IBOutlet NSMenuItem *audioMenuItem;
    IBOutlet NSMenuItem *photosMenuItem;
    IBOutlet NSMenuItem *preferencesMenuItem;
    IBOutlet NSMenuItem *aboutMenuItem;
    IBOutlet NSMenuItem *quitMenuItem;
    IBOutlet NSMenuItem *newDialogItem;
    IBOutlet NSMenuItem *deleteDialogItem;
    IBOutlet NSMenuItem *showAvatarsItem;
    NSStatusItem *statusItem;
    VKLoginController *loginController;
    VKProfileController *profileController;
    VKPlayerController *playerController;
    VKLongPullConnection *pullConnection;
    VKPrefsController *preferencesController;
    VKUserProfileController *userProfileController;
}

@property (assign) IBOutlet INAppStoreWindow *window;
@property (retain) VKDropStatusBarView *statusBarView;

- (void)showStatusBarItem;
- (void)hideStatusBarItem;
- (void)requestUserProfile;
- (void)requestUserStatus;
- (void)setOnline;
- (void)updateUnreadCount;

- (IBAction)preferences:(id)sender;

- (IBAction)newDialog:(id)sender;
- (IBAction)deleteDialog:(id)sender;
- (IBAction)showAvatars:(id)sender;
- (IBAction)playSong:(id)sender;
- (IBAction)nextSong:(id)sender;
- (IBAction)previousSong:(id)sender;

@end
