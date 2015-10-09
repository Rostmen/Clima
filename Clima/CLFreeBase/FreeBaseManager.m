//
//  FreeBaseManager.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 4/20/14.
//  Copyright (c) 2014 Rost's company. All rights reserved.
//

#import "FreeBaseManager.h"

NSString *const FreeBaseApiPoint = @"https://www.googleapis.com/freebase/v1/mqlread?query=[{%@}]&key=AIzaSyDu_9QXeQFQ1Upxy3aGX3rqbTSt4Bs2Bqk";
NSString *const FreeBaseImages = @"https://usercontent.googleapis.com/freebase/v1/image/%@?maxwidth=1000&maxheight=1000&mode=fillcropmid&key=AIzaSyDu_9QXeQFQ1Upxy3aGX3rqbTSt4Bs2Bqk";

@implementation FreeBaseManager

+ (FreeBaseManager *)sharedManager {
    static FreeBaseManager *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[FreeBaseManager alloc] init];
    });
    
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        //_tracker = [[GAI sharedInstance] defaultTracker];
    }
    return self;
}

#pragma mark - Test

- (NSURL *)requestFroImage:(NSString *)placeName {
    return nil;
    NSString *query = [NSString stringWithFormat:@"\"id\": null, \"name\": \"%@\",\"type\": \"/location/citytown\",\"/common/topic/image\": [{\"id\": null,\"optional\": true,\"limit\":1,\"image_caption\": []}]", placeName];
    
    NSString *requestString = [NSString stringWithFormat:FreeBaseApiPoint,query];
    
    NSData *data = [NSData dataWithContentsOfURL:
    [NSURL URLWithString:[requestString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSLog(@"%@", json);
    
    if ([json valueForKey:@"result"]) {
        NSArray *results = json[@"result"];
        if (results.count) {
            NSDictionary *result = results[0];
            NSArray *imagesResults = result[@"/common/topic/image"];
            if (imagesResults.count) {
                NSDictionary *imageResult = imagesResults[0];
                NSString *imageId = imageResult[@"id"];
                return [NSURL URLWithString:[NSString stringWithFormat:FreeBaseImages, imageId]];
            }
        }
    }
    return nil;
}

//{
//    "result": [{
//        "/common/topic/image": [{
//            "image_caption": [],
//            "id": "/m/02gdlr6"
//        }],
//        "name": "Kharkiv",
//        "id": "/en/kharkiv",
//        "type": "/location/citytown"
//    }]
//}


@end
