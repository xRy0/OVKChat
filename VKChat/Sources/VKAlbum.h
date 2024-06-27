//
//  VKAlbum.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKAlbum : NSObject {
    NSInteger identifier;
    NSString *title;
    NSString *note;
}

@property (assign) NSInteger identifier;
@property (copy) NSString *title;
@property (copy) NSString *note;
@property (retain) NSArray *images;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
