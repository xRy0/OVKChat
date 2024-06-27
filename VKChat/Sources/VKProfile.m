//
//  VKUserProfile.m
//  VKMessages
//
//  Created by Sergey Lenkov on 11.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKProfile.h"

@implementation VKProfile

@synthesize identifier;
@synthesize firstName;
@synthesize lastName;
@synthesize photoBig;
@synthesize photoRec;
@synthesize photoBigURL;
@synthesize photoRecURL;
@synthesize isOnline;
@synthesize lastSeen;
@synthesize birthday;
@synthesize birthdayWithYear;
@synthesize city;
@synthesize country;
@synthesize university;
@synthesize mobile;
@synthesize twitter;
@synthesize facebookID;
@synthesize facebookName;

- (void)dealloc {
    [firstName release];
    [lastName release];
    [photoBig release];
    [photoRec release];
	[photoBigURL release];
	[photoRecURL release];
    [lastSeen release];
    [city release];
    [country release];
    [university release];
    [mobile release];
    [twitter release];
    [facebookID release];
    [facebookName release];
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    
    if (self) {
        [self _initWithDictionary:dict withPhoto:YES];
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)dict loadPhoto:(BOOL)loadPhoto {
    self = [super init];
    
    if (self) {
        [self _initWithDictionary:dict withPhoto:loadPhoto];
    }
    
    return self;
}

- (void)_initWithDictionary:(NSDictionary *)dict withPhoto:(BOOL)withPhoto {
    self.identifier = [[dict objectForKey:@"id"] intValue];
    self.firstName = [dict objectForKey:@"first_name"];
    self.lastName = [dict objectForKey:@"last_name"];
    self.isOnline = [[dict objectForKey:@"online"] boolValue];
    self.lastSeen = [NSDate dateWithTimeIntervalSince1970:[[[dict objectForKey:@"last_seen"] objectForKey:@"time"] intValue]];
    self.photoBigURL = [NSURL URLWithString:[dict objectForKey:@"photo_400_orig"]];
    self.photoRecURL = [NSURL URLWithString:[dict objectForKey:@"photo_400_orig"]];
    
    if (withPhoto) {
        NSImage *_image = [[NSImage alloc] initWithContentsOfURL:self.photoBigURL];
        self.photoBig = _image;
        [_image release];
        
        _image = [[NSImage alloc] initWithContentsOfURL:self.photoRecURL];
        self.photoRec = _image;
        [_image release];
    }
    
    self.city = @"";
    self.university = @"";
    self.mobile = @"";
    self.twitter = @"";
    self.facebookID = @"";
    self.facebookName = @"";
    self.country = @"";
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"dd.MM.yyyy"];
    
    self.birthdayWithYear = YES;
    self.birthday = [formatter dateFromString:[dict objectForKey:@"bdate"]];
    
    if (self.birthday == nil) {
        [formatter setDateFormat:@"dd.MM"];
        
        self.birthdayWithYear = NO;
        self.birthday = [formatter dateFromString:[dict objectForKey:@"bdate"]];
    }
    
    if ([dict objectForKey:@"university_name"]) {
        self.university = [dict objectForKey:@"university_name"];
    }
    
    if ([dict objectForKey:@"mobile_phone"]) {
        self.mobile = [dict objectForKey:@"mobile_phone"];
    }
    
    if ([dict objectForKey:@"twitter"]) {
        self.twitter = [dict objectForKey:@"twitter"];
    }
    
    if ([dict objectForKey:@"facebook"]) {
        self.facebookID = [dict objectForKey:@"facebook"];
        self.facebookName = [dict objectForKey:@"facebook_name"];
    }
    
    if ([dict objectForKey:@"city"]) {
        
        self.city = [dict objectForKey:@"city"];
        
    }
}
@end
