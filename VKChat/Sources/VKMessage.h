//
//  VKMessage.h
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+HTML.h"
#import "VKSong.h"
#import "VKPhoto.h"
#import "VKVideo.h"
#import "VKWall.h"
#import "VKDocument.h"

@interface VKMessage : NSObject {
    NSMutableArray *_attachments;
    NSMutableArray *_forwardMessages;
}

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;
@property (nonatomic, assign) BOOL isRead;
@property (nonatomic, assign) BOOL isOut;
@property (nonatomic, assign) BOOL isMap;
@property (nonatomic, retain) VKProfile *profile;
@property (nonatomic, retain) NSArray *attachments;
@property (nonatomic, retain) NSArray *forwardMessages;

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSComparisonResult)compareDate:(VKMessage *)message;

@end
