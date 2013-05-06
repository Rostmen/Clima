//
//  CLFriendsViewController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/6/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLFriendsViewController.h"
#import "CLLogInViewController.h"
#import "CLSignUpViewController.h"

@interface CLFriendsViewController ()

@end

@implementation CLFriendsViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    UIImage *revealImage = [UIImage imageNamed:@"ic_reveal"];
    
    if (self.navigationController.revealController.type & PKRevealControllerTypeLeft)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:revealImage
                                                                   landscapeImagePhone:nil
                                                                                 style:UIBarButtonItemStylePlain
                                                                                target:self
                                                                                action:@selector(showLeftView:)];
    }
    
    // Check if user is logged in
    if (![PFUser currentUser]) {
        // Instantiate our custom log in view controller
        CLLogInViewController *logInViewController = [[CLLogInViewController alloc] init];
        [logInViewController setFacebookPermissions:[NSArray arrayWithObjects:@"friends_about_me", nil]];
        [logInViewController setFields:PFLogInFieldsUsernameAndPassword
         | PFLogInFieldsTwitter
         | PFLogInFieldsFacebook
         | PFLogInFieldsSignUpButton];
        
        // Instantiate our custom sign up view controller
        CLSignUpViewController *signUpViewController = [[CLSignUpViewController alloc] init];
        [signUpViewController setFields:PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsEmail | PFSignUpFieldsSignUpButton];
        
        // Link the sign up view controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present log in view controller
        [self.navigationController pushViewController:logInViewController animated:animated];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
