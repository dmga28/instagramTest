//
//  imageDownloaded.m
//  InstagramImages
//
//  Created by Daniel Gonzalez on 1/11/15.
//  Copyright (c) 2015 Daniel Gonzalez. All rights reserved.
//

#import "ImageDownloaded.h"

@interface ImageDownloaded ()

@property (nonatomic,strong) NSString* url;

@end

@implementation ImageDownloaded

-(void)setImageFromDictionary:(__weak NSMutableDictionary*)imageDict{
    static NSString *keyForTheImage = @"ImageDownloaded";
    UIImage* imageDL = [imageDict objectForKey:keyForTheImage];
    if (imageDL) {
        [self setImage:imageDL];
        return;
    }//else contine
    [self setImage:[UIImage imageNamed:@"loading.jpg"]];
    NSString* url = [imageDict objectForKey:@"url"];
    if ([url isEqualToString:[self url]]) {
        //if its reusing the cell with the same image do nothing
        return;
    }
    [self setUrl:url];
    __weak __block ImageDownloaded* weakSelf = self;
    __block NSString* urlBlock = [NSString stringWithString:url];
    [ImageDownloaded loadFromURL:url callback:^(NSData* image){
        UIImage* imageDownloaded = [UIImage imageWithData:image];
        [imageDict setObject:imageDownloaded forKey:keyForTheImage];
        if (weakSelf != nil) {
            //verifies that the uiimageView is not been reused with another image at the moment, if it is still the image desired to load it will set the image
            if ([urlBlock isEqualToString:[weakSelf url]]) {
                [UIView transitionWithView:weakSelf
                                  duration:0.5f
                                   options:UIViewAnimationOptionTransitionCrossDissolve
                                animations:^{
                                    [weakSelf setImage:imageDownloaded];
                                } completion:NULL];
            }
        }
    }];
}

+ (void) loadFromURL: (NSString*) url callback:(void (^)(NSData *image))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        dispatch_async(dispatch_get_main_queue(), ^{
            callback(imageData);
        });
    });
}

@end
