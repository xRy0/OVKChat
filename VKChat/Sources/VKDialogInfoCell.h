//
//  VKDialogInfoCell.h
//  VKMessages
//
//  Created by Sergey Lenkov on 04.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXListViewCell.h"

@interface VKDialogInfoCell : PXListViewCell {
    NSShadow *textShadow;
	NSButton *actionButton;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) id target;

@end
