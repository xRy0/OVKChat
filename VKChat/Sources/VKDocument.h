//
//  VKDocument.h
//  VKChat
//
//  Created by Sergey Lenkov on 09.09.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKDocument : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSUInteger size;
@property (nonatomic, retain) NSURL *url;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
