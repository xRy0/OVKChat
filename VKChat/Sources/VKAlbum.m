//
//  VKAlbum.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKAlbum.h"

@implementation VKAlbum

@synthesize identifier;
@synthesize title;
@synthesize note;
@synthesize images;

- (void)dealloc {
    [title release];
    [note release];
    [images release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.identifier = [[dict objectForKey:@"aid"] intValue];
        self.title = [dict objectForKey:@"title"];
        self.note = [dict objectForKey:@"description"];
        self.images = [NSArray array];
    }
    
    return self;
}

@end
