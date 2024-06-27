//
//  VKDialogsController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDialogsListController.h"

@implementation VKDialogsListController

@synthesize dialogs = _dialogs;

- (void)dealloc {
    [messagesController release];
    [messageController release];
    [_dialogs release];
    [_filteredDialogs release];
    [profilesInProgress release];
    [openDialogs release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib {
    messageController = [[VKNewMessageController alloc] initWithWindowNibName:@"NewMessageWindow"];
    _filteredDialogs = [[NSMutableArray alloc] init];
    profilesInProgress = [[NSMutableDictionary alloc] init];
    _dialogs = [[NSMutableArray alloc] init];
    openDialogs = [[NSMutableArray alloc] init];
    
    deleteRowIndex = -1;
    offset = 0;
    
    isDialogsLoaded = NO;
	isNeedReloadDialogs = YES;
    infoText = @"";
    
    [[searchField cell] setPlaceholderString:VK_STR_SEARCH_PLACEHOLDER];
    
    defaults = [NSUserDefaults standardUserDefaults];
	
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:VK_NOTIFICATION_REFRESH_DIALOGS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOnlineUsers:) name:VK_NOTIFICATION_USER_ONLINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOfflineUsers:) name:VK_NOTIFICATION_USER_OFFLINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:VK_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewDialogs) name:VK_NOTIFICATION_NEED_UPDATE_MESSAGES object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewDialogs) name:VK_NOTIFICATION_NEW_MESSAGE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newDialog:) name:VK_NOTIFICATION_NEW_DIALOG object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSelectedDialog) name:VK_NOTIFICATION_DELETE_DIALOG object:nil];
}

- (void)refresh {
    if ([VKSettings currentProfile] == nil) {
        [listView reloadData];
        return;
    }
    
	if (isNeedReloadDialogs) {
		isNeedReloadDialogs = NO;
		[self reloadDialogs];
	} else {
		[self search:nil];
	}
}

- (void)refreshView {
    int selectedRow = 0;
    
    for (int i = 0; i < [_filteredDialogs count]; i++) {
        VKDialog *dialog = [_filteredDialogs objectAtIndex:i];
        
        
        if ([defaults objectForKey:@"SelectedDialogUserID"] && !dialog.isChat) {
            if (dialog.userID == [defaults integerForKey:@"SelectedDialogUserID"]) {
                selectedRow = i;
            }
        }
    }
    
    [listView reloadData];
    listView.selectedRow = selectedRow;
}

- (void)setDialogsInactive {
    for (VKDialog *dialog in _dialogs) {
        dialog.isActive = NO;
    }
}

- (void)reloadDialogs {
	isDialogsLoaded = NO;
	isLoadingError = NO;
	offset = 0;
	[_dialogs removeAllObjects];
	
	[self updateDialogs];
}

