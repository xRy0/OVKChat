//
//  VKPhoto.h
//  VKMessages
//
//  Created by Sergey Lenkov on 24.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKPhoto : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, assign) NSInteger albumID;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, retain) NSURL *urlBig;
@property (nonatomic, retain) NSImage *image;
@property (nonatomic, retain) NSImage *imageBig;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSString *)name;

@end
