//
//  VKDocument.m
//  VKChat
//
//  Created by Sergey Lenkov on 09.09.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKDocument.h"

@implementation VKDocument

@synthesize identifier;
@synthesize userID;
@synthesize title;
@synthesize size;
@synthesize url;

- (void)dealloc {
    [title release];
    [url release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.identifier = [[dict objectForKey:@"did"] intValue];
        self.userID = [[dict objectForKey:@"owner_id"] intValue];
        self.title = [dict objectForKey:@"title"];
		self.size = [[dict objectForKey:@"size"] unsignedIntegerValue];
        self.url = [NSURL URLWithString:[dict objectForKey:@"url"]];
    }
    
    return self;
}

@end
