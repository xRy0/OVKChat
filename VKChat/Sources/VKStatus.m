//
//  VKStatus.m
//  VKMessages
//
//  Created by Sergey Lenkov on 11.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKStatus.h"

@implementation VKStatus

@synthesize text;
@synthesize song;

- (void)dealloc {
    [text release];
    [song release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.text = [dict objectForKey:@"status"];
        
        if ([dict objectForKey:@"status_audio"]) {
            VKSong *_song = [[VKSong alloc] initWithDictionary:[dict objectForKey:@"status_audio"]];
            self.song = _song;
            [_song release];
        }
    }
    
    return self;
}

@end
