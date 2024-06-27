//
//  VKDialog.m
//  VKMessages
//
//  Created by Sergey Lenkov on 14.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDialog.h"

@implementation VKDialog

@synthesize userID;
@synthesize lastUpdate;
@synthesize body;
@synthesize title;
@synthesize messages = _messages;
@synthesize unsendMessages = _unsendMessages;
@synthesize offset;
@synthesize isAllMessagesLoaded;
@synthesize isOnline;
@synthesize isHasUnread;
@synthesize isChat;
@synthesize isPhoto;
@synthesize isAudio;
@synthesize isMessage;
@synthesize isVideo;
@synthesize isDocument;
@synthesize isMap;
@synthesize users;
@synthesize profiles = _profiles;
@synthesize delegates = _delegates;
@synthesize isActive;

- (void)dealloc {
    [lastUpdate release];
    [body release];
    [title release];
    [users release];
    [_messages release];
    [_unsendMessages release];
    [_profiles release];
    [_delegates release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        _messages = [[NSMutableArray alloc] init];
        _unsendMessages = [[NSMutableArray alloc] init];
        _profiles = [[NSMutableArray alloc] init];
        _delegates = [[NSMutableArray alloc] init];
        
        _isRequestInProgress = NO;
        _isMessagesLoaded = NO;
        
        self.isActive = NO;
        
        self.offset = 0;
        self.isAllMessagesLoaded = NO;
        self.isOnline = NO;
        
        self.userID = [[[dict objectForKey:@"user_id"] objectForKey:@"last_message"] intValue];
        self.title = [[dict objectForKey:@"title"] objectForKey:@"last_message"];
        self.body = [[dict objectForKey:@"body"] objectForKey:@"last_message"];
        self.lastUpdate = [NSDate dateWithTimeIntervalSince1970:[[[dict objectForKey:@"date"] objectForKey:@"last_message"] intValue]];
        
        self.body = [self.body stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.body = [self.body stringByDecodingHTMLEntities];
        
        self.isChat = NO;
        
        
        
        self.isHasUnread = NO;
         
        if (![[[dict objectForKey:@"read_state"] objectForKey:@"last_message"] boolValue] && ![[[dict objectForKey:@"out"] objectForKey:@"last_message"] boolValue]) {
            self.isHasUnread = YES;
        }
        
        self.isPhoto = NO;
        self.isAudio = NO;
        self.isMessage = NO;
        self.isVideo = NO;
        self.isDocument = NO;
		self.isMap = NO;
		
        if ([self.body length] == 0) {
            if ([dict objectForKey:@"attachments"] && [[dict objectForKey:@"attachments"] isKindOfClass:[NSArray class]]) {
                for (NSDictionary *attach in [dict objectForKey:@"attachments"]) {
                    if ([attach objectForKey:@"photo"]) {
                        self.isPhoto = YES;
                        break;
                    }
                    
                    if ([attach objectForKey:@"audio"]) {
                        self.isAudio = YES;
                        break;
                    }
                    
                    if ([attach objectForKey:@"video"]) {
                        self.isVideo = YES;
                        break;
                    }
					
					if ([attach objectForKey:@"doc"]) {
                        self.isDocument = YES;
                        break;
                    }
                }
            } else {
                if ([dict objectForKey:@"fwd_messages"] && [[dict objectForKey:@"fwd_messages"] isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *messageDict in [dict objectForKey:@"fwd_messages"]) {
                        self.isMessage = YES;
                        break;
                    }
                }
            }
			
			if ([dict objectForKey:@"geo"]) {
				self.isMap = YES;
			}
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewMessages) name:VK_NOTIFICATION_NEED_UPDATE_MESSAGES object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNewMessage:) name:VK_NOTIFICATION_NEW_MESSAGE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageWasDeleted:) name:VK_NOTIFICATION_MESSAGE_WAS_DELETED object:nil];
    }
    
    return self;
}

- (void)clearMessages {
    [_messages removeAllObjects];
    [_unsendMessages removeAllObjects];
}

- (void)addMessages:(NSArray *)aMessages {
    [_messages addObjectsFromArray:aMessages];
    [_messages sortUsingSelector:@selector(compareDate:)];
}

- (void)addMessage:(VKMessage *)aMessage {
    [_messages addObject:aMessage];
}

- (void)addUnsendMessage:(NSString *)aMessage {
    [_unsendMessages addObject:aMessage];
}

