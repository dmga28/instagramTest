//
//  WebServiceHandler.h
//  InstagramImages
//
//  Created by Daniel Gonzalez on 12/17/14.
//  Copyright (c) 2014 Daniel Gonzalez. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol jsonDonwloadHandler <NSObject>

@required
-(void)didFinishDownloadingJson:(NSDictionary*)json;
@optional
-(void)didFailDownloadingJson:(NSString*)error;

@end

@interface WebServiceHandler : NSObject
-(void)sessionUsingUrl:(NSURL*)url;
+ (WebServiceHandler *)sharedInstance;
@property (nonatomic,weak) id <jsonDonwloadHandler> delegateVC;

@end
