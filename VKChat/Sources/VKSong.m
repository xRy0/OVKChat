//
//  VKSong.m
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSong.h"

@implementation VKSong

@synthesize identifier;
@synthesize uidentifier;
@synthesize userID;
@synthesize artist;
@synthesize title;
@synthesize url;
@synthesize duration;

- (void)dealloc {
    [artist release];
    [title release];
    [url release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    VKSong *copy = [[VKSong allocWithZone:zone] init];
    return copy;
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        
            self.identifier = [[dict objectForKey:@"aid"] intValue];
            self.uidentifier = [dict objectForKey:@"unique_id"];
            self.userID = [[dict objectForKey:@"owner_id"] intValue];
            self.artist = [dict objectForKey:@"artist"];
            self.artist = [self.artist stringByDecodingHTMLEntities];
            self.title = [dict objectForKey:@"title"];
            self.title = [self.title stringByDecodingHTMLEntities];
            self.url = [NSURL URLWithString:[dict objectForKey:@"url"]];
            self.duration = [[dict objectForKey:@"duration"] intValue];
        
    }
    
    return self;
}

- (NSComparisonResult)compareIdentifier:(VKSong *)song {
	if (song.identifier > self.identifier) {
		return NSOrderedDescending;
	}
	
	if (song.identifier < self.identifier) {
		return NSOrderedAscending;
	}
	
	return NSOrderedSame;
}

@end
