//
//  VKVideo.h
//  VKMessages
//
//  Created by Sergey Lenkov on 14.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKVideo : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, retain) NSDate *date;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSURL *urlBig;
@property (nonatomic, retain) NSImage *image;
@property (nonatomic, retain) NSImage *imageBig;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
