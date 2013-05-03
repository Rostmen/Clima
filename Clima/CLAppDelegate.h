//
//  CLAppDelegate.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) PKRevealController *revealController;

- (NSURL *)applicationDocumentsDirectory;

@end
