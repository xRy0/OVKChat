//
//  VKDialogController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 14.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessagesListController.h"
#import "NS(Attributed)String+Geometrics.h"
#import "VKMessageCell.h"

@implementation VKMessagesListController

@synthesize dialog;

- (void)dealloc {
    [_items release];
    [dialog release];
    [captchaController release];
    [imageController release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)awakeFromNib {
    imageController = [[VKImageController alloc] initWithWindowNibName:@"ImageWindow"];
    [imageController loadWindow];
    
    captchaController = [[VKCaptchaController alloc] initWithWindowNibName:@"CaptchaWindow"];
    captchaController.delegate = self;
    [captchaController loadWindow];
    
    messageTextView.font = [NSFont fontWithName:VK_FONT_MESSAGE_FIELD size:VK_FONT_SIZE_MESSAGE_FIELD];
    
    tileView.tile = [NSImage imageNamed:@"BGTile"];
    
    contentView.frame = listView.bounds;
    [listView setDocumentView:contentView];
    
    [listView.contentView setPostsFrameChangedNotifications:YES];
	[listView.contentView setPostsBoundsChangedNotifications:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewBoundsChanged:) name:NSViewBoundsDidChangeNotification object:listView.contentView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewFrameChanged:) name:NSViewFrameDidChangeNotification object:listView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChange:) name:NSTextDidChangeNotification object:nil];
    [messageTextView setTarget:self];
    [messageTextView setAction:@selector(sendMessage:)];
    
    [messageTextView setTextContainerInset:NSZeroSize];
    
    messageTextView.placeholderString = VK_STR_MESSAGE_PLACEHOLDER;
    
    [self resizeViews];
    
    lastActivity = [[NSDate date] retain];
    isUserTyping = NO;
    
    _items = [[NSMutableArray alloc] init];
    _unsendMessages = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTyping:) name:VK_NOTIFICATION_USER_TYPING object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTypingInChat:) name:VK_NOTIFICATION_USER_TYPING_IN_CHAT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOnlineUsers:) name:VK_NOTIFICATION_USER_ONLINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOfflineUsers:) name:VK_NOTIFICATION_USER_OFFLINE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:VK_NOTIFICATION_LOGOUT object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView) name:VK_NOTIFICATION_SHOW_AVATARS object:nil];
}

- (void)setDialog:(VKDialog *)aDialog {
    NSString *key = @"";
    
    
        key = [NSString stringWithFormat:@"%ld", dialog.userID];
    

    [_unsendMessages setObject:[messageTextView.string copy] forKey:key];

    [dialog release];
    dialog = [aDialog retain];
    
    
        key = [NSString stringWithFormat:@"%ld", dialog.userID];
    
    
    if ([_unsendMessages objectForKey:key]) {
        messageTextView.string = [_unsendMessages objectForKey:key];
    } else {
        messageTextView.string = @"";
    }
}

- (void)refresh {
    isUserTyping = NO;
    [progressIndicator stopAnimation:nil];
	
    if ([dialog.messages count] == 0) {
        _isLoadMore = NO;
        
        [progressIndicator startAnimation:nil];
        [dialog updateMessages];
    } else {
        [self refreshView];
        [listView scrollToBottom];
		[self updateUnread];
    }
    
    if ([VKSettings sendMessageByShiftEnter]) {
        messageTextView.actionKey = VKMessageTextFieldActionKeyShiftEnter;
    } else {
        messageTextView.actionKey = VKMessageTextFieldActionKeyEnter;
    }
}

- (void)refreshView {
    [_items removeAllObjects];
    
    if ([dialog.messages count] > 0) {
        VKMessage *message = [dialog.messages objectAtIndex:0];
        NSDate *date = [message.date truncate];
        [_items addObject:date];

        for (VKMessage *message in dialog.messages) {
            if (![date isEqualToDate:[message.date truncate]]) {
                date = [message.date truncate];
                [_items addObject:date];
            }
            
            [_items addObject:message];
        }
    }
    
    [_items addObjectsFromArray:dialog.unsendMessages];
    
    [self reloadCells];
}

#pragma mark -
#pragma mark Message Cells
#pragma mark -

