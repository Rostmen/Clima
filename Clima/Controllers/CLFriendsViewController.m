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
#import "CLUsersController.h"

@interface CLFriendsViewController ()

@end

@implementation CLFriendsViewController

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (PFQuery *)queryForTable {
    PFRelation *ralation = [[PFUser currentUser] relationforKey:@"friends"];
    PFQuery *query = [ralation query];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    [query orderByDescending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object
{
    static NSString *cellIdentifier = @"Cell";
    
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"username"];

    
    return cell;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadObjects];
}

- (void)viewDidLoad
{
    self.parseClassName = @"_User";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
    
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
        
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:button], self.navigationItem.leftBarButtonItem];
        
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    
    [self checkForUser];
}

- (void)checkForUser {
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
        [self.navigationController pushViewController:logInViewController animated:YES];
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

- (IBAction)logOut:(id)sender {
    [PFUser logOut];
    [self checkForUser];
}

@end
