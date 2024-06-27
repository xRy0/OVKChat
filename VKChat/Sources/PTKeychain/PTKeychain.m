//
// Copyright 2009 Sergey Lenkov
//

#import "PTKeychain.h"

@implementation PTKeychain

+ (BOOL)keychainExistsWithLabel:(NSString *)label forAccount:(NSString *)account {
	SecKeychainSearchRef search;
	SecKeychainItemRef item;
	SecKeychainAttribute attributes[4];
    int numberOfItemsFound = 0;
	    
	attributes[0].tag = kSecGenericItemAttr;
    attributes[0].data = "application password";
    attributes[0].length = 20;
	
	attributes[1].tag = kSecLabelItemAttr;
	attributes[1].data = (char *)[label UTF8String];
    attributes[1].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[2].tag = kSecAccountItemAttr;
    attributes[2].data = (char *)[account UTF8String];
    attributes[2].length = (UInt32)[account lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[3].tag = kSecServiceItemAttr;
	attributes[3].data = (char *)[label UTF8String];
    attributes[3].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	SecKeychainAttributeList list = {4, attributes};
	
    SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);
    
	while (SecKeychainSearchCopyNext(search, &item) == noErr) {
        CFRelease (item);
        numberOfItemsFound++;
    }
	
    CFRelease (search);
	return numberOfItemsFound;
}

+ (BOOL)deleteKeychainPasswordForLabel:(NSString *)label account:(NSString *)account {
	SecKeychainAttribute attributes[4];
    SecKeychainItemRef item;
	SecKeychainSearchRef search;
    OSStatus status;
	int numberOfItemsFound = 0;
	   
	attributes[0].tag = kSecGenericItemAttr;
    attributes[0].data = "application password";
    attributes[0].length = 20;
	
	attributes[1].tag = kSecLabelItemAttr;
    attributes[1].data = (char *)[label UTF8String];
    attributes[1].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[2].tag = kSecAccountItemAttr;
    attributes[2].data = (char *)[account UTF8String];
    attributes[2].length = (UInt32)[account lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[3].tag = kSecServiceItemAttr;
    attributes[3].data = (char *)[label UTF8String];
    attributes[3].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	SecKeychainAttributeList list = {4, attributes};
	
	SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);
    
	while (SecKeychainSearchCopyNext(search, &item) == noErr) {
        numberOfItemsFound++;
    }
    
	if (numberOfItemsFound) {
		status = SecKeychainItemDelete(item);
	}
	
	CFRelease (item);
	CFRelease(search);
	
	return !status;
}

+ (BOOL)modifyKeychainPassword:(NSString *)password withLabel:(NSString *)label forAccount:(NSString *)account {
	SecKeychainAttribute attributes[4];
    SecKeychainItemRef item;
	SecKeychainSearchRef search;
    OSStatus status;
	
	attributes[0].tag = kSecGenericItemAttr;
    attributes[0].data = "application password";
    attributes[0].length = 20;
	
	attributes[1].tag = kSecLabelItemAttr;
    attributes[1].data = (char *)[label UTF8String];
    attributes[1].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[2].tag = kSecAccountItemAttr;
    attributes[2].data = (char *)[account UTF8String];
    attributes[2].length = (UInt32)[account lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[3].tag = kSecServiceItemAttr;
    attributes[3].data = (char *)[label UTF8String];
    attributes[3].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

	SecKeychainAttributeList list = {4, attributes};
	
	SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);
	SecKeychainSearchCopyNext (search, &item);
    status = SecKeychainItemModifyContent(item, &list, (UInt32)[password length], [password UTF8String]);
	
	CFRelease (item);
	CFRelease(search);
	
	return !status;
}

+ (BOOL)addKeychainPassword:(NSString *)password withLabel:(NSString *)label forAccount:(NSString *)account {
	SecKeychainAttribute attributes[4];
    SecKeychainItemRef item;
    OSStatus status;
	
	attributes[0].tag = kSecGenericItemAttr;
    attributes[0].data = "application password";
    attributes[0].length = 20;
	
	attributes[1].tag = kSecLabelItemAttr;
    attributes[1].data = (char *)[label UTF8String];
    attributes[1].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[2].tag = kSecAccountItemAttr;
    attributes[2].data = (char *)[account UTF8String];
    attributes[2].length = (UInt32)[account lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[3].tag = kSecServiceItemAttr;
    attributes[3].data = (char *)[label UTF8String];
    attributes[3].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	SecKeychainAttributeList list = {4, attributes};
	
    status = SecKeychainItemCreateFromContent(kSecGenericPasswordItemClass, &list, (UInt32)[password length], [password UTF8String], NULL, NULL, &item);
	
	return !status;
}

+ (NSString *)passwordForLabel:(NSString *)label account:(NSString *)account {
    SecKeychainSearchRef search;
    SecKeychainItemRef item;
    SecKeychainAttribute attributes[4];
	OSStatus status;
	
	attributes[0].tag = kSecGenericItemAttr;
    attributes[0].data = "application password";
    attributes[0].length = 20;
	
	attributes[1].tag = kSecLabelItemAttr;
    attributes[1].data = (char *)[label UTF8String];
    attributes[1].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	attributes[2].tag = kSecAccountItemAttr;
    attributes[2].data = (char *)[account UTF8String];
    attributes[2].length = (UInt32)[account lengthOfBytesUsingEncoding:NSUTF8StringEncoding];

	attributes[3].tag = kSecServiceItemAttr;
    attributes[3].data = (char *)[label UTF8String];
    attributes[3].length = (UInt32)[label lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	
	SecKeychainAttributeList list = {4, attributes};
	
    SecKeychainSearchCreateFromAttributes(NULL, kSecGenericPasswordItemClass, &list, &search);
	
	NSString *password = @"";
	status = SecKeychainSearchCopyNext(search, &item);
	
    if (status == noErr) {
		password = [self passwordFromSecKeychainItemRef:item];
		CFRelease(item);
		CFRelease(search);
	}
 	
	return password;
}

+ (NSString *)passwordFromSecKeychainItemRef:(SecKeychainItemRef)item {
    UInt32 length;
    char *password;
    SecKeychainAttribute attributes[8];
    OSStatus status;
	
	NSString *returnedPass;
	
    attributes[0].tag = kSecAccountItemAttr;
	attributes[1].tag = kSecGenericItemAttr;
    attributes[2].tag = kSecLabelItemAttr;
	attributes[3].tag = kSecServiceItemAttr;
    attributes[4].tag = kSecModDateItemAttr;
	
	SecKeychainAttributeList list = {4, attributes};
	
    status = SecKeychainItemCopyContent (item, NULL, &list, &length, (void **)&password);

    if (status == noErr) {
        if (password != NULL) {
            char passwordBuffer[1024];
			
            if (length > 1023) {
                length = 1023;
            }
			
            strncpy (passwordBuffer, password, length);
			
            passwordBuffer[length] = '\0';
			returnedPass = [NSString stringWithCString:passwordBuffer encoding:NSUTF8StringEncoding];
        }
		
        SecKeychainItemFreeContent(&list, password);		
    } else {        
		returnedPass = @"";
    }
	
	return returnedPass;	
}

@end
