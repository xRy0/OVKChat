//
//  VKAudioCell.h
//  VKMessages
//
//  Created by Sergey Lenkov on 15.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PXListViewCell.h"

@interface VKAudioCell : PXListViewCell {
    NSImage *activeIcon;
    NSButton *addButton;
    NSProgressIndicator *progressIndicator;
}

@property (nonatomic, copy) NSString *artist;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, assign) BOOL isPlayed;
@property (nonatomic, assign) BOOL isCanAdd;
@property (nonatomic, assign) BOOL isUpload;
@property (nonatomic, assign) id addTarget;
@property (nonatomic, assign) SEL addAction;
@property (nonatomic, retain) NSProgressIndicator *progressIndicator;

@end