- (void)removeUnsendMessage:(NSString *)aMessage {
    for (NSString *message in _unsendMessages) {
        if ([message isEqualToString:aMessage]) {
            [_unsendMessages removeObject:message];
            break;
        }
    }
}

- (void)addProfile:(VKProfile *)aProfile {
    if (![_profiles containsObject:aProfile]) {
        [_profiles addObject:aProfile];
        
        if (!self.isOnline && aProfile.isOnline) {
            self.isOnline = YES;
        }
    }
}

- (void)removeProfiles {
    
}

- (void)addDelegate:(id)delegate {
    if (![_delegates containsObject:delegate]) {
        [_delegates addObject:delegate];
    }
}

- (void)removeDelegate:(id)delegate {
    [_delegates removeObject:delegate];
}

- (NSComparisonResult)compareLastUpdate:(VKDialog *)dialog {
    return [self.lastUpdate compare:dialog.lastUpdate];
}

- (void)updateMessages {
    if (_isRequestInProgress) {
        return;
    }
   
    _isRequestInProgress = YES;
    _isMessagesLoaded = NO;
    
    __block VKMessagesHistoryRequest *request = [[VKMessagesHistoryRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    request.offset = self.offset;
    request.count = VK_MESSAGES_PER_REQUEST;

    
        request.userID = self.userID;
    
    
    VKMessagesHistoryRequestResultBlock resultBlock = ^(NSArray *messages) {
        [self loadImages:messages];
        
        if ([messages count] < VK_MESSAGES_PER_REQUEST) {
            self.isAllMessagesLoaded = YES;
        }
        
        _isRequestInProgress = NO;
        _isMessagesLoaded = YES;
        
        [self addMessages:messages];
        
        VKMessage *lastMessage = [_messages lastObject];
        
        self.body = lastMessage.body;
        self.offset = [_messages count];

		if (_newMessageReceived && !self.isActive) {
			self.isHasUnread = YES;
		}
			
		[self didFinishedUpdate];
		
		_newMessageReceived = NO;

        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        _isRequestInProgress = NO;
        [self didFailUpdate:error];
        
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)updateNewMessages {
    if (_isRequestInProgress) {
        return;
    }
    
    _isRequestInProgress = YES;

    __block VKMessagesHistoryRequest *request = [[VKMessagesHistoryRequest alloc] init];

    request.accessToken = [VKAccessToken token];
    request.offset = 0;
    request.count = VK_MESSAGES_PER_REQUEST;
    
   
        request.userID = self.userID;
    
    
    VKMessagesHistoryRequestResultBlock resultBlock = ^(NSArray *messages) {
        [self loadImages:messages];
        
        _isRequestInProgress = NO;
        
        NSMutableArray *newMessages = [NSMutableArray array];
        
        for (VKMessage *message in messages) {
            if ([message.date timeIntervalSince1970] > [lastUpdate timeIntervalSince1970]) {
                BOOL isExists = NO;
                
                for (VKMessage *_message in _messages) {
                    if (_message.identifier == message.identifier) {
                        isExists = YES;
                        break;
                    }
                }
                
                if (!isExists) {
                    [newMessages addObject:message];
                }
            }
        }
        
        if ([newMessages count] > 0) {
            [self addMessages:newMessages];
			
            self.isPhoto = NO;
            self.isAudio = NO;
            self.isMessage = NO;
            self.isVideo = NO;
			self.isDocument = NO;
			self.isMap = NO;
			
            VKMessage *lastMessage = [_messages lastObject];
			
            self.body = lastMessage.body;
            self.lastUpdate = lastMessage.date;
            
            if ([self.body length] == 0) {
                for (id attach in lastMessage.attachments) {
                    if ([attach isKindOfClass:[VKPhoto class]]) {
                        self.isPhoto = YES;
                        break;
                    }
                            
                    if ([attach isKindOfClass:[VKSong class]]) {
                        self.isAudio = YES;
                        break;
                    }
                    
                    if ([attach isKindOfClass:[VKVideo class]]) {
                        self.isVideo = YES;
                        break;
                    }
					
					if ([attach isKindOfClass:[VKDocument class]]) {
                        self.isDocument = YES;
                        break;
                    }
                }
				
				if (lastMessage.isMap) {
					self.isMap = YES;
				}
            } else {
                if ([lastMessage.forwardMessages count] > 0) {
                    self.isMessage = YES;
                }
            }

            if (!self.isActive && !lastMessage.isOut) {
                self.isHasUnread = YES;
            }
            
			if ([newMessages count] > 0) {
				[self didReceivedNewMessages];
			}
        }
        
        [request release];
    };
    
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        _isRequestInProgress = NO;
        [self didFailUpdate:error];
        
        [request release];
    };
    
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
}

- (void)loadImages:(NSArray *)messages {
    for (VKMessage *message in messages) {
        for (id attach in message.attachments) {
            if ([attach isKindOfClass:[VKPhoto class]]) {
                VKPhoto *photo = (VKPhoto *)attach;
                
                if (photo.imageBig == nil) {
                    photo.imageBig = [[NSImage alloc] initWithContentsOfURL:photo.urlBig];
                }
            }
        }
    }
}

- (void)receivedNewMessage:(NSNotification *)notification {
	NSDictionary *dict = [notification object];
	
	if (self.isChat && ![dict objectForKey:@"chat"]) {
		return;
	}
	
	if (!self.isChat && [dict objectForKey:@"chat"]) {
		return;
	}
	
	
	
	if (!self.isChat && ![dict objectForKey:@"chat"]) {
		if (self.userID != [[dict objectForKey:@"user"] integerValue]) {
			return;
		}
	}
	
    if ([_messages count] == 0) {
		_newMessageReceived = YES;
        [self updateMessages];
    } else {
        [self updateNewMessages];
    }
}

- (void)messageWasDeleted:(NSNotification *)notification {
    NSInteger identifier = [[notification object] integerValue];
    
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    for (VKMessage *message in _messages) {
        if (message.identifier == identifier) {
            [temp addObject:message];
        }
    }
    
    for (VKMessage *message in temp) {
        [_messages removeObject:message];
    }
    
    if ([temp count] > 0) {
        [self didDeleteMessage];
    }
    
    [temp release];
}

- (void)didFinishedUpdate {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(dialogDidFinishedUpdateMessages:)]) {
            [delegate dialogDidFinishedUpdateMessages:self];
        }
    }
	
	if (!self.isActive) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_UPDATE_UNREAD_COUNT object:nil];
		[[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_REFRESH_DIALOGS object:nil];
	}
}

