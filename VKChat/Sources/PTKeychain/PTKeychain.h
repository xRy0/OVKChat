//
// Copyright 2009 Sergey Lenkov
//

#import <Cocoa/Cocoa.h>
#import <Security/Security.h>
#import <CoreFoundation/CoreFoundation.h>

@interface PTKeychain : NSObject {

}

+ (BOOL)keychainExistsWithLabel:(NSString *)label forAccount:(NSString *)account;
+ (BOOL)deleteKeychainPasswordForLabel:(NSString *)label account:(NSString *)account;
+ (BOOL)modifyKeychainPassword:(NSString *)password withLabel:(NSString *)label forAccount:(NSString *)account;
+ (BOOL)addKeychainPassword:(NSString *)password withLabel:(NSString *)label forAccount:(NSString *)account;
+ (NSString *)passwordForLabel:(NSString *)label account:(NSString *)account;
+ (NSString *)passwordFromSecKeychainItemRef:(SecKeychainItemRef)item;

@end
