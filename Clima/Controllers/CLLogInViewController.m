//
//  CLLogInViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/6/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLLogInViewController.h"
#import "CLSignUpViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface CLLogInViewController () <PFLogInViewControllerDelegate>

@property (nonatomic, strong) UIImageView *fieldsBackground;

@end

@implementation CLLogInViewController

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
    self.navigationItem.title = NSLocalizedString(@"Sign In", @"Sign In");
    self.delegate = self;
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
    
    [self.logInView setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo_sign"]];
    [self.logInView setLogo:logoView];

    // Set labels appearance
    self.logInView.externalLogInLabel.textAlignment = NSTextAlignmentCenter;
    self.logInView.signUpLabel.textAlignment = NSTextAlignmentCenter;
    
    
    UIImage *loginBgImage = [[UIImage imageNamed:@"bt_login"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    UIImage *loginBgImage_ = [[UIImage imageNamed:@"bt_login_"] stretchableImageWithLeftCapWidth:5 topCapHeight:5];
    
    [self.logInView.signUpButton setBackgroundImage:loginBgImage
                                           forState:UIControlStateNormal];
    [self.logInView.signUpButton setBackgroundImage:loginBgImage_
                                           forState:UIControlStateHighlighted];
    [self.logInView.signUpButton setTitle:@"Sing Up"
                                 forState:UIControlStateNormal];
    [self.logInView.signUpButton setTitle:@"Sing Up"
                                 forState:UIControlStateHighlighted];

    // Set Fonts
    self.logInView.signUpButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                                                  size:18];

    // Add login field background
    _fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_textfield_signin"]];
    [self.logInView insertSubview:_fieldsBackground atIndex:1];

    // Remove text shadow
    CALayer *layer = self.logInView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.logInView.passwordField.layer;
    layer.shadowOpacity = 0.0;

    self.logInView.signUpLabel.shadowOffset = CGSizeZero;
    self.logInView.externalLogInLabel.shadowOffset = CGSizeZero;
    
    
    // Set field text color
    [self.logInView.usernameField setTextColor:UIColorFromRGB(0x000000)];
    [self.logInView.passwordField setTextColor:UIColorFromRGB(0x000000)];
    [self.logInView.externalLogInLabel setTextColor:UIColorFromRGB(0xa1a1a1)];
    [self.logInView.signUpLabel setTextColor:UIColorFromRGB(0xa1a1a1)];
    
    // Add custom action
    [self.logInView.signUpButton removeTarget:nil
                                       action:NULL
                             forControlEvents:UIControlEventAllEvents];
    [self.logInView.signUpButton addTarget:self
                                    action:@selector(displaySignUpView:)
                          forControlEvents:UIControlEventTouchDown];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // Set frame for elements
    [self.logInView.logo setFrame:CGRectMake(102.5f, 50.0f, 115.0f, 48.0f)];
    [self.logInView.facebookButton setFrame:CGRectMake(35.0f, 267.0f, 120.0f, 40.0f)];
    [self.logInView.twitterButton setFrame:CGRectMake(35.0f+130.0f, 267.0f, 120.0f, 40.0f)];
    [self.logInView.signUpButton setFrame:CGRectMake(35.0f, (hasFourInchDisplay ? 568.0 : 480) - 140, 250.0f, 40.0f)];
    
    [self.logInView.usernameField setFrame:CGRectMake(35.0f, 125.0f, 250.0f, 50.0f)];
    [self.logInView.passwordField setFrame:CGRectMake(35.0f, 175.0f, 250.0f, 50.0f)];
    [self.fieldsBackground setFrame:CGRectMake(35.0f, 125.0f, 250.0f, 100.0f)];
    
    [self.logInView.externalLogInLabel setFrame:CGRectMake(0, CGRectGetMinY(self.logInView.facebookButton.frame) - 20, 320, 21)];
    [self.logInView.signUpLabel setFrame:CGRectMake(0, CGRectGetMinY(self.logInView.signUpButton.frame) - 20, 320, 21)];
}


// Method for showing the sign up view via the nav controller instead of modally
- (void)displaySignUpView:(id)sender
{
    [self.navigationController pushViewController:self.signUpController
                                         animated:YES];
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Reveal

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

@end
