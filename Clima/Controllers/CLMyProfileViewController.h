//
//  CLMyProfileViewController.h
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/11/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLMyProfileViewController : UIViewController


@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *userStatusTextField;
@property (weak, nonatomic) IBOutlet UIView *userView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (IBAction)tapOnStatusLabel:(id)sender;

@end
