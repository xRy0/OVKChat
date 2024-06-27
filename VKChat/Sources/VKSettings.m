//
//  VKSettings.m
//  VKMessages
//
//  Created by Sergey Lenkov on 20.06.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKSettings.h"

static VKProfile *_currentProfile = nil;
static NSMutableDictionary *_profiles = nil;

@implementation VKSettings

+ (BOOL)showDockIcon {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ShowDockIcon"] == nil) {
        [VKSettings setShowDockIcon:YES];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowDockIcon"];
}

+ (void)setShowDockIcon:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"ShowDockIcon"];
}

+ (BOOL)showStatusBarIcon {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ShowStatusBarIcon"] == nil) {
        [VKSettings setShowStatusBarIcon:YES];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowStatusBarIcon"];
}

+ (void)setShowStatusBarIcon:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"ShowStatusBarIcon"];
}

+ (NSString *)login {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Login"] == nil) {
        [VKSettings setLogin:@""];
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"Login"];
}

+ (void)setLogin:(NSString *)login {
    [[NSUserDefaults standardUserDefaults] setObject:login forKey:@"Login"];
}

+ (BOOL)showMessageTime {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ShowMessageTime"] == nil) {
        [VKSettings setShowMessageTime:YES];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowMessageTime"];
}

+ (void)setShowMessageTime:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"ShowMessageTime"];
}

+ (BOOL)showMessageAvatar {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"ShowMessageAvatar"] == nil) {
        [VKSettings setShowMessageAvatar:YES];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowMessageAvatar"];
}

+ (void)setShowMessageAvatar:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"ShowMessageAvatar"];
}

+ (BOOL)sendMessageByShiftEnter {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SendMessageByShiftEnter"] == nil) {
        [VKSettings setSendMessageByShiftEnter:NO];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SendMessageByShiftEnter"];
}

+ (void)setSendMessageByShiftEnter:(BOOL)enable {
    [[NSUserDefaults standardUserDefaults] setBool:enable forKey:@"SendMessageByShiftEnter"];
}

+ (NSInteger)volume {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"PlayerVolume"] == nil) {
        [VKSettings setVolume:50];
    }
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"PlayerVolume"];
}

+ (void)setVolume:(NSInteger)volume {
    [[NSUserDefaults standardUserDefaults] setInteger:volume forKey:@"PlayerVolume"];
}

+ (NSInteger)unreadCount {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UnreadCount"] == nil) {
        [VKSettings setUnreadCount:0];
    }
    
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"UnreadCount"];
}

+ (void)setUnreadCount:(NSInteger)count {
    [[NSUserDefaults standardUserDefaults] setInteger:count forKey:@"UnreadCount"];
}

+ (VKProfile *)currentProfile {
    return _currentProfile;
}

+ (void)setCurrentProfile:(VKProfile *)profile {
    _currentProfile = [profile retain];
}

+ (BOOL)isRememberMe {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RememberMe"] == nil) {
        [VKSettings setRememberMe:YES];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"RememberMe"];
}

+ (void)setRememberMe:(BOOL)remeber {
    [[NSUserDefaults standardUserDefaults] setBool:remeber forKey:@"RememberMe"];
}

+ (void)addProfile:(VKProfile *)profile {
    if (_profiles == nil) {
        _profiles = [[NSMutableDictionary alloc] init];
    }
    
    if (![VKSettings isProfileExists:profile.identifier]) {
        [_profiles setObject:profile forKey:[NSString stringWithFormat:@"%ld", profile.identifier]];
    }
}

+ (BOOL)isProfileExists:(NSInteger)userID {
    if (_profiles && [_profiles objectForKey:[NSString stringWithFormat:@"%ld", userID]]) {
        return YES;
    }
    
    return NO;
}

+ (VKProfile *)userProfile:(NSInteger)userID {
    if (_profiles) {
        return [_profiles objectForKey:[NSString stringWithFormat:@"%ld", userID]];
    }
    
    return nil;
}

+ (void)clearProfiles {
    [_profiles removeAllObjects];
    _profiles = nil;
    
    [_currentProfile release];
    _currentProfile = nil;
}

+ (BOOL)isFullScreen {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FullScreen"] == nil) {
        [VKSettings setFullScreen:NO];
    }
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"FullScreen"];
}

+ (void)setFullScreen:(BOOL)fullscreen {
    [[NSUserDefaults standardUserDefaults] setBool:fullscreen forKey:@"FullScreen"];
}

+ (NSString *)audioDevice {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"AudioDevice"];
}

+ (void)setAudioDevice:(NSString *)device {
    [[NSUserDefaults standardUserDefaults] setObject:device forKey:@"AudioDevice"];
}

@end
