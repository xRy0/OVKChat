//
//  VKSong.h
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKSong : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy) NSString *uidentifier;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) NSInteger duration;

- (id)initWithDictionary:(NSDictionary *)dict;
- (NSComparisonResult)compareIdentifier:(VKSong *)song;

@end
