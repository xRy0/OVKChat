//
//  main.m
//  VKMessages
//
//  Created by Sergey Lenkov on 08.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
    @autoreleasepool {
            if (@available(macOS 10.14, *)) {
                [NSApplication sharedApplication].appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
            }
            return NSApplicationMain(argc, (const char **)argv);
        }
    
}
