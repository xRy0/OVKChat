//
//  VKUserProfileController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 27.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKUserProfileController.h"

@implementation VKUserProfileController

@synthesize profile;

- (void)dealloc {
    [profile release];
    [super dealloc];
}

- (void)awakeFromNib {
    birthdayLabel.stringValue = VK_STR_BIRTHDAY;
    cityLabel.stringValue = VK_STR_CITY;
    universityLabel.stringValue = VK_STR_UNIVERSITY;
    phoneLabel.stringValue = VK_STR_PHONE;
    twitterLabel.stringValue = VK_STR_TWITTER;
    facebooklabel.stringValue = VK_STR_FACEBOOK;
	twitterField.linkColor = [NSColor colorWithDeviceRed:255.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1.0];
	facebookField.linkColor = [NSColor colorWithDeviceRed:255.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1.0];
}

- (void)showWindow:(id)sender {
    [super showWindow:sender];
    
    if (![self.window setFrameUsingName:@"Profile"]) {
		[self.window center];
	}
}

- (void)setProfile:(VKProfile *)aProfile {
    [profile release];
    profile = [aProfile retain];
    
	[self updateProfile];
}

- (void)loadAvatar {
	__block ASIHTTPRequest *_request = [[ASIHTTPRequest alloc] initWithURL:profile.photoBigURL];
    _request.timeOutSeconds = 60;

	[_request setCompletionBlock:^() {
		NSImage *image = [[NSImage alloc] initWithData:_request.responseData];
		profile.photoBig = image;
		[image release];
		
		[self updateProfile];
	}];
	
    [_request startAsynchronous];
}

- (void)updateProfile {
	if (profile.photoBig) {
		avatarView.image = profile.photoBig;
	} else {
		avatarView.image = profile.photoRec;
		[self loadAvatar];
	}
	
	int y = 153;
	
    firstNameField.stringValue = profile.firstName;
	lastNameField.stringValue = profile.lastName;
	
	if (profile.city.length > 0) {
		cityField.stringValue = profile.city;
		
		NSRect frame = cityLabel.frame;
		frame.origin.y = y;
		
		cityLabel.frame = frame;
		
		frame = cityField.frame;
		frame.origin.y = y;
		
		cityField.frame = frame;
		
		cityLabel.hidden = NO;
		cityField.hidden = NO;
		
		y = y - 25;
	} else {
		cityLabel.hidden = YES;
		cityField.hidden = YES;
	}
    
	if (profile.university.length > 0) {
		universityField.stringValue = profile.university;
		
		NSRect frame = universityLabel.frame;
		frame.origin.y = y;
		
		universityLabel.frame = frame;
		
		frame = universityField.frame;
		frame.origin.y = y;
		
		universityField.frame = frame;
		
		universityLabel.hidden = NO;
		universityField.hidden = NO;
		
		y = y - 25;
	} else {
		universityLabel.hidden = YES;
		universityField.hidden = YES;
	}
	
    /*if (profile.university.length > 0) {
		universityField.stringValue = profile.university;
		
		NSRect frame = universityLabel.frame;
		frame.origin.y = y;
		
		universityLabel.frame = frame;
		
		frame = universityField.frame;
		frame.origin.y = y;
		
		universityField.frame = frame;
		
		universityLabel.hidden = NO;
		universityField.hidden = NO;
		
		y = y - 25;
	} else {
		universityLabel.hidden = YES;
		universityField.hidden = YES;
	}*/
	
	if (profile.mobile.length > 0) {
		phoneField.stringValue = profile.mobile;
		
		NSRect frame = phoneLabel.frame;
		frame.origin.y = y;
		
		phoneLabel.frame = frame;
		
		frame = phoneField.frame;
		frame.origin.y = y;
		
		phoneField.frame = frame;
		
		phoneLabel.hidden = NO;
		phoneField.hidden = NO;
		
		y = y - 25;
	} else {
		phoneLabel.hidden = YES;
		phoneField.hidden = YES;
	}
	
    if (profile.birthday) {
		if (profile.birthdayWithYear) {
			birthdayField.stringValue = [profile.birthday shortDateRepresentation];
		} else {
			birthdayField.stringValue = [NSString stringWithFormat:@"%ld %@", [profile.birthday day], [profile.birthday monthName]];
		}
		
		NSRect frame = birthdayLabel.frame;
		frame.origin.y = y;
		
		birthdayLabel.frame = frame;
		
		frame = birthdayField.frame;
		frame.origin.y = y;
		
		birthdayField.frame = frame;
		
		birthdayLabel.hidden = NO;
		birthdayField.hidden = NO;
		
		y = y - 25;
	} else {
		birthdayLabel.hidden = YES;
		birthdayField.hidden = YES;
	}
	
	if (profile.twitter.length > 0) {
		[twitterField setTitle:[NSString stringWithFormat:@"@%@", profile.twitter]];
		
		NSRect frame = twitterLabel.frame;
		frame.origin.y = y;
		
		twitterLabel.frame = frame;
		
		frame = twitterField.frame;
		frame.origin.y = y - 5;
		
		twitterField.frame = frame;
		
		twitterLabel.hidden = NO;
		twitterField.hidden = NO;
		
		y = y - 25;
	} else {
		twitterLabel.hidden = YES;
		twitterField.hidden = YES;
	}
	
    if (profile.facebookName.length > 0) {
		[facebookField setTitle:profile.facebookName];
		
		NSRect frame = facebooklabel.frame;
		frame.origin.y = y;
		
		facebooklabel.frame = frame;
		
		frame = facebookField.frame;
		frame.origin.y = y - 5;
		
		facebookField.frame = frame;
		
		facebooklabel.hidden = NO;
		facebookField.hidden = NO;
		
		y = y - 25;
	} else {
		facebooklabel.hidden = YES;
		facebookField.hidden = YES;
	}
    
    [twitterField setTextColor:[NSColor whiteColor]];
    [facebookField setTextColor:[NSColor whiteColor]];
}

- (IBAction)goToTwitter:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://twitter.com/%@", profile.twitter]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)goToFacebook:(id)sender {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://facebook.com/profile.php?id=%@", profile.facebookID]];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

@end
