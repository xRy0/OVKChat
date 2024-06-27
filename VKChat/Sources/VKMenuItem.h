//
//  VKMenuItem.h
//  VKMessages
//
//  Created by Sergey Lenkov on 13.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

enum VKMenuTypes {
    VKMenuTypeMessages = 0,
    VKMenuTypeAudio = 1,
    VKMenuTypePictures = 2,
    VKMenuTypePreferences = 3,
    VKMenuTypeSeparator = 4
};

typedef enum VKMenuTypes VKMenuTypes;

@interface VKMenuItem : NSObject {
    NSString *name;
    VKMenuTypes type;
}

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) VKMenuTypes type;

@end
