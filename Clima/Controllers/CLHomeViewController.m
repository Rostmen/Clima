//
//  CLHomeViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLHomeViewController.h"
#import "CLTermoView.h"

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
    
    [_termoView.tempLabel setHidden:YES];
    [_activityIndicator startAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(weatherDidChange:)
                                                 name:WeatherDidChangeNotification object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

@end
