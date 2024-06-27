//
//  VKCaptchaController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 12.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKCaptchaController.h"

@implementation VKCaptchaController

@synthesize captchaID;
@synthesize captchaURL;
@synthesize delegate;

- (void)dealloc {
    [captchaURL release];
    [super dealloc];
}

- (void)awakeFromNib {
    self.window.title = VK_STR_CAPTCHA;
    [cancelButton setTitle:VK_STR_CANCEL];
    [doneButton setTitle:VK_STR_SEND];
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    
    if (![self.window setFrameUsingName:@"Captcha"]) {
		[self.window center];
	}
    
    NSImage *_image = [[NSImage alloc] initWithContentsOfURL:captchaURL];
    imageVIew.image = _image;
    [_image release];
}

- (IBAction)done:(id)sender {
    [self close];
    
    if (delegate && [delegate respondsToSelector:@selector(textDidEntered: forCaptcha:)]) {
        [delegate textDidEntered:textField.stringValue forCaptcha:captchaID];
    }
}

- (IBAction)cancel:(id)sender {
    [self close];
}

@end
