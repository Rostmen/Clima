//
//  CLHomeViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLHomeViewController.h"
#import "CLTermoView.h"
#import "FreeBaseManager.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+ImageEffects.h"

@interface CLHomeViewController () <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation CLHomeViewController

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
    [self initLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_activityIndicator startAnimating];
    [_termoView.tempLabel setHidden:YES];
    [self update:^(NSError *error, CLWeather *weather) {
        [_activityIndicator stopAnimating];
        [_termoView.tempLabel setHidden:NO];
        if (!error) {
            [CLWeatherCenter playSound:@"CorkPop.mp3"];
            _termoView.temperature = weather.temp.floatValue - 273.15;
            _locationLabel.text = [NSString stringWithFormat:@"%@, %@", weather.city, weather.country];
            
            NSURL *url = [[FreeBaseManager sharedManager] requestFroImage:weather.city];
            NSLog(@"%@", url);
            
        }
    }];
}

- (void)weatherDidChange: (NSNotification *)noty {
    CLWeather *weather = [noty object];
    [_activityIndicator stopAnimating];
    [_termoView.tempLabel setHidden:NO];
    [CLWeatherCenter playSound:@"CorkPop.mp3"];
    _termoView.temperature = weather.temp.floatValue - 273.15;
    _locationLabel.text = [NSString stringWithFormat:@"%@, %@", weather.city, weather.country];
}

- (void)update:(CLWeatherFinish)finish {
    if (_lastLocation)
        [[CLWeatherCenter sharedService] updateByLocation:_lastLocation.coordinate finish:finish];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

/*
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
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTemperature:(UISlider *)sender {
    [_termoView setTemperature:sender.value];
}

- (IBAction)checkWeather:(UITapGestureRecognizer *)sender {
    [_activityIndicator startAnimating];
    [_termoView.tempLabel setHidden:YES];
    [self update:^(NSError *error, CLWeather *weather) {
        [_activityIndicator stopAnimating];
        [_termoView.tempLabel setHidden:NO];
        if (!error) {
            [CLWeatherCenter playSound:@"CorkPop.mp3"];
            _termoView.temperature = weather.temp.floatValue - 273.15;
            _locationLabel.text = [NSString stringWithFormat:@"%@, %@", weather.city, weather.country];
            
            NSURL *url = [[FreeBaseManager sharedManager] requestFroImage:weather.city];
            [_imageView setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                _imageView.image = [image applySubtleEffect];
            }];
            
        }
    }];
}

#pragma mark - Location Stack

- (BOOL)initLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.distanceFilter = 1500.0f;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    if ([CLLocationManager locationServicesEnabled]) {
        [_locationManager startUpdatingLocation];
        return YES;
    } else {
        NSLog(@"Location services is not enabled");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Warning", @"Warning")
                                                            message:NSLocalizedString(@"Location services is not enabled", @"Location services is not enabled")
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return NO;
    }
}

#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    CLLocation* location = [locations lastObject];
    NSLog(@"Updated: latitude %+.6f, longitude %+.6f\n",
          location.coordinate.latitude,
          location.coordinate.longitude);
    _lastLocation = location;
    [self checkWeather:nil];
}

- (IBAction)tweet:(id)sender {
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
//        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        [tweetSheet setInitialText:[@"High of " stringByAppendingString:_termoView.tempLabel.text]];
//        [self presentViewController:tweetSheet animated:YES completion:nil];
//    }
//    else
//    {
//        UIAlertView *alertView = [[UIAlertView alloc]
//                                  initWithTitle:@"Sorry"
//                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
//                                  delegate:self
//                                  cancelButtonTitle:@"OK"
//                                  otherButtonTitles:nil];
//        [alertView show];
//    }
}

- (IBAction)postFacebook:(id)sender {
//    SLComposeViewController *facebootPost;
//    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
//    {
//        SLComposeViewController *facebootPost = [[SLComposeViewController alloc] init]; //initiate the Social Controller
//        facebootPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
//        [facebootPost setInitialText:[@"High of " stringByAppendingString:_termoView.tempLabel.text]]; //the message you want to post
//
//        [self presentViewController:facebootPost animated:YES completion:nil];
//    } 
//    [facebootPost setCompletionHandler:^(SLComposeViewControllerResult result) {
//        NSString *output;
//        switch (result) {
//            case SLComposeViewControllerResultCancelled:
//                output = @"Action Cancelled";
//                break;
//            case SLComposeViewControllerResultDone:
//                output = @"Post Successfull";
//                break;
//            default:
//                break;
//        } //check if everythink worked properly. Give out a message on the state.
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        [alert show];
//    }];
}

@end
