//
//  WebServiceHandler.m
//  InstagramImages
//
//  Created by Daniel Gonzalez on 12/17/14.
//  Copyright (c) 2014 Daniel Gonzalez. All rights reserved.
//

#import "WebServiceHandler.h"

static WebServiceHandler *sharedInstance;

@interface WebServiceHandler ()

@end

@implementation WebServiceHandler

+ (WebServiceHandler *)sharedInstance {
    if (sharedInstance==nil) {
        sharedInstance = [[WebServiceHandler alloc] init];
    }
    return sharedInstance;
}

-(void)sessionUsingUrl:(NSURL*)url{
    __weak WebServiceHandler *weakSelf = self;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //in case there's no internet or any kind of other error the connection failed, or no response, or no data to work with
        if (error || response==nil || data.length==0) {
            [[weakSelf delegateVC] didFailDownloadingJson:@"Error: Probably no internet"];
        }else{
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:NULL];
            [[weakSelf delegateVC] didFinishDownloadingJson:json];
        }
    }];
    [task resume];
}

@end
