//
//  CLRevealSegue.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/4/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLRevealSegue.h"
#import "CLAppDelegate.h"

@implementation CLRevealSegue

- (void)perform {
    CLAppDelegate *delegate = [UIApplication sharedApplication].delegate;
    __weak PKRevealController *reveal = (PKRevealController *)[delegate.window rootViewController];
    
    [reveal setFrontViewController:self.destinationViewController
                  focusAfterChange:YES
                        completion:^(BOOL finished){
                            [reveal showViewController:self.destinationViewController];
    }];
}

@end
