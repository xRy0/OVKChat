//
//  VKAudioDropView.h
//  VKChat
//
//  Created by Sergey Lenkov on 23.12.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VKAudioDropView;

@protocol VKAudioDropViewDelegate <NSObject>

- (void)dropView:(NSView *)dropView didAcceptFiles:(NSArray *)files;

@end

@interface VKAudioDropView : NSView {
    BOOL isDragOver;
}

@property (nonatomic, assign) IBOutlet id <VKAudioDropViewDelegate> delegate;

@end
