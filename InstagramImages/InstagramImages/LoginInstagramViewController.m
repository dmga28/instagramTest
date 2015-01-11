//
//  LoginInstagramViewController.m
//  InstagramImages
//
//  Created by Daniel Gonzalez on 1/8/15.
//  Copyright (c) 2015 Daniel Gonzalez. All rights reserved.
//

#import "LoginInstagramViewController.h"
#import "InstagramConstants.h"
#import "NSDictionary+UrlEncoding.h"
#import "WebServiceHandler.h"

@interface LoginInstagramViewController () <jsonDonwloadHandler>
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) NSArray* imagesSource;
@end

__weak LoginInstagramViewController* weakSelf;
//NSMutableArray* sortedImages;

@implementation LoginInstagramViewController

#pragma mark - override of getters and setters

@synthesize imagesSource = _imagesSource;
-(void)setImagesSource:(NSArray *)imagesSource{
    dispatch_async(dispatch_get_main_queue(), ^{
        _imagesSource = imagesSource;
#warning reload data here
    });
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    weakSelf = self;
    //sortedImages = [NSMutableArray new];
    [[WebServiceHandler sharedInstance] setDelegateVC:self];
//    [[WebServiceHandler sharedInstance] sessionUsingUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/v1/media/popular?client_id=%@",INSTAGRAM_DOMAIN,INSTAGRAM_CLIENT_ID]]];
    [[WebServiceHandler sharedInstance] sessionUsingUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@/v1/tags/%@/media/recent?client_id=%@",INSTAGRAM_DOMAIN,INSTAGRAM_TAG,INSTAGRAM_CLIENT_ID]]];
}

#pragma mark - helpers

-(void)showAlertMessage:(NSString*)text{
    //gets on the main queue so it can show the alert
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:text delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    });
}

-(BOOL)array:(NSArray*)array containsString:(NSString*)text{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",[NSString stringWithFormat:@"%@",text]];
    NSArray *hasString = [array filteredArrayUsingPredicate:predicate];
    if ([hasString count]>0) {
        return YES;
    }
    return NO;
}

//-(void)loadAndDisplayImages:(NSArray*)images{
//    float screenWidth = [[self mainScrollView] frame].size.width;
//    float spacer = 100;
//    float currentY = spacer;
//    for (NSDictionary* image in images) {
//        float width = [image[@"width"] integerValue]*0.5;
//        float height = [image[@"height"] integerValue]*0.5;
//        UIImageView* view = [[UIImageView alloc] initWithFrame:CGRectMake((screenWidth*0.5)-(width*0.5), currentY, width, height)];
//        [view setUserInteractionEnabled:YES];
//        [view setImage:[UIImage imageNamed:@"loading.jpg"]];
//        [[self mainScrollView] addSubview:view];
//        currentY+=height+spacer;
//    }
//    
//#warning change the scrollview size
//}

#pragma mark - webServiceHandler delegate

-(void)didFinishDownloadingJson:(NSDictionary*)json{
    NSLog(@"json:\n%@",json);
    if ([json[@"meta"][@"code"] integerValue]!=200) {
        [weakSelf showAlertMessage:@"Error: status code is not ok"];
        return;
    }
    NSMutableArray* dictImages = [NSMutableArray new];
    int orderSize = 0; //counter to order images by big,small,small (repeat)
    for (NSDictionary* user in json[@"data"]) {
//        NSArray* tags = user[@"tags"];
//        if (![weakSelf array:tags containsString:INSTAGRAM_TAG]) {
//            continue;
//        }
        NSDictionary* images = [user objectForKey:@"images"];
        if (orderSize%3==0) { //if 0 use big image
            [dictImages addObject:[images objectForKey:@"standard_resolution"]];
        }else{ //use small image
            [dictImages addObject:[images objectForKey:@"low_resolution"]];
        }
        orderSize++;
    }
    [weakSelf setImagesSource:dictImages];
}

-(void)didFailDownloadingJson:(NSString*)error{
    [self showAlertMessage:error];
}


@end