- (void)reloadCells {
    NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];

    for (NSView *_view in contentView.subviews) {
        [viewsToRemove addObject:_view];
    }
    
    [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [viewsToRemove release];
    
    NSInteger count = [_items count];
    
    if ((!dialog.isOnline) || isUserTyping) {
        count = count + 1;
    }
    
    int y = 0;
    int totalHeight = 0;
    
    if (!dialog.isAllMessagesLoaded) {
        VKLoadMoreView *_view = [[VKLoadMoreView alloc] initWithFrame:NSMakeRect(((int)listView.frame.size.width - 172) / 2, y + 10, 172, 23)];
        
        _view.title = VK_STR_LOAD_MORE;
        _view.target = self;
        _view.action = @selector(loadMore:);
        
        [contentView addSubview:_view];
        [_view release];
        
        totalHeight = totalHeight + 40;
        y = y + 40;
    }

    for (NSInteger row = 0; row < count; row++) {
        if (row < [_items count]) {
            if ([[_items objectAtIndex:row] isKindOfClass:[VKMessage class]]) {
                VKMessage *message = [_items objectAtIndex:row];
                
                int maxWidth = contentView.frame.size.width / 2 + 60;
                
                if (![VKSettings showMessageAvatar]) {
                    maxWidth = maxWidth + 60;
                }
                
                NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:VK_FONT_MESSAGE size:VK_FONT_SIZE_MESSAGE], NSFontAttributeName, nil];
                
                int textWidth = [message.body boundingRectWithSize:NSMakeSize(maxWidth, 0.0) options:NSStringDrawingUsesDeviceMetrics | NSStringDrawingUsesLineFragmentOrigin attributes:attsDict].size.width;
                int songWidth = 0;
                int photoWidth = 0;
                
                if ([message.forwardMessages count] > 0) {
                    attsDict = [NSDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH], NSFontAttributeName, nil];
                    
                    for (VKMessage *forward in message.forwardMessages) {
                        int _width = [forward.body boundingRectWithSize:NSMakeSize(maxWidth, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attsDict].size.width;
                        
                        if (_width > textWidth) {
                            textWidth = _width;
                        }
   
                        NSFontManager *fontManager = [NSFontManager sharedFontManager];
                        NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
                        attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
                        
                        NSString *_text = [NSString stringWithFormat:@"%@ %@", forward.profile.firstName, forward.profile.lastName];
                        
                        if ([_text widthForHeight:16 attributes:attsDict] + 40 > textWidth) {
                            textWidth = [_text widthForHeight:16 attributes:attsDict] + 40;
                        }
                        
                        if ([forward.attachments count] > 0) {
                            for (id attach in forward.attachments) {
                                if ([attach isKindOfClass:[VKSong class]]) {
                                    VKSong *song = (VKSong *)attach;
                                    
                                    NSFontManager *fontManager = [NSFontManager sharedFontManager];
                                    NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
                                    
                                    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, messageCellTextShadow, NSShadowAttributeName, nil];
                                    
                                    if ([song.artist widthForHeight:listView.frame.size.height attributes:attsDict] > songWidth) {
                                        songWidth = [song.artist widthForHeight:listView.frame.size.height attributes:attsDict];
                                    }
                                    
                                    font = [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH];
                                    attsDict = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, messageCellTextShadow, NSShadowAttributeName, nil];
                                    
                                    if ([song.title widthForHeight:listView.frame.size.height attributes:attsDict] > songWidth) {
                                        songWidth = [song.title widthForHeight:listView.frame.size.height attributes:attsDict];
                                    }
                                    
                                    songWidth = songWidth + 34;
                                }
                                
                                if ([attach isKindOfClass:[VKPhoto class]]) {
                                    VKPhoto *photo = (VKPhoto *)attach;
                                    CGSize size = photo.imageBig.size;
                                    
                                    if (size.width > photoWidth) {
                                        photoWidth = size.width;
                                    }
                                }
                            }
                        }
						
						if ([forward.forwardMessages count] > 0) {
							for (VKMessage *_forward in forward.forwardMessages) {
								int _width = [_forward.body boundingRectWithSize:NSMakeSize(maxWidth, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attsDict].size.width;
								_width = _width + FORWARD_MESSAGE_OFFSET;
								
								if (_width > textWidth) {
									textWidth = _width;
								}
								
								NSFontManager *fontManager = [NSFontManager sharedFontManager];
								NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
								attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
								
								NSString *_text = [NSString stringWithFormat:@"%@ %@", forward.profile.firstName, forward.profile.lastName];
								_width = [_text widthForHeight:16 attributes:attsDict] + 40;
								_width = _width + FORWARD_MESSAGE_OFFSET;
								
								if (_width > textWidth) {
									textWidth = _width;
								}
								
								if ([_forward.attachments count] > 0) {
									for (id attach in _forward.attachments) {
										if ([attach isKindOfClass:[VKSong class]]) {
											VKSong *song = (VKSong *)attach;
											
											NSFontManager *fontManager = [NSFontManager sharedFontManager];
											NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
											
											NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, messageCellTextShadow, NSShadowAttributeName, nil];
											
											if ([song.artist widthForHeight:listView.frame.size.height attributes:attsDict] > songWidth) {
												songWidth = [song.artist widthForHeight:listView.frame.size.height attributes:attsDict];
											}
											
											font = [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH];
											attsDict = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, messageCellTextShadow, NSShadowAttributeName, nil];
											
											if ([song.title widthForHeight:listView.frame.size.height attributes:attsDict] > songWidth) {
												songWidth = [song.title widthForHeight:listView.frame.size.height attributes:attsDict];
											}
											
											songWidth = songWidth + 34;
										}
										
										if ([attach isKindOfClass:[VKPhoto class]]) {
											VKPhoto *photo = (VKPhoto *)attach;
											CGSize size = photo.imageBig.size;
											
											if (size.width > photoWidth) {
												photoWidth = size.width;
											}
										}
									}
								}
							}
						}
                    }
                }
                
                if ([message.attachments count] > 0) {
                    for (id attach in message.attachments) {
                        if ([attach isKindOfClass:[VKSong class]]) {
                            VKSong *song = (VKSong *)attach;
                            
                            NSFontManager *fontManager = [NSFontManager sharedFontManager];
                            NSFont *font = [fontManager fontWithFamily:VK_FONT_MESSAGE_ATTACH traits:NSBoldFontMask weight:0 size:VK_FONT_SIZE_MESSAGE_ATTACH];
                            
                            NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, messageCellTextShadow, NSShadowAttributeName, nil];
                            
                            if ([song.artist widthForHeight:listView.frame.size.height attributes:attsDict] > songWidth) {
                                songWidth = [song.artist widthForHeight:listView.frame.size.height attributes:attsDict];
                            }
                            
                            font = [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH];
                            attsDict = [NSDictionary dictionaryWithObjectsAndKeys: font, NSFontAttributeName, nil];
                            
                            if ([song.title widthForHeight:listView.frame.size.height attributes:attsDict] > songWidth) {
                                songWidth = [song.title widthForHeight:listView.frame.size.height attributes:attsDict];
                            }
                            
                            songWidth = songWidth + 34;
                        }
                        
                        if ([attach isKindOfClass:[VKPhoto class]]) {
                            VKPhoto *photo = (VKPhoto *)attach;
                            CGSize size = photo.imageBig.size;
                            
                            if (size.width > photoWidth) {
                                photoWidth = size.width;
                            }
                        }
                        
                        if ([attach isKindOfClass:[VKVideo class]]) {
                            VKVideo *video = (VKVideo *)attach;
                            CGSize size = video.imageBig.size;
                            
                            if (size.width > photoWidth) {
                                photoWidth = size.width;
                            }
                        }
                    }
                }
                
                int width = 0;
                
                if (textWidth > width) {
                    width = textWidth;
                }
                
                if (songWidth > width) {
                    width = songWidth;
                }
                
                if (photoWidth > VK_MAX_PHOTO_WIDTH) {
                    photoWidth = VK_MAX_PHOTO_WIDTH;
                }
                
                if (photoWidth > width) {
                    width = photoWidth;
                }
                
                int contentWidth = width;
                
                if (width > maxWidth) {
                    width = maxWidth;
                }

                int height = [self cellHeightForMessage:message width:width];

                VKMessageCell *cell;

                BOOL isMe = NO;

                if (message.userID == [VKSettings currentProfile].identifier) {
                    isMe = YES;
                    cell = [[VKMessageRightCell alloc] initWithFrame:CGRectMake(0, y, contentView.frame.size.width, height)];
                } else {
                    cell = [[VKMessageLeftCell alloc] initWithFrame:CGRectMake(0, y, contentView.frame.size.width, height)];
                }
                
                cell.text = message.body;
                cell.attachments = message.attachments;
                cell.forwardMessages = message.forwardMessages;
                cell.date = [message.date systemTimeRepresentation];
                cell.showAvatar = [VKSettings showMessageAvatar];
                cell.showTime = [VKSettings showMessageTime];
                cell.isError = NO;

                if (isMe) {
                    cell.avatar = [VKSettings currentProfile].photoRec;
                } else {
						if ([dialog.profiles count] > 0) {
							VKProfile *profile = [dialog.profiles objectAtIndex:0];
							cell.avatar = profile.photoRec;
						}
                    
                }
                
                cell.row = row;
                cell.target = self;
                cell.actionClickedOnAttach = @selector(attachDidSelected:);
                
                [cell setAutoresizingMask:NSViewWidthSizable];
                
                cell.frame = NSMakeRect(0, y, contentView.frame.size.width, height);
                cell.contentWidth = contentWidth;
                
                [contentView addSubview:cell];
                [cell release];

                totalHeight = totalHeight + height;
                y = y + height;
            } else if ([[_items objectAtIndex:row] isKindOfClass:[NSDate class]]) {
                NSDate *date = [_items objectAtIndex:row];
                
                NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
                [formatter setDateFormat:VK_STR_MESSAGE_GROUP_FORMAT];
                
                VKMessageGroupCell *cell = [[VKMessageGroupCell alloc] initWithFrame:CGRectMake(0, y, contentView.frame.size.width, 30)];
                cell.text = [formatter stringFromDate:date];
                
                [cell setAutoresizingMask:NSViewWidthSizable];
                
                [contentView addSubview:cell];
                [cell release];
                
                totalHeight = totalHeight + 30;
                y = y + 30;
            } else if ([[_items objectAtIndex:row] isKindOfClass:[NSString class]]) {
                NSString *message = [_items objectAtIndex:row];
                
                int maxWidth = contentView.frame.size.width / 2 + 60;
                
                if (![VKSettings showMessageAvatar]) {
                    maxWidth = maxWidth + 60;
                }
                
                NSFont *font = [NSFont fontWithName:VK_FONT_MESSAGE size:VK_FONT_SIZE_MESSAGE];
                NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
                
                int width = [message widthForHeight:listView.frame.size.height attributes:attributes] + 10;
                
                if (width > maxWidth) {
                    width = maxWidth;
                }

                NSRect bounds = [message boundingRectWithSize:NSMakeSize(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes];
                int height = bounds.size.height;
                
                height = height + (MESSAGE_TOP_OFFSET + MESSAGE_BOTTOM_OFFSET);
                height = height + (BUBBLE_OFFSET_Y * 2);
                
                VKMessageCell *cell = [[VKMessageRightCell alloc] initWithFrame:CGRectMake(0, y, contentView.frame.size.width, height)];
                
                cell.text = [_items objectAtIndex:row];
                cell.attachments = nil;
                cell.date = [[NSDate date] systemTimeRepresentation];
                cell.showAvatar = [VKSettings showMessageAvatar];
                cell.showTime = [VKSettings showMessageTime];
                cell.avatar = [VKSettings currentProfile].photoRec;
                cell.isError = YES;
                cell.row = row;
                
                cell.target = self;
                cell.actionClickOnErrorIcon = @selector(resendMessage:);
                
                [cell setAutoresizingMask:NSViewWidthSizable];
                
                [contentView addSubview:cell];
                [cell release];
                
                totalHeight = totalHeight + height;
                y = y + height;
            }
        } else {
            if ((!dialog.isOnline) || isUserTyping) {
                VKProfile *profile = nil;
                
                
                    if ([dialog.profiles count] > 0) {
                        profile = [dialog.profiles objectAtIndex:0];
                    }
                
                
                if (profile) {
                    VKMessagesInfoCell *cell = [[VKMessagesInfoCell alloc] initWithFrame:CGRectMake(0, y, contentView.frame.size.width, 40)];
                    
                    cell.isUserTyping = isUserTyping;
                    cell.icon = [NSImage imageNamed:@"LeftTypingIcon"];
                    
                    NSString *name = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
                    
                    if (!dialog.isOnline) {
                        cell.text = [NSString stringWithFormat:VK_STR_LAST_SEEN_USER, name, [profile.lastSeen longDateRepresentation], [profile.lastSeen systemTimeRepresentation]];
                    }
                    
                    if (isUserTyping) {
                        cell.avatar = profile.photoRec;
                        cell.text = [NSString stringWithFormat:VK_STR_USER_TYPING, name];
                    }
                    
                    [cell setAutoresizingMask:NSViewWidthSizable];
                    
                    [contentView addSubview:cell];
                    [cell release];
                    
                    totalHeight = totalHeight + 40;
                    y = y + 40;
                }
            }
        }
    }
    
    NSRect rect = contentView.frame;
    rect.size.height = totalHeight;
    
    [contentView setFrame:rect];
}

