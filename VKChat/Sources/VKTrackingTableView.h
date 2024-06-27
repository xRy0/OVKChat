//
//  VKTrackingTableView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 23.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VKTrackingTableViewDelegate <NSTableViewDelegate>

- (void)tableView:(NSTableView *)aTableView mouseOverRow:(NSInteger)rowIndex;

@end

@interface VKTrackingTableView : NSTableView {
    NSTrackingArea *trackingArea;
}

@end
