//
//  CLMyProfileViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/11/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLMyProfileViewController.h"
#import <SDWebImage/SDImageCache.h>
#import <QuartzCore/QuartzCore.h>
#import "CLMyLocation.h"

@interface CLMyProfileViewController () <UITextFieldDelegate>

@end

@implementation CLMyProfileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    UIImage *revealImage = [UIImage imageNamed:@"ic_reveal"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 35, 35);
        [button setImage:revealImage forState:UIControlStateNormal];
        [button setImage:revealImage forState:UIControlStateHighlighted];
        [button addTarget:self
                   action:@selector(showLeftView:)
         forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
    }
    
    // UserView
    _userNameLabel.text = [[PFUser currentUser] username];
    PFFile *userImage = [[PFUser currentUser] objectForKey:@"userPic"];
    [_userImageView setImageWithURL:[NSURL URLWithString:userImage.url]];
    

    [_userImageView.layer setMasksToBounds:YES];
    [_userImageView.layer setCornerRadius:8.0f];

    [_userView.layer setShadowColor:[UIColor blackColor].CGColor];
    [_userView.layer setShadowOpacity:0.8];
    [_userView.layer setShadowRadius:3.0];
    [_userView.layer setShadowOffset:CGSizeMake(0.0, 2.0)];
    
    _statusLabel.text = [[PFUser currentUser]  objectForKey:@"status"];
    _userStatusTextField.text = [[PFUser currentUser]  objectForKey:@"status"];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // MapView
    CLLocation *userLocaion = [CLWeatherCenter service].lastLocation;
    CLWeather *userWeather = [CLWeatherCenter service].lastWeather;
    NSString *temperatureString = [NSString stringWithFormat:@"%.f°", userWeather.temp.floatValue - 273.15];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocaion.coordinate, Distance, Distance);
    
    [_mapView setRegion:viewRegion animated:animated];
    
    CLMyLocation *homeAnnotation = [[CLMyLocation alloc] initWithName:[userWeather.city stringByAppendingFormat:@", %@", userWeather.country]
                                                          temperature:temperatureString
                                                           coordinate:userLocaion.coordinate];
    
    [_mapView addAnnotation:homeAnnotation];
    [_mapView selectAnnotation:homeAnnotation animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLeftView:(id)sender
{
    if (self.navigationController.revealController.focusedController == self.navigationController.revealController.leftViewController)
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.frontViewController];
    }
    else
    {
        [self.navigationController.revealController showViewController:self.navigationController.revealController.leftViewController];
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MyLocation";
    if ([annotation isKindOfClass:[CLMyLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.image = [UIImage imageNamed:@"map_pin"];//here we use a nice image instead of the default pins
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (IBAction)tapOnStatusLabel:(id)sender {
    _userStatusTextField.hidden = NO;
    [_userStatusTextField becomeFirstResponder];
    _statusLabel.hidden = YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    _statusLabel.text = textField.text;
    [[PFUser currentUser] setObject:textField.text forKey:@"status"];
    _statusLabel.hidden = NO;
    textField.hidden = YES;
    [textField resignFirstResponder];
    return YES;
}
@end
