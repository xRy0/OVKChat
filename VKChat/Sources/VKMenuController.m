//
//  VKMenuController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 12.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMenuController.h"

@implementation VKMenuController

- (void)dealloc {
    [_menu release];
    [messagesController release];
    [audioController release];
    [super dealloc];
}

- (void)awakeFromNib {
    defaults = [NSUserDefaults standardUserDefaults];

    _menu = [[NSMutableArray alloc] init];
    
    VKMenuItem *item = [[VKMenuItem alloc] init];
    item.name = VK_STR_MESSAGES;
    item.type = VKMenuTypeMessages;

    [_menu addObject:item];
    [item release];
    
    item = [[VKMenuItem alloc] init];
    item.name = VK_STR_AUDIO;
    item.type = VKMenuTypeAudio;
    
    [_menu addObject:item];
    [item release];
    
//    item = [[VKMenuItem alloc] init];
//    item.name = @"";
//    item.type = VKMenuTypeSeparator;
//    
//    [_menu addObject:item];
//    [item release];
    
    item = [[VKMenuItem alloc] init];
    item.name = VK_STR_PICTURES;
    item.type = VKMenuTypePictures;
    
    [_menu addObject:item];
    [item release];
    
//    item = [[VKMenuItem alloc] init];
//    item.name = VK_STR_PREFERENCES;
//    item.type = VKMenuTypePreferences;
//    
//    [_menu addObject:item];
//    [item release];
    
    currentItem = nil;
    
    backgroundView.color = [NSColor colorWithDeviceRed:233.0/255.0 green:237.0/255.0 blue:242.0/255.0 alpha:1.0];
    view.backgroundColor = [NSColor colorWithDeviceRed:233.0/255.0 green:237.0/255.0 blue:242.0/255.0 alpha:1.0];
    
    messagesController = [[VKMessagesController alloc] initWithNibName:@"MessagesView" bundle:nil];
    [messagesController loadView];
    
    audioController = [[VKAudioController alloc] initWithNibName:@"AudioView" bundle:nil];
    [audioController loadView];
    
    photoController = [[VKPhotoController alloc] initWithNibName:@"PhotoView" bundle:nil];
    //photoController.delegate = self;
    [photoController loadView];

    [self refresh];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:VK_NOTIFICATION_REFRESH_MENU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:VK_NOTIFICATION_UPDATE_MENU object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectMessages:) name:VK_NOTIFICATION_OPEN_MESSAGES object:nil];
}

- (void)refresh {
    NSInteger index = 0;
	NSLog(@"MENU REFRESH");
	if ([defaults objectForKey:@"Selected Menu Item"] != nil) {
		index = [defaults integerForKey:@"Selected Menu Item"];
	}

    [view reloadData];
    
    if (currentItem && currentItem == [_menu objectAtIndex:view.selectedRow]) {
        [self tableViewSelectionDidChange:[NSNotification notificationWithName:@"NSObject" object:view]];
    } else {
        [view selectRowIndexes:[NSIndexSet indexSetWithIndex:index] byExtendingSelection:NO];
    }
}

- (void)refreshView {
    [view reloadData];
}

#pragma mark -
#pragma mark NSTableView Protocol
#pragma mark -

- (int)numberOfRowsInTableView:(NSTableView *)tableView {
	return (int)[_menu count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex {
    return @"";
}

- (id)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(int)row {
    return [tableColumn dataCell];
}

- (void)tableView:(NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)row {
    VKMenuItem *item = [_menu objectAtIndex:row];
    VKMenuCell *cell = (VKMenuCell *)aCell;

    cell.name = item.name;
    cell.badge = @"";
    cell.isSeparator = NO;
    
    if (item.type == VKMenuTypeMessages) {
        if ([VKSettings unreadCount] > 0) {
            cell.badge = [NSString stringWithFormat:@"%ld", [VKSettings unreadCount]];
        }

        if (cell.isHighlighted) {
            cell.icon = [NSImage imageNamed:@"MenuIconMessagesSelected"];
        } else {
            cell.icon = [NSImage imageNamed:@"MenuIconMessages"];
        }
    }
    
    if (item.type == VKMenuTypeAudio) {
        if (cell.isHighlighted) {
            cell.icon = [NSImage imageNamed:@"MenuIconAudioSelected"];
        } else {
            cell.icon = [NSImage imageNamed:@"MenuIconAudio"];
        }
    }
    
    if (item.type == VKMenuTypePictures) {
        if (cell.isHighlighted) {
            cell.icon = [NSImage imageNamed:@"MenuIconPhotoSelected"];
        } else {
            cell.icon = [NSImage imageNamed:@"MenuIconPhoto"];
        }
    }
    
    if (item.type == VKMenuTypePreferences) {
        if (cell.isHighlighted) {
            cell.icon = [NSImage imageNamed:@"MenuIconPreferencesSelected"];
        } else {
            cell.icon = [NSImage imageNamed:@"MenuIconPreferences"];
        }
        
    }
    
    if (item.type == VKMenuTypeSeparator) {
        cell.isSeparator = YES;
    }
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    VKMenuItem *item = [_menu objectAtIndex:row];
    
    if (item.type == VKMenuTypeSeparator) {
        return 16;
    }
    
    return 28;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)row {
    VKMenuItem *item = [_menu objectAtIndex:row];

    if (item.type == VKMenuTypeSeparator) {
        return NO;
    }
    
    return YES;
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSInteger row = [[aNotification object] selectedRow];
    VKMenuItem *item = [_menu objectAtIndex:row];

    if (item.type != VKMenuTypeMessages) {
        [messagesController setDialogsInactive];
    }

    if (item.type == VKMenuTypePreferences) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_OPEN_PREFERENCES object:nil];
        currentItem = nil;
    } else {
        [messagesController.view removeFromSuperview];
        [audioController.view removeFromSuperview];
        [photoController.view removeFromSuperview];
    
        [audioController setSearchFieldHidden:YES];
        
        if (item.type == VKMenuTypeMessages) {
            messagesController.view.frame = contentView.bounds;
            [contentView addSubview:messagesController.view];
        
            [messagesController refresh];
        }
    
        if (item.type == VKMenuTypeAudio) {
            [audioController setSearchFieldHidden:NO];
    
            audioController.view.frame = contentView.bounds;
            [contentView addSubview:audioController.view];
        
            [audioController refresh];
        }
    
        if (item.type == VKMenuTypePictures) {
            photoController.view.frame = contentView.bounds;
            [contentView addSubview:photoController.view];
        
            [photoController refresh];
        }
    
        [defaults setInteger:row forKey:@"Selected Menu Item"];
        currentItem = item;
    }
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainSplitPosition:(CGFloat)proposedPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (proposedPosition <= VK_SPLIT_MENU_MIN_SIZE) {
        return VK_SPLIT_MENU_MIN_SIZE;
    }
    
    if (proposedPosition >= VK_SPLIT_MENU_MAX_SIZE) {
        return VK_SPLIT_MENU_MAX_SIZE;
    }
    
    return proposedPosition;
}

- (void)photoControllerDidAcceptedImages:(VKPhotoController *)aView {
    [self selectPhotos:self];
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)selectMessages:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_MAIN_WINDOW object:nil];
    [view selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
}

- (IBAction)selectAudio:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_MAIN_WINDOW object:nil];
    [view selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

- (IBAction)selectPhotos:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_MAIN_WINDOW object:nil];
    [view selectRowIndexes:[NSIndexSet indexSetWithIndex:3] byExtendingSelection:NO];
}

@end
