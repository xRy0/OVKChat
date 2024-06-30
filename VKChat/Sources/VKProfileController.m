//
//  VKProfileController.m
//  VKMessages
//
//  Created by Sergey Lenkov on 12.05.12.
//  Copyright (c) 2012 Sergey Lenkov. All rights reserved.
//

#import "VKProfileController.h"

@implementation VKProfileController

- (void)dealloc {
    [statusController release];
    [super dealloc];
}

- (void)awakeFromNib {
    [nameButton setTitleWithMnemonic:@""];
    [statusButton setTitleWithMnemonic:@""];
    [logoutMenuItem setTitle:VK_STR_LOGOUT];
    [profileMenuItem setTitle:VK_STR_SHOW_PROFILE];
    
    [statusIcon setHidden:YES];
    [statusButton setFrameOrigin:NSMakePoint(50, 6)];
    
    [nameButton setHidden:YES];
    [statusButton setHidden:YES];
    [avatarButton setHidden:YES];
    [avatarBack setHidden:YES];
    
    statusController = [[VKStatusController alloc] initWithWindowNibName:@"StatusWindow"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusDidChanged:) name:VK_NOTIFICATION_STATUS object:nil];
}

- (void)setProfile:(VKProfile *)profile {
    [avatarButton setImage:profile.photoRec];
    
    NSString *name = [NSString stringWithFormat:@"%@ %@", profile.firstName, profile.lastName];
    
    NSFont *font = [NSFont fontWithName:@"Lucida Grande" size:12];
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    NSSize size = [name sizeWithAttributes:attsDict];
    
    [nameButton setFrameSize:NSMakeSize(size.width + 16, 17)];
    [nameButton setTitle:name];
    
    [nameButton setHidden:NO];
    [statusButton setHidden:NO];
    [avatarButton setHidden:NO];
    [avatarBack setHidden:NO];
}

- (void)setStatus:(VKStatus *)status {
    NSString *text = [status.text stringByConvertingHTMLToPlainText];
    
    if ([text length] == 0) {
        text = VK_STR_EMPTY_STATUS;
    }

    NSFont *font = [NSFont fontWithName:@"Lucida Grande" size:12];
    NSDictionary *attsDict = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, nil];
    
    NSSize size = [text sizeWithAttributes:attsDict];

    if (statusButton.frame.origin.x + size.width + 10 > self.view.frame.size.width) {
        [statusButton setFrameSize:NSMakeSize(self.view.frame.size.width - statusButton.frame.origin.x, 17)];
    } else {
        [statusButton setFrameSize:NSMakeSize(size.width + 16, 17)];
    }
    
    if (status.song) {
        [statusIcon setHidden:NO];
        [statusButton setFrameOrigin:NSMakePoint(70, 6)];
    } else {
        [statusIcon setHidden:YES];
        [statusButton setFrameOrigin:NSMakePoint(50, 6)];
    }

    [statusButton setTitle:text];
}

- (void)statusDidChanged:(NSNotification *)notification {
    VKStatus *status = [[VKStatus alloc] init];
    
    status.text = [notification object];
    
    [self setStatus:status];
    [status release];
}

