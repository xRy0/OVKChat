//
//  VKLongPullConnection.h
//  VKMessages
//
//  Created by Sergey Lenkov on 27.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKGetLongPullServerRequest.h"

@interface VKLongPullConnection : NSObject {
    ASIHTTPRequest *pull;
    NSString *_server;
    NSString *_key;
    NSInteger _ts;
    NSInteger _mode;
    NSTimer *updateTimer;
    NSDate *lastUpdate;
	BOOL isCanceled;
}

@property (nonatomic, assign) BOOL showLog;

- (void)start;
- (void)stop;

@end
