//
//  VKPrefsController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 08.02.11.
//  Copyright 2011 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PTKeychain.h"
#import "PTLoginItem.h"
#import "AudioStreamer.h"

#define TOOLBAR_GENERAL @"TOOLBAR_GENERAL"
#define TOOLBAR_ACCOUNT @"TOOLBAR_ACCOUNT"
#define TOOLBAR_MESSAGES @"TOOLBAR_MESSAGES"
#define TOOLBAR_AUDIO @"TOOLBAR_AUDIO"

@interface VKPrefsController : NSWindowController <NSToolbarDelegate> {
	IBOutlet NSView *generalView;
    IBOutlet NSView *accountView;
	IBOutlet NSView *messagesView;
    IBOutlet NSView *audioView;
    IBOutlet NSButton *startAtLoginButton;
    IBOutlet NSButton *showDockIconButton;
    IBOutlet NSButton *showStatusBarIconButton;
    IBOutlet NSButton *showTimeButton;
    IBOutlet NSButton *showAvatarButton;
    IBOutlet NSButton *sendByShiftEnterButton;
    IBOutlet NSTextField *loginField;
    IBOutlet NSSecureTextField *passwordField;
    IBOutlet NSTextField *loginLabel;
    IBOutlet NSTextField *passwordLabel;
    IBOutlet NSButton *logoutButton;
    IBOutlet NSTextField *audioDeviceLabel;
    IBOutlet NSPopUpButton *audioDevicesButton;
	NSUserDefaults *defaults;
    NSView *currentView;
}

- (void)refresh;
- (void)setPrefView:(id)sender;
- (void)selectTabWithIndetifier:(NSString *)identifier;

- (IBAction)loginDidChanged:(id)sender;
- (IBAction)passwordDidChanged:(id)sender;
- (IBAction)startAtLoginDidChanged:(id)sender;
- (IBAction)showDockIconDidChanged:(id)sender;
- (IBAction)showStatusBarIconDidChanged:(id)sender;
- (IBAction)showTimeDidChanged:(id)sender;
- (IBAction)showAvatarChanged:(id)sender;
- (IBAction)sendByShiftEnterDidChanged:(id)sender;
- (IBAction)openWebPage:(id)sender;
- (IBAction)openVKWebPage:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)audioDeviceDidChanged:(id)sender;

@end
