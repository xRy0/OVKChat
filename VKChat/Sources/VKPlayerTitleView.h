//
//  VKPlayerTitleView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 23.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKPlayerTitleView : NSView {
    NSFont *artistFont;
    NSFont *titleFont;
    NSDictionary *artistAttsDict;
    NSDictionary *titleAttsDict;
}

@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;

@end