- (void)updateCells {
    NSRect rect = [listView.documentView visibleRect];

    for (id _view in contentView.subviews) {
        if ([_view isKindOfClass:[VKMessageCell class]]) {
            VKMessageCell *cell = (VKMessageCell *)_view;
            
            if (NSIntersectsRect(cell.frame, rect)) {
                [cell setNeedsDisplay:YES];
            }
        }
    }
}

- (void)resizeCells {
    int y = 0;
    int totalHeight = 0;
    
    for (id _view in contentView.subviews) {
        if ([_view isKindOfClass:[VKMessageCell class]]) {
            VKMessageCell *cell = (VKMessageCell *)_view;
            
            VKMessage *message = [_items objectAtIndex:cell.row];
            
            int maxWidth = contentView.frame.size.width / 2 + 60;
            int width = (int)cell.contentWidth;
            
            if (![VKSettings showMessageAvatar]) {
                maxWidth = maxWidth + 60;
            }
            
            if (width > maxWidth) {
                width = maxWidth;
            }
            
			int height = [self cellHeightForMessage:message width:width];
            
            cell.frame = NSMakeRect(0, y, contentView.frame.size.width, height);
            
            totalHeight = totalHeight + height;
            y = y + height;
        } else {
            NSView *cell = (NSView *)_view;
            NSRect rect = cell.frame;
            
            if ([_view isKindOfClass:[VKLoadMoreView class]]) {
                rect = NSMakeRect(((int)listView.frame.size.width - 172) / 2, y + 10, 172, 23);
                
                totalHeight = totalHeight + 40;
                y = y + 40;
            } else {
                rect = NSMakeRect(0, y, contentView.frame.size.width, cell.frame.size.height);
                
                totalHeight = totalHeight + cell.frame.size.height;
                y = y + cell.frame.size.height;
            }
            
            cell.frame = rect;
        }
    }
    
    NSRect rect = contentView.frame;
    rect.size.height = totalHeight;
    
    [contentView setFrame:rect];
}

