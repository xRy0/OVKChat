//
//  VKLoadMoreView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 06.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKLoadMoreView : NSView {
    BOOL isMouseDown;
}

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) NSString *title;

@end
