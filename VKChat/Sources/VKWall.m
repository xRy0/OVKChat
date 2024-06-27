//
//  VKWall.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKWall.h"

@implementation VKWall

@synthesize identifier;
@synthesize userID;
@synthesize text;
@synthesize date;

- (void)dealloc {
    [text release];
    [date release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        self.identifier = [[dict objectForKey:@"id"] intValue];
        self.userID = [[dict objectForKey:@"from_id"] intValue];
        self.text = [dict objectForKey:@"text"];
        self.date = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"date"] intValue]];
    }
    
    return self;
}

@end
