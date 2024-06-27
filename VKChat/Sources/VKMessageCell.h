//
//  VKMessageCell.h
//  VKMessages
//
//  Created by Sergey Lenkov on 14.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKPhoto.h"
#import "VKSong.h"
#import "VKMessage.h"
#import "NSTextView+AutomaticLinkDetection.h"

#define AUDIO_ATTACH_HEIGHT 28
#define QUOTE_ICON_HEIGHT 12
#define QUOTE_NAME_HEIGHT 20
#define QUOTE_NAME_OFFSET 0
#define MESSAGE_TOP_OFFSET 8
#define MESSAGE_BOTTOM_OFFSET 10
#define MESSAGE_LEFT_OFFSET 14
#define MESSAGE_RIGHT_OFFSET 10
#define QUOTE_OFFSET_Y 2
#define PHOTO_OFFSET_Y 10
#define AUDIO_OFFSET_Y 10
#define BUBBLE_OFFSET_Y 10
#define FORWARD_MESSAGE_OFFSET 30

static NSShadow *messageCellTextShadow = nil;
static NSFont *messageCellTextFont = nil;
static NSDictionary *textAttributes = nil;
static NSDictionary *timeAttributes = nil;

@interface VKMessageCell : NSView {
    NSTextView *textView;
    VKPhoto *draggedPhoto;
    int width;
    int height;
    int x;
    int y;
    int attacheY;
    NSString *_text;
    NSMutableArray *_textViews;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSArray *attachments;
@property (nonatomic, retain) NSArray *forwardMessages;
@property (nonatomic, assign) NSInteger selectedAttachmentIndex;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, retain) NSImage *avatar;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL showAvatar;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL actionClickedOnAttach;
@property (nonatomic, assign) SEL actionClickOnErrorIcon;
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger contentWidth;

- (BOOL)photoAtPoint:(NSPoint)point;
- (NSRect)rectForPhoto:(VKPhoto *)photo;
- (int)calculateWidth;

@end