- (void)didReceivedNewMessages {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(dialogDidReceivedNewMessages:)]) {
            [delegate dialogDidReceivedNewMessages:self];
        }
    }
    
	if (!self.isActive) {
		[[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_UPDATE_UNREAD_COUNT object:nil];
	}
    
	[[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_REFRESH_DIALOGS object:nil];

	VKMessage *lastMessage = [_messages lastObject];
	
    NSString *notificationBody = lastMessage.body;
    NSString *notificationTitle = @"";
    
    if (self.isChat) {
        notificationTitle = self.title;
    } else {
        VKProfile *profile = [self.profiles objectAtIndex:0];
        notificationTitle = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
    }
    
	if (lastMessage.userID != [VKSettings currentProfile].identifier) {
		[[NSSound soundNamed:@"New Message Notification"] play];
	}

    if ([[NSApplication sharedApplication] isMountainLion]) {
        if (lastMessage.userID != [VKSettings currentProfile].identifier) {
            NSUserNotification *notification = [[[NSUserNotification alloc] init] autorelease];
            
            notification.title = notificationTitle;
            notification.subtitle = VK_STR_MESSAGE;
            notification.informativeText = notificationBody;
            notification.actionButtonTitle = VK_STR_NOTIFICATION_BUTTON;
            notification.deliveryDate = [NSDate dateWithTimeIntervalSinceNow:1];
            
            [[NSUserNotificationCenter defaultUserNotificationCenter] scheduleNotification:notification];
        }
    }
    
    //[GrowlApplicationBridge notifyWithTitle:notificationTitle description:notificationBody notificationName:@"New message" iconData:nil priority:0 isSticky:NO clickContext:nil];
}

- (void)didDeleteMessage {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(dialogDidDeleteMessage:)]) {
            [delegate dialogDidDeleteMessage:self];
        }
    }
}

- (void)didFailUpdate:(NSError *)error {
    for (id delegate in _delegates) {
        if ([delegate respondsToSelector:@selector(dialog: didFailUpdateMessages:)]) {
            [delegate dialog:self didFailUpdateMessages:error];
        }
    }
}

@end