- (int)cellHeightForMessage:(VKMessage *)message width:(int)width {
	NSFont *font = [NSFont fontWithName:VK_FONT_MESSAGE size:VK_FONT_SIZE_MESSAGE];
	NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
	
	NSRect bounds = [message.body boundingRectWithSize:NSMakeSize(width + 2, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes];
	int height = bounds.size.height;
	
	if ([message.body length] == 0) {
		height = 0;
	}
	
	if ([message.attachments count] > 0 && [message.body length] > 0) {
		height = height + PHOTO_OFFSET_Y;
	}
	
	for (id attach in message.attachments) {
		if ([attach isKindOfClass:[VKSong class]]) {
			height = height + AUDIO_ATTACH_HEIGHT;
			height = height + AUDIO_OFFSET_Y;
		}
		
		if ([attach isKindOfClass:[VKPhoto class]]) {
			VKPhoto *photo = (VKPhoto *)attach;
			CGSize size = photo.imageBig.size;
			
			float scale = 1.0;
			
			if (size.width > width) {
				scale = width / size.width;
			}
			
			height = height + size.height * scale;
			height = height + PHOTO_OFFSET_Y;
		}
		
		if ([attach isKindOfClass:[VKVideo class]]) {
			VKVideo *video = (VKVideo *)attach;
			CGSize size = video.imageBig.size;
			
			float scale = 1.0;
			
			if (size.width > width) {
				scale = width / size.width;
			}
			
			height = height + size.height * scale;
			height = height + PHOTO_OFFSET_Y;
		}
	}
	
	if ([message.attachments count] > 0) {
		height = height - PHOTO_OFFSET_Y;
	}
	
	if ([message.forwardMessages count] > 0 && [message.body length] == 0) {
		height = height + QUOTE_OFFSET_Y;
	}
	
	for (VKMessage *forwardMessage in message.forwardMessages) {
		height = height + QUOTE_ICON_HEIGHT;
		height = height + QUOTE_NAME_HEIGHT;
		height = height + QUOTE_NAME_OFFSET;
		
		font = [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH];
		attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
		
		bounds = [forwardMessage.body boundingRectWithSize:NSMakeSize(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes];
		height = height + bounds.size.height;
		
		for (id attach in forwardMessage.attachments) {
			if ([attach isKindOfClass:[VKSong class]]) {
				height = height + AUDIO_ATTACH_HEIGHT;
				height = height + AUDIO_OFFSET_Y;
			}
			
			if ([attach isKindOfClass:[VKPhoto class]]) {
				VKPhoto *photo = (VKPhoto *)attach;
				CGSize size = photo.imageBig.size;
				
				float scale = 1.0;
				
				if (size.width > width) {
					scale = width / size.width;
				}
				
				height = height + size.height * scale;
				height = height + PHOTO_OFFSET_Y;
			}
			
			if ([attach isKindOfClass:[VKVideo class]]) {
				VKVideo *video = (VKVideo *)attach;
				CGSize size = video.imageBig.size;
				
				float scale = 1.0;
				
				if (size.width > width) {
					scale = width / size.width;
				}
				
				height = height + size.height * scale;
				height = height + PHOTO_OFFSET_Y;
			}
		}
		
		if ([forwardMessage.forwardMessages count] > 0) {
			if ([forwardMessage.body length] == 0) {
				height = height + QUOTE_OFFSET_Y;
			}
			
			for (VKMessage *_forwardMessage in forwardMessage.forwardMessages) {
				height = height + QUOTE_ICON_HEIGHT;
				height = height + QUOTE_NAME_HEIGHT;
				height = height + QUOTE_NAME_OFFSET;
				
				font = [NSFont fontWithName:VK_FONT_MESSAGE_ATTACH size:VK_FONT_SIZE_MESSAGE_ATTACH];
				attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
				
				bounds = [_forwardMessage.body boundingRectWithSize:NSMakeSize(width, 0.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes];
				height = height + bounds.size.height;
				
				for (id attach in _forwardMessage.attachments) {
					if ([attach isKindOfClass:[VKSong class]]) {
						height = height + AUDIO_ATTACH_HEIGHT;
						height = height + AUDIO_OFFSET_Y;
					}
					
					if ([attach isKindOfClass:[VKPhoto class]]) {
						VKPhoto *photo = (VKPhoto *)attach;
						CGSize size = photo.imageBig.size;
						
						float scale = 1.0;
						
						if (size.width > width) {
							scale = width / size.width;
						}
						
						height = height + size.height * scale;
						height = height + PHOTO_OFFSET_Y;
					}
					
					if ([attach isKindOfClass:[VKVideo class]]) {
						VKVideo *video = (VKVideo *)attach;
						CGSize size = video.imageBig.size;
						
						float scale = 1.0;
						
						if (size.width > width) {
							scale = width / size.width;
						}
						
						height = height + size.height * scale;
						height = height + PHOTO_OFFSET_Y;
					}
				}
			}
		}
	}
	
	if ([message.forwardMessages count] > 0 && [message.body length] == 0) {
		height = height - QUOTE_OFFSET_Y;
	}
	
	height = height + (MESSAGE_TOP_OFFSET + MESSAGE_BOTTOM_OFFSET);
	height = height + (BUBBLE_OFFSET_Y * 2);
	
	return height;
}

#pragma mark -
#pragma mark Other
#pragma mark -

- (void)updateUnread {
    NSRect rect = [listView.documentView visibleRect];
    
    for (id _view in contentView.subviews) {
        if ([_view isKindOfClass:[VKMessageCell class]]) {
            VKMessageCell *cell = (VKMessageCell *)_view;
            
            if ([[_items objectAtIndex:cell.row] isKindOfClass:[VKMessage class]] && NSIntersectsRect(cell.frame, rect)) {
                VKMessage *message = [_items objectAtIndex:cell.row];
                
                if (!message.isRead) {
                    __block VKMarkAsReadRequest *request = [[VKMarkAsReadRequest alloc] init];
                    
                    request.accessToken = [VKAccessToken token];
                    request.messageID = message.identifier;
                    
                    VKMarkAsReadRequestResultBlock resultBlock = ^(NSInteger messageID) {
                        for (VKMessage *_message in dialog.messages) {
                            if (message.identifier == messageID) {
                                message.isRead = YES;
                                break;
                            }
                        }
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_UPDATE_UNREAD_COUNT object:nil];
                        
                        BOOL isHasUnread = NO;
                        
                        for (VKMessage *_message in dialog.messages) {
                            if (!message.isRead) {
                                isHasUnread = YES;
                                break;
                            }
                        }
                        
                        if (dialog.isHasUnread != isHasUnread) {
							dialog.isHasUnread = isHasUnread;
                            [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_REFRESH_DIALOGS object:nil];
                        }
                        
                        [request release];
                    };
                    
                    VKRequestFailureBlock failureBlock = ^(NSError *error) {
                        [request release];
                    };
                    
                    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
                }
            }
        }
    }
}

- (void)viewBoundsChanged:(id)sender {
    [self updateUnread];
}

- (void)viewFrameChanged:(id)sender {
    [self resizeCells];
}

- (void)sendMessage:(NSString *)message captchaID:(NSInteger)captchaID captchaText:(NSString *)captchaText {
    if ([[message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
        return;
    }
    
    if (_isRequestInProgress) {
        return;
    }

    _isRequestInProgress = YES;
	[messageTextView setEditable:NO];
	
    __block VKSendMessageRequest *request = [[VKSendMessageRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.message = message;
    
    
        request.userID = dialog.userID;
    
    
    if (captchaID > 0) {
        request.captchaID = captchaID;
        request.captchaKey = captchaText;
    }

    VKSendMessageRequestResultBlock resultBlock = ^(NSInteger identifier) {
        _isRequestInProgress = NO;
        messageTextView.string = @"";
		[messageTextView setEditable:YES];
		
		[[NSSound soundNamed:@"Received Message"] play];
		
		[self resizeViews];
		
        __block VKGetMessageByIDRequest *messageRequest = [[VKGetMessageByIDRequest alloc] init];
        
        messageRequest.accessToken = [VKAccessToken token];
        messageRequest.messageID = identifier;
        
        VKGetMessageByIDRequestResultBlock messageResulBlock = ^(VKMessage *message) {
            BOOL isMessageExists = NO;
            
            for (VKMessage *_message in dialog.messages) {
                if (message.identifier == _message.identifier) {
                    isMessageExists = YES;
                    break;
                }
            }
            
            if (!isMessageExists) {
                message.userID = [VKSettings currentProfile].identifier;
                
                [dialog addMessage:message];
                
                dialog.body = message.body;
                dialog.lastUpdate = message.date;
                
                for (id delegate in dialog.delegates) {
                    if ([delegate respondsToSelector:@selector(dialogDidReceivedNewMessages:)]) {
                        [delegate dialogDidReceivedNewMessages:dialog];
                    }
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_REFRESH_DIALOGS object:nil];
            }
            
            [messageRequest release];
        };
        
        VKRequestFailureBlock failureBlock = ^(NSError *error) {
            [messageRequest release];
        };
        
        [messageRequest startWithResultBlock:messageResulBlock failureBlock:failureBlock];
        
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        _isRequestInProgress = NO;
        
        if (error.code == 14) {
            captchaController.captchaID = [[[error userInfo] objectForKey:VK_ERROR_CAPTCHA_ID] intValue];
            captchaController.captchaURL = [NSURL URLWithString:[[error userInfo] objectForKey:VK_ERROR_CAPTCHA_IMG]];
            
            [captchaController showWindow:nil];
        } else {
            [dialog addUnsendMessage:[message copy]];
            [self refreshView];
            [listView scrollToBottom];
            
            messageTextView.string = @"";
        }
        
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)updateTyping:(NSNotification *)notification {
    if ([notification.object intValue] == dialog.userID) {
        dialog.isOnline = YES;
        isUserTyping = YES;

        NSRect rect = [listView.documentView visibleRect];
        int delta = (int)contentView.bounds.size.height - ((int)rect.origin.y + (int)rect.size.height);
        
        [self refreshView];
        
        if (delta < 20) {
            [listView scrollToBottom];
        }
        
        [lastTyping release];
        lastTyping = [[NSDate date] retain];
        
        [self performSelector:@selector(hideUserTyping) withObject:nil afterDelay:6.0];
    }
}

- (void)updateTypingInChat:(NSNotification *)notification {
    
}

- (void)updateOnlineUsers:(NSNotification *)notification {
    if (abs([notification.object intValue]) == dialog.userID) {
        dialog.isOnline = YES;
        [self refreshView];
    }
}

- (void)updateOfflineUsers:(NSNotification *)notification {
    if (abs([notification.object intValue]) == dialog.userID) {
        dialog.isOnline = NO;
        [self refreshView];
    }
}

- (void)userLogout {
    [_items removeAllObjects];
    
    NSMutableArray *viewsToRemove = [[NSMutableArray alloc] init];
    
    for (NSView *_view in contentView.subviews) {
        [viewsToRemove addObject:_view];
    }
    
    [viewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [viewsToRemove release];
	
	[_unsendMessages removeAllObjects];
	
	[contentView setFrame:NSMakeRect(0, 0, listView.frame.size.width, listView.frame.size.height)];
}

- (void)hideUserTyping {
    if ([[NSDate date] timeIntervalSince1970] - [lastTyping timeIntervalSince1970] > 5) {
        isUserTyping = NO;
        [self refreshView];
    }
}

- (void)resizeViews {
    if ([[messageTextView.string componentsSeparatedByString:@"\n"] count] > VK_MAX_MESSAGE_ROW_COUNT) {
        return;
    }
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:messageTextView.font, NSFontAttributeName, nil];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:messageTextView.string attributes:attributes];
    int height = [attributedString  heightForWidth:messageTextView.frame.size.width + 14];
    
    if (height < 14) {
        height = 14;
    }

    [attributedString release];
        
    NSRect rect = messageScrollView.frame;
    rect.origin.y = 13;
    rect.size.height = height + 4;
    
    messageScrollView.frame = rect;

    rect = messageView.frame;
    rect.origin.y = 0;
    rect.size.height = (int)messageScrollView.frame.origin.y + (int)messageScrollView.frame.size.height + 14;
    
    messageView.frame = rect;
    
    rect = listView.frame;
    rect.origin.y = (int)messageScrollView.frame.origin.y + (int)messageScrollView.frame.size.height + 14;
    rect.size.height = (int)tileView.frame.size.height - (int)rect.origin.y;
    
    listView.frame = rect;
    
    rect = shadowView.frame;
    rect.origin.y = (int)listView.frame.origin.y;
    rect.size.height = 18;
    
    shadowView.frame = rect;
}

- (void)updateProfiles {
	for (VKMessage *message in dialog.messages) {
		for (VKMessage *forward in message.forwardMessages) {
			if ([VKSettings isProfileExists:forward.userID]) {
				forward.profile = [VKSettings userProfile:forward.userID];
			} else {
				__block VKProfileRequest *request = [[VKProfileRequest alloc] init];
				
				request.accessToken = [VKAccessToken token];
				request.userID = forward.userID;
				
				VKProfileRequestResultBlock resultBlock = ^(VKProfile *profile) {
					[VKSettings addProfile:profile];
					
					[self refreshView];
					
					[request release];
				};
				
				VKRequestFailureBlock failureBlock = ^(NSError *error) {
					[request release];
				};
				
				[request startWithResultBlock:resultBlock failureBlock:failureBlock];
			}
			
			for (VKMessage *_forward in forward.forwardMessages) {
				if ([VKSettings isProfileExists:_forward.userID]) {
					_forward.profile = [VKSettings userProfile:_forward.userID];
				}
			}
		}
	}
}

#pragma mark -
#pragma mark VKDialogDelegate
#pragma mark -

- (void)dialogDidFinishedUpdateMessages:(VKDialog *)aDialog {
	[progressIndicator stopAnimation:nil];
	
	[self updateProfiles];
    [self refreshView];
    
    if (!_isLoadMore) {
        [listView scrollToBottom];
        [self updateUnread];
    }
}

- (void)dialogDidReceivedNewMessages:(VKDialog *)aDialog {
    isUserTyping = NO;
    [progressIndicator stopAnimation:nil];

    [self refreshView];
    [listView scrollToBottom];
    
    if (dialog.isActive) {
		[self updateProfiles];
        [self updateUnread];
    }
}

- (void)dialog:(VKDialog *)dialog didFailUpdateMessages:(NSError *)error {
    [progressIndicator stopAnimation:nil];
    [self refreshView];
}

- (void)dialogDidDeleteMessage:(VKDialog *)aDialog {
    [self refreshView];
}

#pragma mark -
#pragma mark NSTextFieldDelegate
#pragma mark -

- (void)textViewTextDidChange:(id)sender {
    if ([[NSDate date] timeIntervalSince1970] - [lastActivity timeIntervalSince1970] >= 5) {
        [lastActivity release];
        lastActivity = [[NSDate date] retain];
        
        __block VKSetActivityRequest *request = [[VKSetActivityRequest alloc] init];
        
        request.accessToken = [VKAccessToken token];
        
        
            request.userID = [VKSettings currentProfile].identifier;
        
        
        VKSetActivityRequestResultBlock resultBlock = ^() {
            [request release];
        };
        
        VKRequestFailureBlock failureBlock = ^(NSError *error) {
            [request release];
        };
        
        [request startWithResultBlock:resultBlock failureBlock:failureBlock];
    }
    
    [self resizeViews];
}

#pragma mark -
#pragma mark VKCaptchaControllerDlegate
#pragma mark -

- (void)textDidEntered:(NSString *)text forCaptcha:(NSInteger)captchaID {
    [self sendMessage:messageTextView.string captchaID:captchaID captchaText:text];
}

#pragma mark -
#pragma mark NSAlertDlegate
#pragma mark -

- (void)deleteAlertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    NSString *message = [_items objectAtIndex:deletedRow];

    [dialog removeUnsendMessage:message];
    [self refreshView];
    
    if (returnCode == NSAlertDefaultReturn) {    
        [self sendMessage:message captchaID:-1 captchaText:@""];
    }
}
    
#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)attachDidSelected:(id)sender {
    VKMessageCell *cell = (VKMessageCell *)sender;
    VKMessage *message = [_items objectAtIndex:cell.row];

    id attach = [message.attachments objectAtIndex:cell.selectedAttachmentIndex];
        
    if ([attach isKindOfClass:[VKSong class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SONG object:attach];
    }
    
    if ([attach isKindOfClass:[VKPhoto class]]) {
        VKPhoto *photo = (VKPhoto *)attach;
        
        [imageController showWindow:nil];
        [imageController.window makeKeyAndOrderFront:nil];
        
        imageController.photo = photo;
    }
    
    if ([attach isKindOfClass:[VKVideo class]]) {
        VKVideo *video = (VKVideo *)attach;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%ld_%ld", VK_VIDEO_URL, video.userID, video.identifier]];
        [[NSWorkspace sharedWorkspace] openURL:url];
    }
}

- (IBAction)resendMessage:(id)sender {
    VKMessageCell *cell = (VKMessageCell *)sender;
    deletedRow = cell.row;
    
    NSAlert *alert = [NSAlert alertWithMessageText:VK_STR_MESSAGE_WAS_NOT_SENT defaultButton:VK_STR_RESEND alternateButton:VK_STR_DELETE otherButton:nil informativeTextWithFormat:@""];
    [alert beginSheetModalForWindow:[[NSApp delegate] window] modalDelegate:self didEndSelector:@selector(deleteAlertDidEnd: returnCode: contextInfo:) contextInfo:nil];
}

- (IBAction)sendMessage:(id)sender {
    [self sendMessage:messageTextView.string captchaID:-1 captchaText:@""];
}

- (IBAction)loadMore:(id)sender {
    [progressIndicator startAnimation:nil];
    _isLoadMore = YES;
    [dialog updateMessages];
}

@end
