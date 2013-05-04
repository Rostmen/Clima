//
//  CLSearchViewController.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/4/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface CLSearchViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *revealButton;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UITextField *searchField;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)showLeftView:(id)sender;

@end
