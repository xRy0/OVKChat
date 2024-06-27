//
//  VKMenuItemView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VKMenuCell : NSTextFieldCell

@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) NSImage *icon;
@property (nonatomic, copy) NSString *badge;
@property (nonatomic, assign) BOOL isSeparator;

@end
