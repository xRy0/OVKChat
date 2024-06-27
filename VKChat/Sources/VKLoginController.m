//
//  VKLoginController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKLoginController.h"

@implementation VKLoginController

@synthesize delegate;

- (void)awakeFromNib {
    self.window.title = VK_STR_LOGIN;
    
    if (![self.window setFrameUsingName:@"Login"]) {
		[self.window center];
	}
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];

    VKOAuthRequest *request = [[VKOAuthRequest alloc] init];
    
    request.appID = VK_APP_ID;
    request.needFriends = YES;
    request.needPhotos = YES;
    request.needAudio = YES;
    request.needMessages = YES;

    [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[request oathURL]]];
    
    [request release];
}


- (BOOL)windowShouldClose:(id)sender {
    [[NSApplication sharedApplication] terminate:self];
    return YES;
}

- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
    if ([[sender mainFrameURL] rangeOfString:@"access_denied"].location != NSNotFound) {
        if (delegate && [delegate respondsToSelector:@selector(loginControllerDidCanceled:)]) {
            [delegate loginControllerDidCanceled:self];
        }
    }

    NSLog(@"Request: %@", [sender mainFrameURL]);
}

- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    NSLog(@"Request: %@", [sender mainFrameURL]);

    NSString *url = [sender mainFrameURL];

    if ([url rangeOfString:@"access_token"].location != NSNotFound) {
        NSRange range = [url rangeOfString:@"#"];
        url = [url substringFromIndex:range.location + 1];

        NSArray *components = [url componentsSeparatedByString:@"&"];

        for (NSString *component in components) {
            NSArray *values = [component componentsSeparatedByString:@"="];
        
            if ([[values objectAtIndex:0] isEqualToString:@"access_token"]) {
                [VKAccessToken setToken:[values objectAtIndex:1]];
            }

            if ([[values objectAtIndex:0] isEqualToString:@"expires_in"]) {
                [VKAccessToken setExpires:[NSDate dateWithTimeIntervalSinceNow:[[values objectAtIndex:1] intValue]]];
            }

            if ([[values objectAtIndex:0] isEqualToString:@"user_id"]) {
                [VKAccessToken setUserID:[[values objectAtIndex:1] intValue]];
            }
        }
        
        [VKAccessToken save];

        if (delegate && [delegate respondsToSelector:@selector(loginControllerDidLogged:)]) {
            [delegate loginControllerDidLogged:self];
        }
    }
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

//- (IBAction)login:(id)sender {
//    [progressIndicator startAnimation:nil];
//    
//    VKOAuthRequest *authRequest = [[VKOAuthRequest alloc] init];
//    
//    authRequest.appID = VK_APP_ID;
//    authRequest.appSecret = VK_APP_SECRET;
//    authRequest.username = loginField.stringValue;
//    authRequest.password = passwordField.stringValue;
//    authRequest.needNotify = YES;
//    authRequest.needNotifications = YES;
//    authRequest.needFriends = YES;
//    authRequest.needPhotos = YES;
//    authRequest.needAudio = YES;
//    authRequest.needMessages = YES;
//    authRequest.needStatus = YES;
//    
//    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[authRequest oathURL]];
//    
//    [authRequest release];
//    
//    [request setCompletionBlock:^() {
//        [progressIndicator stopAnimation:nil];
//
//        id response = [request.responseString JSONValue];
//
//        if ([response objectForKey:@"error"]) {
//            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
//            [errorDetails setValue:[response objectForKey:@"error_description"] forKey:NSLocalizedDescriptionKey];
//            
//			NSAlert *alert = [NSAlert alertWithError:[NSError errorWithDomain:VK_ERROR_DOMAIN code:500 userInfo:errorDetails]];
//			[alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
//        } else {
//            [VKAccessToken setToken:[response objectForKey:@"access_token"]];
//            [VKAccessToken setUserID:[[response objectForKey:@"user_id"] integerValue]];
//            [VKAccessToken setExpires:[NSDate dateWithTimeIntervalSinceNow:3600 * 1000 * 10]];
//            
//            [VKAccessToken save];
//        
//            if (rememberButton.state) {
//                [VKSettings setLogin:loginField.stringValue];
//            } else {
//                loginField.stringValue = @"";
//                passwordField.stringValue = @"";
//            }
//            
//            if (delegate && [delegate respondsToSelector:@selector(loginControllerDidLogged:)]) {
//                [delegate loginControllerDidLogged:self];
//            }
//        }
//    }];
//    
//    [request setFailedBlock:^() {
//        [progressIndicator stopAnimation:nil];
//
//        NSError *error = request.error;
//        
//        if (error.code == 3) {
//            NSMutableDictionary *errorDetails = [NSMutableDictionary dictionary];
//            [errorDetails setValue:VK_STR_LOGIN_ERROR forKey:NSLocalizedDescriptionKey];
//            
//            error = [NSError errorWithDomain:VK_ERROR_DOMAIN code:500 userInfo:errorDetails];
//        }
//        
//		[VKAccessToken clear];
//
//		NSAlert *alert = [NSAlert alertWithError:error];
//		[alert beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
//    }];
//    
//    [request startAsynchronous];
//}

@end
