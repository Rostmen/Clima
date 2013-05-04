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
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImage
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView:)];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[CLWeatherCenter service] update];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherChanged:) name:WeatherDidChangeNotification object:nil];
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
    [[CLWeatherCenter service] update];
}

- (void)weatherChanged:(NSNotification *)notification {
    CLWeather *weather = (CLWeather *)notification.object;
    [CLWeatherCenter playSound:@"Sonar.m4r"];
    _termoView.temperature = weather.temp.floatValue - 273.15;
    _locationLabel.text = [NSString stringWithFormat:@"%@, %@", weather.city, weather.country];
}

@end
