//
//  ASIWebDAVRequest.m
//  ASIWebDAVRequest
//
//  Created by Sergey Lenkov on 07.03.11.
//  Copyright 2011 Positive Team. All rights reserved.
//

#import "ASIWebDAVRequest.h"

static NSString *sharedUsername = nil;
static NSString *sharedPassword = nil;
static NSString *sharedHost = nil;
static NSString *_connectionType = @"http";

@implementation ASIWebDAVRequest

- (id)init {
    self = [super init];
    
    if (self) {
        //
    }
    
    return self;
}

- (void)dealloc {
    [super dealloc];
}

+ (NSString *)username {
	return sharedUsername;
}

+ (void)setUsername:(NSString *)newUsername {
	[sharedUsername release];
	sharedUsername = [newUsername retain];
}

+ (NSString *)password {
	return sharedPassword;
}

+ (void)setPassword:(NSString *)newPassword {
	[sharedPassword release];
	sharedPassword = [newPassword retain];
}

+ (NSString *)host {
	return sharedHost;
}

+ (void)setHost:(NSString *)newHost {
	[sharedHost release];
	sharedHost = [newHost retain];
}

+ (id)requestWithPath:(NSString *)path {
    ASIWebDAVRequest *request = [ASIWebDAVRequest requestWithURL:[NSURL URLWithString:[ASIWebDAVRequest urlWithPath:path]]];        
    [request setRequestMethod:@"GET"];
    
    return request;    
}

+ (id)PUTRequestForData:(NSData *)data withPath:(NSString *)path {
	ASIWebDAVRequest *request = [ASIWebDAVRequest requestWithURL:[NSURL URLWithString:[ASIWebDAVRequest urlWithPath:path]]];
    
    [request setRequestMethod:@"PUT"];
    [request addRequestHeader:@"Content-Type" value:@"application/octet-stream"];
    [request addRequestHeader:@"Content-Length" value:[NSString stringWithFormat:@"%d", [data bytes]]];
    [request appendPostData:data];
    
	return request;
}

+ (id)PUTRequestForFile:(NSString *)filePath withPath:(NSString *)path {
	ASIWebDAVRequest *request = [ASIWebDAVRequest requestWithURL:[NSURL URLWithString:[ASIWebDAVRequest urlWithPath:path]]];
    
	[request setPostBodyFilePath:filePath];
	[request setShouldStreamPostDataFromDisk:YES];
	[request setRequestMethod:@"PUT"];
	[request addRequestHeader:@"Content-Type" value:@"application/octet-stream"];
    
	return request;
}

+ (id)PROPFINDRequestWithPath:(NSString *)path {
    ASIWebDAVRequest *request = [ASIWebDAVRequest requestWithURL:[NSURL URLWithString:[ASIWebDAVRequest urlWithPath:path]]];
	[request setRequestMethod:@"PROPFIND"];
    [request addRequestHeader:@"Depth" value:@"0"];
    
	return request;
}

+ (id)MKCOLRequestWithPath:(NSString *)path {
	ASIWebDAVRequest *request = [ASIWebDAVRequest requestWithURL:[NSURL URLWithString:[ASIWebDAVRequest urlWithPath:path]]];
	[request setRequestMethod:@"MKCOL"];
    
	return request;
}

+ (id)DELETERequestWithPath:(NSString *)path {
	ASIWebDAVRequest *request = [ASIWebDAVRequest requestWithURL:[NSURL URLWithString:[ASIWebDAVRequest urlWithPath:path]]];
	[request setRequestMethod:@"DELETE"];
    
	return request;
}

+ (NSString *)urlWithPath:(NSString *)path {
    if ([sharedUsername isEqualToString:@""]) {
        return [ASIWebDAVRequest stringByURLEncodingForWebDAVPath:[NSString stringWithFormat:@"%@://%@/%@", _connectionType, sharedHost, path]];
    } else {
        return [ASIWebDAVRequest stringByURLEncodingForWebDAVPath:[NSString stringWithFormat:@"%@://%@:%@@%@/%@", _connectionType, sharedUsername, sharedPassword, sharedHost, path]];
    }
}

+ (NSString *)stringByURLEncodingForWebDAVPath:(NSString *)path {
    return [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSDictionary *)properties {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    NSArray *lines = [[self responseString] componentsSeparatedByString:@"\n"];
    NSString *item = @"";
    
    for (NSString *line in lines) {
        line = [line stringByRemovingNewLinesAndWhitespace];
        
        if ([line length] > 0) {
            item = [item stringByAppendingString:line];
        }
    }
    
    item = [item stringByRemovingNewLinesAndWhitespace];
    NSString *dateStr = [item stringByMatching:@"getlastmodified.*?>(.*?)<" capture:1];
    
    NSDate *modified = [NSDate dateFromRFC1123:dateStr];
    
    if (modified == nil) {
        modified = [NSDate date];
    }
    
    dateStr = [item stringByMatching:@"creationdate.*?>(.*?)<" capture:1];
    
    NSDate *created = [NSDate dateFromTZ:dateStr];
    
    if (created == nil) {
        created = [NSDate date];
    }
    
    [dict setObject:created forKey:@"Created"];
    [dict setObject:modified forKey:@"Modified"];
    
    return dict;
}

@end
