//
//  CLHomeViewController.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLTermoView;

@interface CLHomeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet CLTermoView *termoView;
- (IBAction)changeTemperature:(UISlider *)sender;
- (IBAction)checkWeather:(UITapGestureRecognizer *)sender;

@end
