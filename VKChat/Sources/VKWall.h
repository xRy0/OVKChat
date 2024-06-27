//
//  VKWall.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKWall : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, assign) NSInteger userID;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) NSDate *date;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
