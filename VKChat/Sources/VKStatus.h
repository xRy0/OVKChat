//
//  VKStatus.h
//  VKMessages
//
//  Created by Sergey Lenkov on 11.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKSong.h"

@interface VKStatus : NSObject {
    NSString *text;
    VKSong *song;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain) VKSong *song;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
