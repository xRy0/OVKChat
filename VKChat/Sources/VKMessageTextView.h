//
//  VKMessageTextView.h
//  VKMessages
//
//  Created by Sergey Lenkov on 10.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

enum VKMessageTextFieldActionKey {
    VKMessageTextFieldActionKeyEnter = 0,
    VKMessageTextFieldActionKeyShiftEnter = 1
};

typedef enum VKMessageTextFieldActionKey VKMessageTextFieldActionKey;

@interface VKMessageTextView : NSTextView

@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, assign) VKMessageTextFieldActionKey actionKey;
@property (nonatomic, copy) NSString *placeholderString;

@end
