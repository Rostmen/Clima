//
//  CLSignUpViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/6/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLSignUpViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CLSignUpViewController () <PFSignUpViewControllerDelegate>

@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation CLSignUpViewController

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
    
    self.navigationItem.title = NSLocalizedString(@"Sign Up", @"Sign Up");
    
    UIImage *revealImage = [UIImage imageNamed:@"ic_back"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 35, 35);
        [button setImage:revealImage forState:UIControlStateNormal];
        [button setImage:revealImage forState:UIControlStateHighlighted];
        [button addTarget:self
                   action:@selector(back:)
         forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }
    
    [self.signUpView setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo_sign"]];
    [self.signUpView setLogo:logoView];
    
    
    UIImage *loginBgImage = [[UIImage imageNamed:@"bt_login"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *loginBgImage_ = [[UIImage imageNamed:@"bt_login_"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [self.signUpView.signUpButton setBackgroundImage:loginBgImage
                                           forState:UIControlStateNormal];
    [self.signUpView.signUpButton setBackgroundImage:loginBgImage_
                                           forState:UIControlStateHighlighted];
    [self.signUpView.signUpButton setTitle:@"Sing Up"
                                 forState:UIControlStateNormal];
    [self.signUpView.signUpButton setTitle:@"Sing Up"
                                 forState:UIControlStateHighlighted];
    
    // Set Fonts
    self.signUpView.signUpButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                                  size:18];
    
    [self.signUpView.usernameField setTextColor:UIColorFromRGB(0x000000)];
    [self.signUpView.passwordField setTextColor:UIColorFromRGB(0x000000)];
    [self.signUpView.emailField setTextColor:UIColorFromRGB(0x000000)];
    
    // Add login field background
    _fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_textfield_signup"]];
    [self.signUpView insertSubview:_fieldsBackground atIndex:1];
    
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.signUpView.emailField.layer;
    layer.shadowOpacity = 0.0;
}

- (void)back: (id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.signUpView.logo setFrame:CGRectMake(102.5f, 50.0f, 115.0f, 48.0f)];

    [self.signUpView.signUpButton setFrame:CGRectMake(35.0f, (hasFourInchDisplay ? 568.0 : 480) - 140, 250.0f, 40.0f)];
    
    [self.signUpView.usernameField setFrame:CGRectMake(35.0f, 125.0f, 250.0f, 50.0f)];
    [self.signUpView.passwordField setFrame:CGRectMake(35.0f, 175.0f, 250.0f, 50.0f)];
    [self.signUpView.emailField setFrame:CGRectMake(35.0f, 225.0f, 250.0f, 50.0f)];
    
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 125.0f, 250.0f, 150.0f)];

}

@end
