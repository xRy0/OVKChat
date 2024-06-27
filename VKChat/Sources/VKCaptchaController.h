//
//  VKCaptchaController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 12.07.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VKCaptchaControllerDelegate <NSObject>

- (void)textDidEntered:(NSString *)text forCaptcha:(NSInteger)captchaID;

@end

@interface VKCaptchaController : NSWindowController {
    IBOutlet NSImageView *imageVIew;
    IBOutlet NSTextField *textField;
    IBOutlet NSButton *doneButton;
    IBOutlet NSButton *cancelButton;
}

@property (nonatomic, assign) NSInteger captchaID;
@property (nonatomic, retain) NSURL *captchaURL;
@property (nonatomic, assign) id <VKCaptchaControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
