//
//  VKMenuItem.m
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKMenuItem.h"

@implementation VKMenuItem

@synthesize name;
@synthesize type;

- (void)dealloc {
    [name release];
    [super dealloc];
}

@end
