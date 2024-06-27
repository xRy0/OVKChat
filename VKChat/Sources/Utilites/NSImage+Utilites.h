//
//  NSImage+Utilites.h
//  VKMessages
//
//  Created by Sergey Lenkov on 03.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (Utilites)

- (NSImage *)imageByScalingProportionallyToSize:(NSSize)targetSize;

@end