- (void)pictureTakerDidEnd:(IKPictureTaker *)pictureTaker code:(int)returnCode contextInfo:(void *)ctxInf {
    if (returnCode == NSOKButton){
        __block NSImage *image = [pictureTaker outputImage];
        
        __block VKGetProfileUploadServerRequest *request = [[VKGetProfileUploadServerRequest alloc] init];
        
        request.accessToken = [VKAccessToken token];
        
        VKGetProfileUploadServerRequestResultBlock resultBlock = ^(NSURL *url){
            __block ASIFormDataRequest *post = [ASIFormDataRequest requestWithURL:url];
            
            NSBitmapImageRep *imgRep = nil;

            // Найти представление типа NSBitmapImageRep
            for (NSImageRep *rep in [image representations]) {
                if ([rep isKindOfClass:[NSBitmapImageRep class]]) {
                    imgRep = (NSBitmapImageRep *)rep;
                    break;
                }
            }
            
            if (imgRep) {
                NSData *data = [imgRep representationUsingType:NSPNGFileType properties:nil];
                [post addData:data withFileName:@"photo.png" andContentType:@"image/png" forKey:@"photo"];
            } else {
                // Обработка случая, когда NSBitmapImageRep не найдено
                NSLog(@"Не удалось найти NSBitmapImageRep в представлениях изображения");
            }
            
            
            
            [post setCompletionBlock:^() {                
                id response = [post.responseString JSONValue];
                
                if ([response objectForKey:@"photo"]) {
                    __block VKSaveProfilePhotoRequest *save = [[VKSaveProfilePhotoRequest alloc] init];
                    
                    save.accessToken = [VKAccessToken token];
                    save.serverID = [[response objectForKey:@"server"] intValue];
                    save.photo = [response objectForKey:@"photo"];
                    save.hash = [response objectForKey:@"hash"];
                    
                    VKSaveProfilePhotoRequestResultBlock resultBlock = ^(NSString *hash, NSURL *url) {
                        [avatarButton setImage:image];
                        [save release];
                    };
                    
                    VKRequestFailureBlock failureBlock = ^(NSError *error) {
                        NSLog(@"%@", [error localizedDescription]);
                        [save release];
                    };
                    
                    [save startWithResultBlock:resultBlock failureBlock:failureBlock];
                } else {
                    NSLog(@"CANNOT UPLOAD SERVER");
                }
            }];
            
            [post setBytesSentBlock:^(unsigned long long bytes, unsigned long long total) {
                NSLog(@"%llu %llu", bytes, total);
            }];
            
            [post setFailedBlock:^{
                NSLog(@"%@", [post.error localizedDescription]);
            }];
            
            [post startAsynchronous];
            
            [request release];
        };
        
        VKRequestFailureBlock failureBlock = ^(NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
            [request release];
        };
        
        [request startWithResultBlock:resultBlock failureBlock:failureBlock];
    }
}

#pragma mark -
#pragma mark IBAction
#pragma mark -

- (IBAction)showMenu:(id)sender {
    NSRect frame = [(NSButton *)sender frame];
	NSPoint menuOrigin;
    
    menuOrigin = [[(NSButton *)sender superview] convertPoint:NSMakePoint(frame.origin.x, frame.origin.y) toView:nil];	
	
    NSEvent *event = [NSEvent mouseEventWithType:NSLeftMouseDown location:menuOrigin modifierFlags:NSLeftMouseDownMask timestamp:0 windowNumber:[[(NSButton *)sender window] windowNumber] context:[[(NSButton *)sender window] graphicsContext] eventNumber:0 clickCount:1 pressure:1];
    [NSMenu popUpContextMenu:popupMenu withEvent:event forView:(NSButton *)sender withFont:[NSFont menuFontOfSize:13]];
}

- (IBAction)changeStatus:(id)sender {
    [NSApp beginSheet:statusController.window modalForWindow:[[NSApp delegate] window] modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)logout:(id)sender {
    [avatarButton setImage:nil];
    [nameButton setTitleWithMnemonic:@""];
    [statusButton setTitleWithMnemonic:@""];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_LOGOUT object:nil];
}

- (IBAction)selectAvatar:(id)sender {
    IKPictureTaker *picker = [IKPictureTaker pictureTaker];
    
    [picker setValue:[NSNumber numberWithBool:YES] forKey:IKPictureTakerShowEffectsKey];
    [picker setInputImage:[VKSettings currentProfile].photoBig];
    [picker beginPictureTakerSheetForWindow:self.view.window withDelegate:self didEndSelector:@selector(pictureTakerDidEnd:code:contextInfo:) contextInfo:nil];
}

- (IBAction)showProfile:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:VK_NOTIFICATION_SHOW_USER_PROFILE object:[VKSettings currentProfile]];
}

@end