- (void)updateDialogs {
    if (isRequestInProgress) {
        return;
    }

    isRequestInProgress = YES;
    infoText = @"";
	
    __block VKGetDialogsRequest *request = [[VKGetDialogsRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.offset = offset;
    request.count = VK_DIALOGS_PER_REQUEST;

    VKGetDialogsRequestResultBlock resultBlock = ^(NSArray *dialogs) {
        isRequestInProgress = NO;
		offset = offset + VK_DIALOGS_PER_REQUEST;
		
		for (VKDialog *dialog in dialogs) {
			if (![self isDialogExists:dialog]) {
				[_dialogs addObject:dialog];
			}
		}
        
		if ([dialogs count] < VK_DIALOGS_PER_REQUEST) {
			isDialogsLoaded = YES;
			infoText = VK_STR_NO_MORE_DIALOGS;
		} else {
			infoText = VK_STR_LOAD_MORE_DIALOGS;
		}

		[self search:nil];
		[self updateProfiles];
		
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        [progressIndicator stopAnimation:nil];
        isRequestInProgress = NO;
        isLoadingError = YES;
		
        infoText = VK_STR_ERROR_LOADING_DIALOGS;
		[listView reloadData];

        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)updateProfiles {
    [profilesInProgress removeAllObjects];
	NSArray *temp = [NSArray arrayWithArray:_dialogs];
	
    for (__block VKDialog *dialog in temp) {
        if (dialog.isChat) {
            for (id userID in dialog.users) {
                if ([profilesInProgress objectForKey:[NSString stringWithFormat:@"%d", [userID intValue]]]) {
                    continue;
                }
                
                [profilesInProgress setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%d", [userID intValue]]];
                
                if (![VKSettings isProfileExists:[userID intValue]]) {
                    __block VKProfileRequest *request = [[VKProfileRequest alloc] init];
                    
                    request.accessToken = [VKAccessToken token];
                    request.userID = [userID intValue];

                    VKProfileRequestResultBlock resultBlock = ^(VKProfile *profile) {
                        [VKSettings addProfile:profile];
						[profilesInProgress removeObjectForKey:[NSString stringWithFormat:@"%ld", profile.identifier]];

						[self updateAvatars];

                        [request release];
                    };
                    
                    VKRequestFailureBlock failureBlock = ^(NSError *error) {
                        [request release];
                    };
                    
                    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
                }
            }
        } else {
            if (![VKSettings isProfileExists:dialog.userID]) {
                if ([profilesInProgress objectForKey:[NSString stringWithFormat:@"%ld", dialog.userID]]) {
                    continue;
                }
                
                [profilesInProgress setObject:[NSNumber numberWithBool:YES] forKey:[NSString stringWithFormat:@"%ld", dialog.userID]];

                __block VKProfileRequest *request = [[VKProfileRequest alloc] init];
                
                request.accessToken = [VKAccessToken token];
                request.userID = dialog.userID;

                VKProfileRequestResultBlock resultBlock = ^(VKProfile *profile) {
                    [VKSettings addProfile:profile];
					[profilesInProgress removeObjectForKey:[NSString stringWithFormat:@"%ld", profile.identifier]];

					[self updateAvatars];
					
                    [request release];
                };
                
                VKRequestFailureBlock failureBlock = ^(NSError *error) {
                    [request release];
                };
                
                [request startWithResultBlock:resultBlock failureBlock:failureBlock];
            }
        }
		
		[self updateCellForDialog:dialog];
    }
    
	//[self updateAvatars];
}

- (void)updateAvatars {
	NSArray *temp = [NSArray arrayWithArray:_dialogs];
	
	for (__block VKDialog *dialog in temp) {
		[dialog removeProfiles];
		
        if (dialog.isChat) {
            for (id userID in dialog.users) {
				if ([VKSettings isProfileExists:[userID intValue]]) {
                    [dialog addProfile:[VKSettings userProfile:[userID intValue]]];
                }
			}
		} else {
			if ([VKSettings isProfileExists:dialog.userID]) {
				[dialog addProfile:[VKSettings userProfile:dialog.userID]];
			}
		}
	}
	
	for (__block VKDialog *dialog in temp) {
		for (__block VKProfile *profile in dialog.profiles) {
			if (profile.photoRec == nil) {
				__block ASIHTTPRequest *_request = [[ASIHTTPRequest alloc] initWithURL:profile.photoRecURL];
				_request.timeOutSeconds = 60;
				
				[_request setCompletionBlock:^() {
					NSImage *image = [[NSImage alloc] initWithData:_request.responseData];
					profile.photoRec = image;
					[image release];
					
					[self updateCellForDialog:dialog];
				}];
				
				[_request startAsynchronous];
			}
		}
	}
	
	//[self search:nil];
}

- (void)updateCellForDialog:(VKDialog *)dialog {
	NSInteger index = [_filteredDialogs indexOfObject:dialog];
	VKDialogCell *cell = (VKDialogCell *)[listView cellForRowAtIndex:index];
	
	if (dialog.isChat) {
		NSMutableArray *images = [NSMutableArray array];
		
		for (VKProfile *profile in dialog.profiles) {
			if (profile.photoRec) {
				[images addObject:profile.photoRec];
			}
		}
		
		cell.avatars = images;
		cell.name = dialog.title;
	} else {
		if ([dialog.profiles count] > 0) {
			VKProfile *profile = [dialog.profiles objectAtIndex:0];
			
			if (profile.photoRec) {
				cell.avatars = [NSArray arrayWithObject:profile.photoRec];
			}
			
			cell.name = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
		}
	}
	
	[cell setNeedsDisplay:YES];
	
	if (listView.selectedRow == index) {
		listView.selectedRow = index;
	}
}

- (void)deleteAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertDefaultReturn) {
        __block VKDialog *dialog = [_filteredDialogs objectAtIndex:deleteRowIndex];
        
        if (dialog.isChat) {
            __block VKDeleteDialogRequest *request = [[VKDeleteDialogRequest alloc] init];
            
            request.accessToken = [VKAccessToken token];
            
            VKDeleteDialogRequestResultBlock resultBlock = ^() {
				[_filteredDialogs removeObject:dialog];
				[_dialogs removeObject:dialog];
				
				NSInteger selectedRow = listView.selectedRow;
				
				[listView reloadData];
				
				if (selectedRow == -1) {
					selectedRow = 0;
				}
				
				listView.selectedRow = selectedRow;
				
                [request release];
            };
            
            VKRequestFailureBlock failureBlock = ^(NSError *error) {
                [request release];
            };
            
            [request startWithResultBlock:resultBlock failureBlock:failureBlock];
        } else {
            VKProfile *profile = [dialog.profiles objectAtIndex:0];
            __block VKDeleteDialogRequest *request = [[VKDeleteDialogRequest alloc] init];
        
            request.accessToken = [VKAccessToken token];
            request.userID = profile.identifier;
        
            VKDeleteDialogRequestResultBlock resultBlock = ^() {
				[_filteredDialogs removeObject:dialog];
				[_dialogs removeObject:dialog];
				
				NSInteger selectedRow = listView.selectedRow;
				
				[listView reloadData];
				
				if (selectedRow == -1) {
					selectedRow = 0;
				}
				
				listView.selectedRow = selectedRow;
				
                [request release];
            };
        
            VKRequestFailureBlock failureBlock = ^(NSError *error) {
                [request release];
            };
        
            [request startWithResultBlock:resultBlock failureBlock:failureBlock];
        }
    }       
}

- (void)updateOnlineUsers:(NSNotification *)notification {
    for (VKDialog *dialog in _dialogs) {
        VKProfile *profile = [dialog.profiles objectAtIndex:0];
        
        if (abs([notification.object intValue]) == profile.identifier) {
            dialog.isOnline = YES;
            [self refreshView];
            
            break;
        }
    }
}

- (void)updateOfflineUsers:(NSNotification *)notification {
    for (VKDialog *dialog in _dialogs) {
        VKProfile *profile = [dialog.profiles objectAtIndex:0];
        
        if (abs([notification.object intValue]) == profile.identifier) {
            dialog.isOnline = NO;
            [self refreshView];
            
            break;
        }
    }
}

- (void)userLogout {
    isDialogsLoaded = NO;
	isNeedReloadDialogs = YES;
	infoText = @"";

    [_dialogs removeAllObjects];
    [_filteredDialogs removeAllObjects];
    
	for (VKDialogController *controller in openDialogs) {
		[controller close];
	}
	
    [listView reloadData];
}

- (void)deleteSelectedDialog {
    deleteRowIndex = listView.selectedRow;
    [self deleteDialog];
}

- (void)deleteDialog {
    if (deleteRowIndex != -1) {
        VKDialog *dialog = [_filteredDialogs objectAtIndex:deleteRowIndex];
        VKProfile *profile = [dialog.profiles objectAtIndex:0];
        
        NSString *name = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
        NSString *text = [NSString stringWithFormat:VK_STR_DELETE_DIALOG_TEXT, name];
        
        if (dialog.isChat) {
            text = [NSString stringWithFormat:VK_STR_DELETE_CHAT_TEXT, dialog.title];
        }
        
        NSAlert *alert = [NSAlert alertWithMessageText:VK_STR_DELETE_DIALOG_TITLE defaultButton:VK_STR_OK alternateButton:VK_STR_CANCEL otherButton:nil informativeTextWithFormat:text, nil];
        [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:self didEndSelector:@selector(deleteAlertDidEnd: returnCode: contextInfo:) contextInfo:nil];
    }
}

- (BOOL)isDialogExists:(VKDialog *)dialog {
	for (VKDialog *_dialog in _dialogs) {
		
		
		if (!dialog.isChat && !_dialog.isChat) {
			if (dialog.userID == _dialog.userID) {
				return YES;
			}
		}
	}
	
	return NO;
}

#pragma mark -
#pragma mark PXListViewDelegate
#pragma mark -

- (NSUInteger)numberOfRowsInListView: (PXListView*)aListView {
    if ([infoText length] == 0) {
        return [_filteredDialogs count];
    }
    
	return [_filteredDialogs count] + 1;
}

- (PXListViewCell*)listView:(PXListView *)aListView cellForRow:(NSUInteger)row {
	if (row < [_filteredDialogs count]) {
        VKDialogCell *cell = (VKDialogCell *)[aListView dequeueCellWithReusableIdentifier:@"ID"];
        
        if (!cell) {
            cell = [[VKDialogCell alloc] initWithReusableIdentifier:@"ID"];
        }
        
        cell.profileTarget = self;
        cell.profileAction = @selector(showProfile:);
        cell.deleteTarget = self;
        cell.deleteAction = @selector(deleteButtonWasPressed:);
		
		VKDialog *dialog = [_filteredDialogs objectAtIndex:row];
		
		cell.text = dialog.body;
        cell.isOnline = dialog.isOnline;
        cell.isHasUnread = dialog.isHasUnread;
        cell.isChat = dialog.isChat;
        cell.name = @"";
		cell.avatars = [NSArray arrayWithObject:[NSImage imageNamed:@"DefaultAvatar"]];

        if (dialog.isChat) {
            cell.name = dialog.title;
            
            NSMutableArray *images = [NSMutableArray array];
            
            for (VKProfile *profile in dialog.profiles) {
				if (profile.photoRec) {
					[images addObject:profile.photoRec];
				} else {
					[images addObject:[NSImage imageNamed:@"DefaultAvatar"]];
				}
            }
            
            cell.avatars = images;
        } else {
			if ([dialog.profiles count] > 0) {
				VKProfile *profile = [dialog.profiles objectAtIndex:0];
            
				if (profile.photoRec) {
					cell.avatars = [NSArray arrayWithObject:profile.photoRec];
				} else {
					cell.avatars = [NSArray arrayWithObject:[NSImage imageNamed:@"DefaultAvatar"]];
				}
            
				cell.name = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
			}
        }
        
        NSInteger days = [dialog.lastUpdate daysCountBetweenDate:[NSDate date]];
        
        if ([dialog.lastUpdate isToday]) {
            cell.date = [dialog.lastUpdate systemTimeRepresentation];
        } else if (days == 1) {
            cell.date = VK_STR_YESTERDAY;
        } else if (days == 2) {
            cell.date = [dialog.lastUpdate weekDayName];
        } else {
            cell.date = [dialog.lastUpdate shortDateRepresentation];
        }
        
        cell.isHasAttach = NO;
        
        if ([dialog.body length] == 0) {
            cell.isHasAttach = YES;
            
            if (dialog.isPhoto) {
                cell.text = VK_STR_PHOTO_DIALOG;
            }
            
            if (dialog.isAudio) {
                cell.text = VK_STR_AUDIO_DIALOG;
            }
            
            if (dialog.isMessage) {
                cell.text = VK_STR_MESSAGE_DIALOG;
            }
            
            if (dialog.isVideo) {
                cell.text = VK_STR_VIDEO_DIALOG;
            }
			
			if (dialog.isDocument) {
				cell.text = VK_STR_DOCUMENT;
			}
			
			if (dialog.isMap) {
				cell.text = VK_STR_MAP;
			}
        }

        return cell;
    }
	
    VKDialogInfoCell *cell = (VKDialogInfoCell *)[aListView dequeueCellWithReusableIdentifier:@"ID1"];
    
    if (!cell) {
        cell = [[VKDialogInfoCell alloc] initWithReusableIdentifier:@"ID1"];
    }
    
    cell.text = infoText;
    cell.action = @selector(actionButtonWasPressed:);
	cell.target = self;
	
	return cell;
}

- (CGFloat)listView:(PXListView *)aListView heightOfRow:(NSUInteger)row {
	return 68;
}

- (void)listViewSelectionDidChange:(NSNotification *)aNotification {
    NSInteger row = listView.selectedRow;

    if (row != -1) {
        if (row < [_filteredDialogs count]) {
            for (VKDialog *dialog in _dialogs) {
                dialog.isActive = NO;
                [dialog removeDelegate:messagesController];
            }
            
            VKDialog *dialog = [_filteredDialogs objectAtIndex:row];
            
            if (dialog.isChat) {
                [defaults removeObjectForKey:@"SelectedDialogUserID"];
            } else {
                [defaults setInteger:dialog.userID forKey:@"SelectedDialogUserID"];
                [defaults removeObjectForKey:@"SelectedDialogChatID"];
            }
            
            [dialog addDelegate:messagesController];
            dialog.isActive = YES;
            
            messagesController.dialog = dialog;
            [messagesController refresh];
        }
    }
}

- (void)listView:(PXListView*)aListView rowDoubleClicked:(NSUInteger)rowIndex {
    if (rowIndex < [_filteredDialogs count]) {
        VKDialog *dialog = [_filteredDialogs objectAtIndex:rowIndex];
        
        for (VKDialogController *controller in openDialogs) {
            if (dialog == controller.dialog) {
                [controller.window makeKeyAndOrderFront:nil];
                return;
            }
        }
        
        VKDialogController *controller = [[VKDialogController alloc] initWithWindowNibName:@"DialogWindow"];
        controller.dialog = dialog;
        
        [controller showWindow:nil];
        [controller refresh];
        
        [openDialogs addObject:controller];
        [controller release];
    }
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)deleteButtonWasPressed:(id)sender {
    VKDialogCell *cell = (VKDialogCell *)sender;
    deleteRowIndex = cell.row;
    
    [self deleteDialog];
}

- (IBAction)actionButtonWasPressed:(id)sender {
	if (!isDialogsLoaded) {
		infoText = VK_STR_LOADING;
		[self refreshView];
		[self updateDialogs];
	}
	
	if (isLoadingError) {
		infoText = VK_STR_LOADING;
		[self refreshView];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_UPDATE_PROFILE object:nil];
	}
}

- (IBAction)showProfile:(id)sender {
    VKDialogCell *cell = (VKDialogCell *)sender;
    VKDialog *dialog = [_filteredDialogs objectAtIndex:cell.row];
    
    if (!dialog.isChat) {
        VKProfile *profile = [dialog.profiles objectAtIndex:0];
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_USER_PROFILE object:profile];
    }
}

- (IBAction)newDialog:(id)sender {
    [NSApp beginSheet:messageController.window modalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [messageController refresh];
}

- (IBAction)search:(id)sender {
    [_filteredDialogs removeAllObjects];
	NSArray *temp = [NSArray arrayWithArray:_dialogs];
	
    for (VKDialog *dialog in temp) {
        NSString *name = @"";
        
        if (dialog.isChat) {
            for (VKProfile *profile in dialog.profiles) {
                name = [name stringByAppendingFormat:@"%@ %@ ", profile.firstName, profile.lastName];
            }
        } else if ([dialog.profiles count] > 0) {
            VKProfile *profile = [dialog.profiles objectAtIndex:0];
            name = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
        }
        
        NSString *search = [searchField.stringValue lowercaseString];
        NSRange range = [[name lowercaseString] rangeOfString:search];

        if (range.location != NSNotFound || [search length] == 0) {
            [_filteredDialogs addObject:dialog];
        }
    }

    [_filteredDialogs sortUsingSelector:@selector(compareLastUpdate:)];
    [_filteredDialogs reverse];

    [self refreshView];
}

@end
