//
//  VKLoginController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 10.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "VKOAuthRequest.h"
#import "VKAccessToken.h"
#import "PTKeychain.h"
#import "VKTileBackgroundView.h"
#import "VKLinkButton.h"

@class VKLoginController;

@protocol VKLoginControllerDelegate <NSObject>

- (void)loginControllerDidCanceled:(VKLoginController *)controller;
- (void)loginControllerDidLogged:(VKLoginController *)controller;

@end

@interface VKLoginController : NSWindowController {
    IBOutlet WebView *webView;
}

@property (nonatomic, assign) id <VKLoginControllerDelegate> delegate;

@end
