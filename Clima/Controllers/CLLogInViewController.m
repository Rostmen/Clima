//
//  CLLogInViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/6/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLLogInViewController.h"
#import "CLSignUpViewController.h"

@interface CLLogInViewController () <PFLogInViewControllerDelegate>

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
    UIImage *revealImage = [UIImage imageNamed:@"ic_reveal"];
    
    self.navigationItem.title = NSLocalizedString(@"Sign In", @"Sign In");
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImage
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView:)];
    }
    
//    [self.logInView setBackgroundColor:UIColorFromRGB(0xf6f6f6)];
//    [self.logInView setLogo:nil];
//    
//    // Set buttons appearance
//    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
//    [self.logInView.dismissButton setImage:[UIImage imageNamed:@"exit_down.png"] forState:UIControlStateHighlighted];
    
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateNormal];
//    [self.logInView.facebookButton setImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook_down.png"] forState:UIControlStateHighlighted];
//    [self.logInView.facebookButton setBackgroundImage:[UIImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
//    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateNormal];
//    [self.logInView.facebookButton setTitle:@"" forState:UIControlStateHighlighted];
//    
//    [self.logInView.twitterButton setImage:nil forState:UIControlStateNormal];
//    [self.logInView.twitterButton setImage:nil forState:UIControlStateHighlighted];
//    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter.png"] forState:UIControlStateNormal];
//    [self.logInView.twitterButton setBackgroundImage:[UIImage imageNamed:@"twitter_down.png"] forState:UIControlStateHighlighted];
//    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateNormal];
//    [self.logInView.twitterButton setTitle:@"" forState:UIControlStateHighlighted];
    
//    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup.png"] forState:UIControlStateNormal];
//    [self.logInView.signUpButton setBackgroundImage:[UIImage imageNamed:@"signup_down.png"] forState:UIControlStateHighlighted];
//    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateNormal];
//    [self.logInView.signUpButton setTitle:@"" forState:UIControlStateHighlighted];
    
    // Add login field background
//    fieldsBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background.png"]];
//    [self.logInView insertSubview:fieldsBackground atIndex:1];
//    
//    // Remove text shadow
//    CALayer *layer = self.logInView.usernameField.layer;
//    layer.shadowOpacity = 0.0;
//    layer = self.logInView.passwordField.layer;
//    layer.shadowOpacity = 0.0;
//    
//    // Set field text color
//    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
//    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:9
    
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
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:nil];
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
