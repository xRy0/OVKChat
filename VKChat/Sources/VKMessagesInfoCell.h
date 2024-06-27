//
//  VKMessagesInfoView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 26.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKMessagesInfoCell : NSView

@property (nonatomic, retain) NSImage *avatar;
@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) BOOL isUserTyping;

@end
