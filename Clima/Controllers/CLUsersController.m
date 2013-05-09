//
//  CLUsersController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/9/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLUsersController.h"

@interface CLUsersController ()

@end

@implementation CLUsersController

- (PFQuery *)queryForTable {

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"objectId" notEqualTo:[PFUser currentUser].objectId];
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

- (void)viewDidLoad
{
    self.parseClassName = @"_User";
    self.pullToRefreshEnabled = YES;
    self.paginationEnabled = YES;
    self.objectsPerPage = 25;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *user = [self objectAtIndexPath:indexPath];
    
    PFRelation *relation = [[PFUser currentUser] relationforKey:@"friends"];
    [relation addObject:user];
    
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error"
                                        message:@"Can't add"
                                       delegate:self
                              cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil] show];
            
        }
    }];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
