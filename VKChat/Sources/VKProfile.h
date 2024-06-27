//
//  VKUserProfile.h
//  VKMessages
//
//  Created by Sergey Lenkov on 11.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKGetCityByIdRequest.h"

@interface VKProfile : NSObject

@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, retain) NSImage *photoBig;
@property (nonatomic, retain) NSImage *photoRec;
@property (nonatomic, retain) NSURL *photoBigURL;
@property (nonatomic, retain) NSURL *photoRecURL;
@property (nonatomic, assign) BOOL isOnline;
@property (nonatomic, retain) NSDate *lastSeen;
@property (nonatomic, retain) NSDate *birthday;
@property (nonatomic, assign) BOOL birthdayWithYear;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *university;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *twitter;
@property (nonatomic, copy) NSString *facebookID;
@property (nonatomic, copy) NSString *facebookName;

- (id)initWithDictionary:(NSDictionary *)dict;
- (id)initWithDictionary:(NSDictionary *)dict loadPhoto:(BOOL)loadPhoto;

@end
