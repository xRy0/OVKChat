//
//  VKAppDelegate.m
//  VKMessages
//
//  Created by Sergey Lenkov on 08.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAppDelegate.h"
#import "NSApplication+Utilites.h"

@implementation VKAppDelegate

@synthesize window = _window;
@synthesize statusBarView;

- (void)dealloc {
    [loginController release];
    [profileController release];
    [playerController release];
    [pullConnection release];
    [preferencesController release];
    [userProfileController release];
    [statusBarView release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib {
    //[[NSApplication sharedApplication] redirectConsoleLogToDocumentFolder];

    self.window.titleBarHeight = 70;
    self.window.centerTrafficLightButtons = NO;
    self.window.centerFullScreenButton = NO;
    self.window.defaultWindowTitle = YES;
    
    mainView.frame = [self.window.contentView bounds];
    [self.window.contentView addSubview:mainView];
    
    statusBarView = [[VKDropStatusBarView alloc] initWithFrame:NSMakeRect(0, 0, 24, 22)];
    
    statusBarView.target = self;
    statusBarView.action = @selector(showMenu);
    statusBarView.isUnread = NO;
    
    preferencesController = [[VKPrefsController alloc] init];
    
    loginController = [[VKLoginController alloc] initWithWindowNibName:@"LoginWindow"];
    [loginController loadWindow];
    
    loginController.delegate = self;
    
    profileController = [[VKProfileController alloc] initWithNibName:@"ProfileView" bundle:nil];
    [profileController loadView];
    
    userProfileController = [[VKUserProfileController alloc] initWithWindowNibName:@"UserProfileWindow"];
    [userProfileController loadWindow];
        
    playerController = [[VKPlayerController alloc] initWithNibName:@"PlayerView" bundle:nil];
    [playerController loadView];
    
    playerController.view.frame = playerView.bounds;
    [playerView addSubview:playerController.view];
    
    profileController.view.frame = NSMakeRect(0, 0, self.window.frame.size.width, 52);

    [self.window.titleBarView addSubview:profileController.view];
    
    pullConnection = [[VKLongPullConnection alloc] init];
	pullConnection.showLog = YES;
    if ([VKSettings showStatusBarIcon]) {
        [self showStatusBarItem];
    }
    
    [messagesMenuItem setTitle:VK_STR_OPEN_MESSAGES];
    [audioMenuItem setTitle:VK_STR_OPEN_AUDIO];
    [photosMenuItem setTitle:VK_STR_OPEN_PHOTOS];
    [preferencesMenuItem setTitle:VK_STR_PREFERENCES];
    [aboutMenuItem setTitle:VK_STR_ABOUT];
    [quitMenuItem setTitle:VK_STR_QUIT];
    
    showAvatarsItem.state = [VKSettings showMessageAvatar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showStatusBarItem) name:VK_NOTIFICATION_SHOW_STATUS_BAR_ICON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideStatusBarItem) name:VK_NOTIFICATION_HIDE_STATUS_BAR_ICON object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadCount) name:VK_NOTIFICATION_UPDATE_UNREAD_COUNT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUnreadCount) name:VK_NOTIFICATION_MESSAGE_WAS_MARK_AS_READ object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:VK_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showUserProfile:) name:VK_NOTIFICATION_SHOW_USER_PROFILE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMainWindow) name:VK_NOTIFICATION_SHOW_MAIN_WINDOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferences:) name:VK_NOTIFICATION_OPEN_PREFERENCES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserStatus) name:VK_NOTIFICATION_UPDATE_STATUS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestUserProfile) name:VK_NOTIFICATION_UPDATE_PROFILE object:nil];
	
    [VKAccessToken load];
    
    [NSTimer scheduledTimerWithTimeInterval:10 * 3600 target:self selector:@selector(setOnline) userInfo:nil repeats:YES];
	[NSTimer scheduledTimerWithTimeInterval:VK_UPDATE_STATUS_INTERVAL target:self selector:@selector(requestUserStatus) userInfo:nil repeats:YES];
	
    NSUserNotificationCenter *notificationCenter = [NSUserNotificationCenter defaultUserNotificationCenter];
    notificationCenter.delegate = self;
}

#pragma mark -
#pragma mark NSAppDelegate
#pragma mark -

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    if (![VKAccessToken isValid]) {
        [VKAccessToken clear];
        [loginController showWindow:nil];
    } else {
        [self requestUserProfile];
    }
}

- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication hasVisibleWindows:(BOOL)flag {
    if ([loginController.window isVisible]) {
        [loginController.window makeKeyAndOrderFront:self];
    } else {
        [self showMainWindow];
    }
    
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    if (![VKSettings isRememberMe]) {
        [VKAccessToken clear];
    }
}

#pragma mark -
#pragma mark NSWindowDelegate
#pragma mark -

- (void)windowDidEnterFullScreen:(NSNotification *)notification {
    [VKSettings setFullScreen:YES];
}

- (void)windowDidExitFullScreen:(NSNotification *)notification {
    [VKSettings setFullScreen:NO];
}

- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet usingRect:(NSRect)rect {
    NSRect fieldRect = rect;
    fieldRect.size.height = 94;
    return fieldRect;
}

- (void)showStatusBarItem {
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength] retain];
    [statusItem setMenu:statusBarMenu];
    [statusItem setView:self.statusBarView];
    
    [statusBarMenu setDelegate:self];
}

- (void)hideStatusBarItem {
    [[NSStatusBar systemStatusBar] removeStatusItem:statusItem];
    [statusItem release];
}

- (void)userLogout {
    [self.window close];
    
	[pullConnection stop];
    [VKSettings clearProfiles];
    [VKAccessToken clear];
    
    [loginController showWindow:nil];
}

- (void)showUserProfile:(NSNotification *)aNotification {
    userProfileController.profile = aNotification.object;
    [userProfileController showWindow:nil];
}

- (void)requestUserProfile {
    __block VKProfileRequest *request = [[VKProfileRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.userID = [VKAccessToken userID];

    VKProfileRequestResultBlock resultBlock = ^(VKProfile *profile) {
        [VKSettings setCurrentProfile:profile];
        [VKSettings addProfile:profile];
        
        NSImage *_image = [[NSImage alloc] initWithContentsOfURL:profile.photoRecURL];
        profile.photoRec = _image;
        [_image release];
		
        [profileController setProfile:profile];
        
        [self setOnline];
        [self requestUserStatus];
        [self updateUnreadCount];
        
        [pullConnection start];
        
        [self showMainWindow];
        [menuController refresh];
        
        if ([VKSettings isFullScreen]) {
            [self.window toggleFullScreen:self];
        }

        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        if (error.code == 5) {
            [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_LOGOUT object:nil];
        } else {
			[self showMainWindow];
		
            NSAlert *alert = [NSAlert alertWithError:error];
            [alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        }
        
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)requestUserStatus {
    __block VKStatusRequest *request = [[VKStatusRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.userID = [VKAccessToken userID];
    
    VKStatusRequestResultBlock resultBlock = ^(VKStatus *status) {
        [profileController setStatus:status];
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)showMenu{
    VKDropStatusBarView *dropView = (VKDropStatusBarView *)statusItem.view;

    if (dropView.isClicked){
        [statusItem popUpStatusItemMenu:statusBarMenu];
    }
}

- (void)menuDidClose:(NSMenu *)menu { 
    VKDropStatusBarView *dropView = (VKDropStatusBarView *)statusItem.view;
    [dropView setHighlightState:NO];
}

- (void)setOnline {
    __block VKSetOnlineRequest *request = [[VKSetOnlineRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];

    VKSetOnlineRequestResultBlock resultBlock = ^() {
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)updateUnreadCount {
    __block VKGetMessageRequest *request = [[VKGetMessageRequest alloc] init];

    request.accessToken = [VKAccessToken token];
    
    VKGetMessageRequestResultBlock resultBlock = ^(NSArray *messages) {
        [VKSettings setUnreadCount:[messages count]];
        [menuController refreshView];
        
        if ([messages count] == 0) {
            statusBarView.isUnread = NO;
        } else {
            statusBarView.isUnread = YES;
        }
        
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)showMainWindow {
    if (([_window styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask) {
        return;
    }
    
    [loginController.window close];

    [NSApp activateIgnoringOtherApps:YES];
    [self.window makeKeyAndOrderFront:self];
    
    if (![self.window setFrameUsingName:@"Main"]) {
		[self.window center];
	}
}

#pragma mark -
#pragma mark VKLoginControllerDelegate
#pragma mark -

- (void)loginControllerDidCanceled:(VKLoginController *)controller {
    [VKAccessToken clear];
    [[NSApplication sharedApplication] terminate:self];
}

- (void)loginControllerDidLogged:(VKLoginController *)controller {
    [self requestUserProfile];
}

#pragma mark -
#pragma mark NSUserNotificationCenterDelegate
#pragma mark -

- (void)userNotificationCenter:(NSUserNotificationCenter *)center didActivateNotification:(NSUserNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_OPEN_MESSAGES object:nil];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)preferences:(id)sender {
	[preferencesController showWindow:sender];
	[preferencesController refresh];
	[[preferencesController window] center];
}

//- (IBAction)about:(id)sender {
//    [aboutController showWindow:sender];
//	[[aboutController window] center];
//}

- (IBAction)newDialog:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_NEW_DIALOG object:nil];
}

- (IBAction)deleteDialog:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_DELETE_DIALOG object:nil];
}

- (IBAction)showAvatars:(id)sender {
    showAvatarsItem.state = !showAvatarsItem.state;
    [VKSettings setShowMessageAvatar:showAvatarsItem.state];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_AVATARS object:nil];
}

- (IBAction)playSong:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_PLAY_SONG object:nil];
}

- (IBAction)nextSong:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_NEXT_SONG object:nil];
}

- (IBAction)previousSong:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_PREV_SONG object:nil];
}

@end
