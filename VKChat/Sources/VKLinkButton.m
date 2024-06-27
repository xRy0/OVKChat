//
//  VKLinkButton.m
//  VKMessages
//
//  Created by Sergey Lenkov on 02.08.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKLinkButton.h"

@implementation VKLinkButton

@synthesize linkColor;

- (void)setTitle:(NSString *)aString {
    [super setTitle:aString];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:self.alignment];
                       
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:linkColor, NSForegroundColorAttributeName,
                          [NSNumber numberWithInt:NSSingleUnderlineStyle], NSUnderlineStyleAttributeName,
                          paragraphStyle, NSParagraphStyleAttributeName, nil];
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[self title] attributes:dict];
    
    [self setAttributedTitle:attributedString];
    
    [attributedString release];
    [paragraphStyle release];
}

- (void)resetCursorRects {
    [super resetCursorRects];
    [self addCursorRect:self.bounds cursor:[NSCursor pointingHandCursor]];
}

@end
