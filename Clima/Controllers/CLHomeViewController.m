//
//  CLHomeViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLHomeViewController.h"
#import "CLTermoView.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface CLHomeViewController ()

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

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_activityIndicator startAnimating];
    [_termoView.tempLabel setHidden:YES];
    [[CLWeatherCenter service] update:^(NSError *error, CLWeather *weather) {
        [_activityIndicator stopAnimating];
        [_termoView.tempLabel setHidden:NO];
        if (!error) {
            [CLWeatherCenter playSound:@"CorkPop.mp3"];
            _termoView.temperature = weather.temp.floatValue - 273.15;
            _locationLabel.text = [NSString stringWithFormat:@"%@, %@", weather.city, weather.country];
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

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
    [[CLWeatherCenter service] update:^(NSError *error, CLWeather *weather) {
        [_activityIndicator stopAnimating];
        [_termoView.tempLabel setHidden:NO];
        if (!error) {
            [CLWeatherCenter playSound:@"CorkPop.mp3"];
            _termoView.temperature = weather.temp.floatValue - 273.15;
            _locationLabel.text = [NSString stringWithFormat:@"%@, %@", weather.city, weather.country];
        }
    }];
}

- (IBAction)tweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:[@"High of " stringByAppendingString:_termoView.tempLabel.text]];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (IBAction)postFacebook:(id)sender {
    SLComposeViewController *facebootPost;
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        SLComposeViewController *facebootPost = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        facebootPost = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [facebootPost setInitialText:[@"High of " stringByAppendingString:_termoView.tempLabel.text]]; //the message you want to post

        [self presentViewController:facebootPost animated:YES completion:nil];
    } 
    [facebootPost setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everythink worked properly. Give out a message on the state.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
}

@end
