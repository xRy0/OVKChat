//
//  VKMessage.m
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMessage.h"

@implementation VKMessage

@synthesize identifier;
@synthesize userID;
@synthesize date;
@synthesize title;
@synthesize body;
@synthesize isRead;
@synthesize isOut;
@synthesize isMap;
@synthesize profile;
@synthesize attachments = _attachments;
@synthesize forwardMessages = _forwardMessages;

- (void)dealloc {
    [date release];
    [title release];
    [body release];
    [profile release];
    [_attachments release];
    [_forwardMessages release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.identifier = [[dict objectForKey:@"id"] intValue];
        self.userID = [[dict objectForKey:@"from_id"] intValue];
        self.title = [dict objectForKey:@"title"];
        self.body = [dict objectForKey:@"body"];
        self.isRead = [[dict objectForKey:@"read_state"] boolValue];
        self.isOut = [[dict objectForKey:@"out"] boolValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"date"] intValue]];
        
        self.body = [self.body stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        self.body = [self.body stringByDecodingHTMLEntities];
        
        _attachments = [[NSMutableArray alloc] init];
        
        if ([dict objectForKey:@"attachments"] && [[dict objectForKey:@"attachments"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *attach in [dict objectForKey:@"attachments"]) {
                if ([attach objectForKey:@"photo"]) {
                    VKPhoto *photo = [[VKPhoto alloc] initWithDictionary:[attach objectForKey:@"photo"]];
                    
                    [_attachments addObject:photo];
                    [photo release];
                }
                
                if ([attach objectForKey:@"audio"]) {
                    VKSong *song = [[VKSong alloc] initWithDictionary:[attach objectForKey:@"audio"]];
                    
                    [_attachments addObject:song];
                    [song release];
                }
                
                if ([attach objectForKey:@"video"]) {
                    VKVideo *video = [[VKVideo alloc] initWithDictionary:[attach objectForKey:@"video"]];
                    
                    [_attachments addObject:video];
                    [video release];
                }
                
                if ([attach objectForKey:@"wall"]) {
                    VKWall *wall = [[VKWall alloc] initWithDictionary:[attach objectForKey:@"wall"]];
                    
                    if ([self.body length] == 0) {
                        self.body = [NSString stringWithFormat:@"%@%ld_%ld", VK_WALL_URL, wall.userID, wall.identifier];
                    } else {
                        self.body = [self.body stringByAppendingFormat:@"\n%@%ld_%ld", VK_WALL_URL, wall.userID, wall.identifier];
                    }
                    
                    [wall release];
                }
				
				if ([attach objectForKey:@"doc"]) {
					VKDocument *doc = [[VKDocument alloc] initWithDictionary:[attach objectForKey:@"doc"]];
                    
                    if ([self.body length] == 0) {
                        self.body = [doc.url absoluteString];
                    } else {
                        self.body = [self.body stringByAppendingFormat:@"\n%@", [doc.url absoluteString]];
                    }
                    
                    [doc release];
				}
            }
        }
        
		self.isMap = NO;
		
		if ([dict objectForKey:@"geo"]) {
			NSArray *coordinates = [[[dict objectForKey:@"geo"] objectForKey:@"coordinates"] componentsSeparatedByString:@" "];
			NSString *ll = [NSString stringWithFormat:@"%@,%@", [coordinates objectAtIndex:1], [coordinates objectAtIndex:0]];
			
			if ([self.body length] == 0) {
				self.body = [NSString stringWithFormat:VK_MAP_URL, ll];
			} else {
				self.body = [self.body stringByAppendingFormat:@"\n%@", [NSString stringWithFormat:VK_MAP_URL, ll]];
			}
			
			self.isMap = YES;
		}
		
        _forwardMessages = [[NSMutableArray alloc] init];
        
        if ([dict objectForKey:@"fwd_messages"] && [[dict objectForKey:@"fwd_messages"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *messageDict in [dict objectForKey:@"fwd_messages"]) {
                VKMessage *message = [[VKMessage alloc] initWithDictionary:messageDict];
                
                [_forwardMessages addObject:message];
                [message release];
            }
        }
    }
    
    return self;
}

- (NSComparisonResult)compareDate:(VKMessage *)message {
    return [self.date compare:message.date];
}

@end
