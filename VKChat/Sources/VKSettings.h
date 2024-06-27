//
//  VKSettings.h
//  VKMessages
//
//  Created by Sergey Lenkov on 20.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKProfile.h"

@interface VKSettings : NSObject

+ (BOOL)showDockIcon;
+ (void)setShowDockIcon:(BOOL)enable;

+ (BOOL)showStatusBarIcon;
+ (void)setShowStatusBarIcon:(BOOL)enable;

+ (NSString *)login;
+ (void)setLogin:(NSString *)login;

+ (BOOL)showMessageTime;
+ (void)setShowMessageTime:(BOOL)enable;

+ (BOOL)showMessageAvatar;
+ (void)setShowMessageAvatar:(BOOL)enable;

+ (BOOL)sendMessageByShiftEnter;
+ (void)setSendMessageByShiftEnter:(BOOL)enable;

+ (NSInteger)volume;
+ (void)setVolume:(NSInteger)volume;

+ (NSInteger)unreadCount;
+ (void)setUnreadCount:(NSInteger)count;

+ (VKProfile *)currentProfile;
+ (void)setCurrentProfile:(VKProfile *)profile;

+ (BOOL)isRememberMe;
+ (void)setRememberMe:(BOOL)remeber;

+ (void)addProfile:(VKProfile *)profile;
+ (BOOL)isProfileExists:(NSInteger)userID;
+ (VKProfile *)userProfile:(NSInteger)userID;
+ (void)clearProfiles;

+ (BOOL)isFullScreen;
+ (void)setFullScreen:(BOOL)fullscreen;

+ (NSString *)audioDevice;
+ (void)setAudioDevice:(NSString *)device;

@end
