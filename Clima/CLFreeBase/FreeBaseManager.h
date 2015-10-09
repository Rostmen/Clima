//
//  FreeBaseManager.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 4/20/14.
//  Copyright (c) 2014 Rost's company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FreeBaseManager : NSObject

+ (FreeBaseManager *)sharedManager;
- (NSURL *)requestFroImage:(NSString *)placeName;

@end
