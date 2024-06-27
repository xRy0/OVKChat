//
//  VKPrefsController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 08.02.11.
//  Copyright 2011 Sergey Lenkov. All rights reserved.
//

#import "VKPrefsController.h"

@implementation VKPrefsController

- (id)init {
    self = [super initWithWindowNibName: @"PrefsWindow"];
    
    if (self) {
        defaults = [NSUserDefaults standardUserDefaults];
    }
    
    return self;
}

- (void)awakeFromNib {  
    startAtLoginButton.title = VK_STR_SETTINGS_START_AT_LOGIN;
    showDockIconButton.title = VK_STR_SETTINGS_DOCK_ICON;
    showStatusBarIconButton.title = VK_STR_SETTINGS_STATUS_BAR_ICON;
    showAvatarButton.title = VK_STR_SETTINGS_SHOW_AVATARS;
    showTimeButton.title = VK_STR_SETTINGS_SHOW_TIME;
    sendByShiftEnterButton.title = VK_STR_SETTINGS_SHIFT_ENTER;
    loginLabel.stringValue = VK_STR_PHONE_OR_EMAIL;
    passwordLabel.stringValue = VK_STR_PASSWORD;
    audioDeviceLabel.stringValue = VK_STR_OUTPUT_DEVICE;
    [logoutButton setTitle:VK_STR_LOGOUT];
        
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Preferences Toolbar"];
    [toolbar setDelegate:self];
    [toolbar setAllowsUserCustomization:NO];
    [toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
    [toolbar setSizeMode:NSToolbarSizeModeRegular];
    [toolbar setSelectedItemIdentifier:TOOLBAR_GENERAL];
    [[self window] setToolbar:toolbar];
    [toolbar release];

	if (![[self window] setFrameUsingName:@"Preferences"]) {
		[[self window] center];
	}
    
	[self setPrefView:nil];
}

- (void)refresh {
    showDockIconButton.state = [VKSettings showDockIcon];
    showStatusBarIconButton.state = [VKSettings showStatusBarIcon];
    showAvatarButton.state = [VKSettings showMessageAvatar];
	showTimeButton.state = [VKSettings showMessageTime];
    sendByShiftEnterButton.state = [VKSettings sendMessageByShiftEnter];
    
    NSInteger index = 0;
    int i = 0;
    
    [audioDevicesButton removeAllItems];
    
    for (NSDictionary *device in [AudioStreamer outputDevices]) {
        [audioDevicesButton addItemWithTitle:[device objectForKey:@"name"]];
        
        if ([[device objectForKey:@"id"] isEqualToString:[VKSettings audioDevice]]) {
            index = i;
        }
        
        i++;
    }
    
    [audioDevicesButton selectItemAtIndex:index];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)ident willBeInsertedIntoToolbar:(BOOL)flag {
    NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:ident];

    if ([ident isEqualToString:TOOLBAR_GENERAL]) {
        [item setLabel:VK_STR_SETTINGS_GENERAL];
        [item setImage:[NSImage imageNamed:@"GeneralIcon"]];
        [item setTarget:self];
        [item setAction:@selector(setPrefView:)];
        [item setAutovalidates:NO];
	} else if ([ident isEqualToString:TOOLBAR_ACCOUNT]) {
        [item setLabel:VK_STR_SETTINGS_ACCOUNT];
        [item setImage:[NSImage imageNamed:@"AccountsIcon"]];
        [item setTarget:self];
        [item setAction:@selector(setPrefView:)];
        [item setAutovalidates:NO];
    } else if ([ident isEqualToString:TOOLBAR_MESSAGES]) {
        [item setLabel:VK_STR_SETTINGS_MESSAGES];
        [item setImage:[NSImage imageNamed:@"MessagesIcon"]];
        [item setTarget:self];
        [item setAction:@selector(setPrefView:)];
        [item setAutovalidates:NO];
    }  else if ([ident isEqualToString:TOOLBAR_AUDIO]) {
        [item setLabel:VK_STR_SETTINGS_AUDIO];
        [item setImage:[NSImage imageNamed:@"OutputIcon"]];
        [item setTarget:self];
        [item setAction:@selector(setPrefView:)];
        [item setAutovalidates:NO];
    } else {
        [item release];
        return nil;
    }

    return [item autorelease];
}

- (NSArray *)toolbarSelectableItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarDefaultItemIdentifiers:toolbar];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSArray *)toolbarAllowedItemIdentifiers: (NSToolbar *)toolbar {
    return [NSArray arrayWithObjects:TOOLBAR_GENERAL, /*TOOLBAR_ACCOUNT, */ TOOLBAR_MESSAGES, TOOLBAR_AUDIO, nil];
}

