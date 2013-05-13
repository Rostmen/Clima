//
//  CLSearchViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/4/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLSearchViewController.h"
#import "CLWeatherCenter.h"
#import "CLMyLocation.h"
#import <QuartzCore/QuartzCore.h>

@interface CLSearchViewController ()

@property (nonatomic, strong) CLMyLocation *lastAnnotation;

@end

@implementation CLSearchViewController

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
    [_revealButton setImage:revealImage forState:UIControlStateNormal];
    _revealButton.imageView.contentMode = UIViewContentModeCenter;
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImage
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView:)];
    }
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 0, 15, 15);
    
    UIImage *searchIcon = [UIImage imageNamed:@"ic_search"];
    [searchButton setImage:searchIcon forState:UIControlStateNormal];
    
    [searchButton addTarget:self
                     action:@selector(goSearch:)
           forControlEvents:UIControlEventTouchDown];
    
    _searchField.rightView = searchButton;
    _searchField.rightViewMode = UITextFieldViewModeAlways;
    
    _navBarView.layer.shadowColor = [UIColor blackColor].CGColor;
    _navBarView.layer.shadowRadius = 4.0f;
    _navBarView.layer.shadowOpacity = 0.8f;
    _navBarView.layer.shadowOffset = CGSizeMake(0, 1);
}

- (IBAction)showLeftView:(id)sender
{
    if (self.revealController.focusedController == self.revealController.leftViewController)
    {
        [self.revealController showViewController:self.revealController.frontViewController];
    }
    else
    {
        [self.revealController showViewController:self.revealController.leftViewController];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CLLocation *userLocaion = [CLWeatherCenter service].lastLocation;
    CLWeather *userWeather = [CLWeatherCenter service].lastWeather;
    
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(userLocaion.coordinate, Distance, Distance);
    
    [_mapView setRegion:viewRegion animated:animated];
    
    _temperatureLabel.text =[NSString stringWithFormat:@"%.f°", userWeather.temp.floatValue - 273.15];
    _lastAnnotation = [[CLMyLocation alloc] initWithName:[userWeather.city stringByAppendingFormat:@", %@", userWeather.country]
                                             temperature:_temperatureLabel.text
                                              coordinate:userLocaion.coordinate];

    [_mapView addAnnotation:_lastAnnotation];
    [_mapView selectAnnotation:_lastAnnotation animated:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goSearch:(id)sender {
    [_searchField resignFirstResponder];
    if (_searchField.text.length) {
        [[CLWeatherCenter service] searchWeather:_searchField.text success:^(CLWeather *weather) {
            _temperatureLabel.text = [NSString stringWithFormat:@"%.f°", weather.temp.floatValue - 273.15];
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = weather.lat.floatValue;
            coordinate.longitude = weather.lon.floatValue;
            
            MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coordinate, Distance, Distance);
            
            [_mapView setRegion:viewRegion animated:YES];
            
            if (_lastAnnotation)
                [_mapView removeAnnotation:_lastAnnotation];
            
            _lastAnnotation = [[CLMyLocation alloc] initWithName:[weather.city stringByAppendingFormat:@", %@", weather.country]
                                                     temperature:_temperatureLabel.text
                                                      coordinate:coordinate];
            
            [_mapView addAnnotation:_lastAnnotation];
            [_mapView selectAnnotation:_lastAnnotation animated:YES];
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self goSearch:nil];
    return YES;
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

@end
