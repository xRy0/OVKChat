//
//  VKImageController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 23.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKImageController.h"

@implementation VKImageController

@synthesize photo;

- (void)dealloc {
    [photo release];
    [super dealloc];
}

- (void)showWindow:(id)sender {
    imageView.image = nil;
    
    NSRect frame = [[NSApplication sharedApplication] mainWindow].frame;
    
    frame.origin.x = (frame.origin.x + (frame.size.width / 2));
    frame.origin.y = (frame.origin.y + (frame.size.height / 2));
    frame.size.width = 0;
    frame.size.height =  0;
    
    [self.window setFrame:frame display:NO];
    
    [super showWindow:sender];
}

- (void)setPhoto:(VKPhoto *)aPhoto {
    [photo release];
    photo = [aPhoto retain];
    
    if (photo.imageBig == nil) {
        imageView.image = photo.image;
        
        __block ASIHTTPRequest *imageRequest = [ASIHTTPRequest requestWithURL:photo.urlBig];
        
        [imageRequest setCompletionBlock:^(void) {
            photo.imageBig = [[NSImage alloc] initWithData:imageRequest.responseData];
            imageView.image = photo.imageBig;
            
            [self resize];
        }];
        
        [imageRequest startAsynchronous];
    } else {
        imageView.image = photo.imageBig;
        [self resize];
    }
}

- (void)resize {
    NSRect rect = self.window.frame;
    
    NSArray *representations = [photo.imageBig representations];
    
    NSInteger width = 0;
    NSInteger height = 0;
    
    for (NSImageRep * imageRep in representations) {
        if ([imageRep pixelsWide] > width) width = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > height) height = [imageRep pixelsHigh];
    }

    rect.size.width = width;
    rect.size.height = height + 20;
    
    NSRect frame = [[NSApplication sharedApplication] mainWindow].frame;
    
    rect.origin.x = (frame.origin.x + (frame.size.width / 2)) - (width / 2);
    rect.origin.y = (frame.origin.y + (frame.size.height / 2)) - (height / 2);
    
    [self.window setFrame:rect display:YES animate:YES];
}

@end
