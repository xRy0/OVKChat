//
//  VKLongPullConnection.m
//  VKMessages
//
//  Created by Sergey Lenkov on 27.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKLongPullConnection.h"

@implementation VKLongPullConnection

@synthesize showLog;

- (void)dealloc {
    [updateTimer invalidate];
    [updateTimer release];
    
    [super dealloc];
}

- (void)start {
    __block VKGetLongPullServerRequest *request = [[VKGetLongPullServerRequest alloc] init];
    
    request.accessToken = [VKAccessToken token];
    
    VKGetLongPullServerRequestResultBlock resultBlock = ^(NSString *server, NSString *key, NSInteger ts) {
        _server = [server copy];
        _key = [key copy];
        _ts = ts;
        _mode = 2;
        
		isCanceled = NO;
		
        [self connectToServer];
		
        [request release];
    };
                                
    VKRequestFailureBlock failureBlock = ^(NSError *error) {
        [request release];
    };
                                
    [request startWithResultBlock:resultBlock failureBlock:failureBlock];
    
    lastUpdate = [[NSDate date] retain];
    
    updateTimer = [[NSTimer scheduledTimerWithTimeInterval:VK_UPDATE_INTERVAL target:self selector:@selector(needUpdate) userInfo:nil repeats:YES] retain];
}

- (void)stop {
	isCanceled = YES;
	
	[updateTimer invalidate];
	[updateTimer release];
	
	[pull cancel];
}

- (void)connectToServer {
	if (isCanceled) {
		return;
	}
	
    if (showLog) {
        NSLog(@"CONNECT TO PULL");
    }
    
    [pull release];
	
    pull = [[ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?act=a_check&key=%@&ts=%ld&wait=25&mode=%ld", _server, _key, _ts, _mode]]] retain];
    pull.timeOutSeconds = 30;
    
    [pull setCompletionBlock:^() {
        id response = [pull.responseString JSONValue];
        
        if (!response) {
            if (showLog) {
                NSLog(@"PULL ERROR");
            }
            
            [self performSelector:@selector(connectToServer) withObject:nil afterDelay:10.0];
        } else {
            
                [lastUpdate release];
                lastUpdate = [[NSDate date] retain];
                
                _ts = [[response objectForKey:@"ts"] intValue];
        
                for (id update in [response objectForKey:@"updates"]) {
                    if (showLog) {
                        NSLog(@"PULL UPDATE %@", update);
                    }
                    
                    int code = [[update objectAtIndex:0] intValue];
            
                    if (code == 0) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_MESSAGE_WAS_DELETED object:[update objectAtIndex:1]];
                    }
                    
                    if (code == 2) {
                        if ([[update objectAtIndex:2] integerValue] == 128) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_MESSAGE_WAS_DELETED object:[update objectAtIndex:1]];
                        }
                    }
                    
                    if (code == 3) {
                        if ([[update objectAtIndex:2] integerValue] == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_MESSAGE_WAS_MARK_AS_READ object:[update objectAtIndex:1]];
                        }
                    }
                    
                    if (code == 4) {
                        NSString *user = [update objectAtIndex:3];
                        NSString *chat = nil;
                    
                        if ([[update objectAtIndex:2] integerValue] == 8241) {
                            chat = [NSString stringWithFormat:@"%ld", [[update objectAtIndex:3] integerValue] - 2000000000];
                        
                            if ([[update lastObject] objectForKey:@"from"]) {
                                user = [[update lastObject] objectForKey:@"from"];
                            }
                        }
                    
                        NSDictionary *dict;
                    
                        if (chat) {
                            dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[update objectAtIndex:1], [update objectAtIndex:2], user, chat, [update objectAtIndex:4], [update objectAtIndex:5], [update objectAtIndex:6], nil]
                                                                                         forKeys:[NSArray arrayWithObjects:@"id", @"flags", @"user", @"chat", @"date", @"title", @"text", nil]];
                        } else {
                            dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[update objectAtIndex:1], [update objectAtIndex:2], user, [update objectAtIndex:4], [update objectAtIndex:5], [update objectAtIndex:6], nil]
                                                                                         forKeys:[NSArray arrayWithObjects:@"id", @"flags", @"user", @"date", @"title", @"text", nil]];
                        }
                    
                        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_NEW_MESSAGE object:dict];
                    }
            
                    if (code == 8) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_USER_ONLINE object:[update objectAtIndex:1]];
                    }
            
                    if (code == 9) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_USER_OFFLINE object:[update objectAtIndex:1]];
                    }
            
                    if (code == 61) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_USER_TYPING object:[update objectAtIndex:1]];
                    }
                
                    if (code == 62) {
                        NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[update objectAtIndex:1], [update objectAtIndex:2], nil]
                                                                         forKeys:[NSArray arrayWithObjects:@"user", @"chat", nil]];
                                                                         
                        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_USER_TYPING_IN_CHAT object:dict];
                    }
                }
        
                [self connectToServer];
            
        }
    }];
    
    [pull setFailedBlock:^() {
        if (showLog) {
            NSLog(@"PULL ERROR %@", [pull.error localizedDescription]);
        }
        
        [self performSelector:@selector(connectToServer) withObject:nil afterDelay:10.0];
    }];
    
    [pull startAsynchronous];
}

- (void)needUpdate {
    if ([[NSDate date] timeIntervalSince1970] - [lastUpdate timeIntervalSince1970] > VK_UPDATE_WAIT_TIME) {
        if (showLog) {
            NSLog(@"MANUAL UPDATE");
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_NEED_UPDATE_MESSAGES object:nil];
    }
}

@end