- (void)setPrefView:(id)sender {
    NSString *identifier;
	
    if (sender) {
        identifier = [sender itemIdentifier];
        [[NSUserDefaults standardUserDefaults] setObject:identifier forKey:@"SelectedPrefView"];
    } else {
        identifier = [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedPrefView"];
    }
	
    NSView *view;
	
    if ([identifier isEqualToString:TOOLBAR_ACCOUNT]) {		
        view = accountView;
	} else if ([identifier isEqualToString:TOOLBAR_MESSAGES]) {
		view = messagesView;
	} else if ([identifier isEqualToString:TOOLBAR_AUDIO]) {
		view = audioView;
    } else {
        identifier = TOOLBAR_GENERAL;
        view = generalView;
    }
    
    [[[self window] toolbar] setSelectedItemIdentifier:identifier];
    
    NSWindow *window = [self window];
	
    if (currentView == view) {
        return;
    }

    NSRect windowRect = window.frame;
    
    float difference = currentView.frame.size.height - view.frame.size.height;
    windowRect.origin.y += difference;

    windowRect.size.width = view.bounds.size.width;
    windowRect.size.height = view.bounds.size.height + 80 + 50;
    
    NSRect rect = view.frame;
    
    rect.origin.y = windowRect.size.height - rect.size.height - 74;
    rect.origin.x = 0;
    
    view.frame = rect;
    
    [view setHidden:YES];

    [generalView removeFromSuperview];
    [accountView removeFromSuperview];
    [messagesView removeFromSuperview];
    [audioView removeFromSuperview];
    
    [window.contentView addSubview:view];
    [window setFrame:windowRect display:YES animate:YES];
    [view setHidden:NO];
    
    currentView = view;
    
    if (sender) {
        [window setTitle:[sender label]];
    } else {
        NSToolbar *toolbar = [window toolbar];
        NSString *itemIdentifier = [toolbar selectedItemIdentifier];
        NSEnumerator *enumerator = [[toolbar items] objectEnumerator];
        NSToolbarItem *item;
		
        while ((item = [enumerator nextObject])) {
            if ([[item itemIdentifier] isEqualToString:itemIdentifier]) {
                [window setTitle:[item label]];
                break;
            }
		}
    }
}

- (void)selectTabWithIndetifier:(NSString *)identifier {
	NSView *view;
	
    if ([identifier isEqualToString:TOOLBAR_ACCOUNT]) {		
        view = accountView;
	} else if ([identifier isEqualToString:TOOLBAR_MESSAGES]) {
		view = messagesView;
	} else if ([identifier isEqualToString:TOOLBAR_AUDIO]) {
		view = audioView;
	} else {
        identifier = TOOLBAR_GENERAL;
        view = generalView;
    }
    
    [[[self window] toolbar] setSelectedItemIdentifier:identifier];
    
    NSWindow *window = [self window];
	
    if ([window contentView] == view) {
        return;
    }
	
    NSRect windowRect = [window frame];
    float difference = ([view frame].size.height - [[window contentView] frame].size.height) * [window userSpaceScaleFactor];
    windowRect.origin.y -= difference;
    windowRect.size.height += difference;
	
	difference = ([view frame].size.width - [[window contentView] frame].size.width) * [window userSpaceScaleFactor];
    windowRect.size.width += difference;
	
    [view setHidden:YES];
    [window setContentView:view];
    [window setFrame:windowRect display:YES animate:YES];
    [view setHidden:NO];
    
	NSToolbar *toolbar = [window toolbar];
	NSString *itemIdentifier = [toolbar selectedItemIdentifier];
	NSEnumerator *enumerator = [[toolbar items] objectEnumerator];
	NSToolbarItem *item;
		
	while ((item = [enumerator nextObject])) {
		if ([[item itemIdentifier] isEqualToString:itemIdentifier]) {
			[window setTitle:[item label]];
			break;
		}
	}
}

- (void)windowWillClose:(NSNotification *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_REFRESH_MENU object:nil];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)loginDidChanged:(id)sender {
    [VKSettings setLogin:loginField.stringValue];
}

- (IBAction)passwordDidChanged:(id)sender {
    if ([loginField.stringValue length] == 0) {
        return;
    }
    
    if ([PTKeychain keychainExistsWithLabel:VK_KEYCHAIN_LABEL forAccount:loginField.stringValue] > 0) {
        [PTKeychain modifyKeychainPassword:passwordField.stringValue withLabel:VK_KEYCHAIN_LABEL forAccount:loginField.stringValue];
    } else {
        [PTKeychain addKeychainPassword:passwordField.stringValue withLabel:VK_KEYCHAIN_LABEL forAccount:loginField.stringValue];
    }
}

- (IBAction)startAtLoginDidChanged:(id)sender {
    [PTLoginItem setStartAtLogin:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]] enabled:startAtLoginButton.state];
}

- (IBAction)showDockIconDidChanged:(id)sender {
    [VKSettings setShowDockIcon:showDockIconButton.state];
}

- (IBAction)showStatusBarIconDidChanged:(id)sender {
    [VKSettings setShowStatusBarIcon:showStatusBarIconButton.state];
    
    if ([VKSettings showStatusBarIcon]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_STATUS_BAR_ICON object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_HIDE_STATUS_BAR_ICON object:nil];
    }
}

- (IBAction)showTimeDidChanged:(id)sender {
    [VKSettings setShowMessageTime:showTimeButton.state];
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_AVATARS object:nil];
}

- (IBAction)showAvatarChanged:(id)sender {
    [VKSettings setShowMessageAvatar:showAvatarButton.state];
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_AVATARS object:nil];
}

- (IBAction)sendByShiftEnterDidChanged:(id)sender {
    [VKSettings setSendMessageByShiftEnter:sendByShiftEnterButton.state];
}

- (IBAction)openWebPage:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:VK_APP_URL]];
}

- (IBAction)openVKWebPage:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:VK_URL]];
}

- (IBAction)logout:(id)sender {
    [self close];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_LOGOUT object:nil];
}

- (IBAction)audioDeviceDidChanged:(id)sender {
    if (audioDevicesButton.indexOfSelectedItem < [[AudioStreamer outputDevices] count]) {
        NSDictionary *device = [[AudioStreamer outputDevices] objectAtIndex:audioDevicesButton.indexOfSelectedItem];
        [VKSettings setAudioDevice:[device objectForKey:@"id"]];
    }
}

@end
