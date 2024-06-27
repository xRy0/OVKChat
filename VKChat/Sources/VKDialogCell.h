//
//  VKDialogCell.h
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXListViewCell.h"

@interface VKDialogCell : PXListViewCell {
    NSImage *onlineIcon;
    NSImage *chatIcon;
    NSString *_text;
    NSTrackingArea *trackingArea;
    NSButton *profileButton;
    NSButton *deleteButton;
    BOOL _isMouseOver;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, assign) BOOL isHasUnread;
@property (nonatomic, assign) BOOL isChat;
@property (nonatomic, assign) BOOL isHasAttach;
@property (nonatomic, retain) NSArray *avatars;
@property (nonatomic, assign) SEL profileAction;
@property (nonatomic, assign) id profileTarget;
@property (nonatomic, assign) SEL deleteAction;
@property (nonatomic, assign) id deleteTarget;

@end
