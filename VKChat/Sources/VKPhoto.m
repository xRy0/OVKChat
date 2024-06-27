//
//  VKPhoto.m
//  VKMessages
//
//  Created by Sergey Lenkov on 24.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKPhoto.h"

@implementation VKPhoto

@synthesize identifier;
@synthesize userID;
@synthesize albumID;
@synthesize url;
@synthesize urlBig;
@synthesize image;
@synthesize imageBig;

- (void)dealloc {
    [url release];
    [urlBig release];
    [image release];
    [imageBig release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.identifier = [[dict objectForKey:@"pid"] intValue];
        self.userID = [[dict objectForKey:@"owner_id"] intValue];
        self.albumID = [[dict objectForKey:@"aid"] intValue];
        self.url = [NSURL URLWithString:[dict objectForKey:@"src"]];
        
        if ([dict objectForKey:@"src_xxbig"]) {
            self.urlBig = [NSURL URLWithString:[dict objectForKey:@"src_xxbig"]];
        } else if ([dict objectForKey:@"src_xbig"]) {
            self.urlBig = [NSURL URLWithString:[dict objectForKey:@"src_xbig"]];
        } else {
            self.urlBig = [NSURL URLWithString:[dict objectForKey:@"src_big"]];
        }
    }
    
    return self;
}

- (NSString *)name {
    return [self.url lastPathComponent];
}

@end
