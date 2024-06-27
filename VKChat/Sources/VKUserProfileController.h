//
//  VKUserProfileController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 27.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "VKProfile.h"
#import "VKLinkButton.h"

@interface VKUserProfileController : NSWindowController {
    IBOutlet NSImageView *avatarView;
    IBOutlet NSTextField *firstNameField;
	IBOutlet NSTextField *lastNameField;
    IBOutlet NSTextField *birthdayField;
    IBOutlet NSTextField *cityField;
    IBOutlet NSTextField *universityField;
    IBOutlet NSTextField *phoneField;
    IBOutlet VKLinkButton *twitterField;
    IBOutlet VKLinkButton *facebookField;
    IBOutlet NSTextField *birthdayLabel;
    IBOutlet NSTextField *cityLabel;
    IBOutlet NSTextField *universityLabel;
    IBOutlet NSTextField *phoneLabel;
    IBOutlet NSTextField *twitterLabel;
    IBOutlet NSTextField *facebooklabel;
    VKProfile *profile;
}

@property (nonatomic, retain) VKProfile *profile;

- (IBAction)goToTwitter:(id)sender;
- (IBAction)goToFacebook:(id)sender;

@end
