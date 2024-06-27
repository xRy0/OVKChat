//
//  VKImageController.h
//  VKMessages
//
//  Created by Sergey Lenkov on 23.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VKPhoto.h"

@interface VKImageController : NSWindowController {
    IBOutlet NSImageView *imageView;
    VKPhoto *photo;
}

@property (nonatomic, retain) VKPhoto *photo;

@end
