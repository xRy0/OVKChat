//
//  VKVideo.m
//  VKMessages
//
//  Created by Sergey Lenkov on 14.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKVideo.h"

@implementation VKVideo

@synthesize identifier;
@synthesize userID;
@synthesize title;
@synthesize description;
@synthesize date;
@synthesize url;
@synthesize urlBig;
@synthesize image;
@synthesize imageBig;

- (void)dealloc {
    [title release];
    [description release];
    [date release];
    [url release];
    [urlBig release];
    [image release];
    [imageBig release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.identifier = [[dict objectForKey:@"vid"] intValue];
        self.userID = [[dict objectForKey:@"owner_id"] intValue];
        self.title = [dict objectForKey:@"title"];
        self.description = [dict objectForKey:@"description"];
        self.duration = [[dict objectForKey:@"duration"] intValue];
        self.date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"date"] intValue]];
        self.url = [NSURL URLWithString:[dict objectForKey:@"image"]];
        
        NSImage *_image = [[NSImage alloc] initWithContentsOfURL:self.url];
        self.image = _image;
        [_image release];
        
        if ([dict objectForKey:@"image_big"]) {
            self.urlBig = [NSURL URLWithString:[dict objectForKey:@"image_big"]];
        }
        
        _image = [[NSImage alloc] initWithContentsOfURL:self.urlBig];
        self.imageBig = _image;
        [_image release];
    }
    
    return self;
}

@end
