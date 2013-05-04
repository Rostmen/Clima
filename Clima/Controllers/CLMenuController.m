//
//  CLMenuController.m
//  Clima
//
//  Created by Rostislav Kobizskiy on 5/3/13.
//  Copyright (c) 2013 Rost's company. All rights reserved.
//

#import "CLMenuController.h"
#import "CLMenuCell.h"
#import "CLAppDelegate.h"

NSString *const MenuCellIdentifier = @"MenuCellIdentifier";

@interface CLMenuController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation CLMenuController

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
    
    self.view.backgroundColor = UIColorFromRGB(0x353533);
    self.tableView.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:MenuCellIdentifier
                                                       forIndexPath:indexPath];
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = NSLocalizedString(@"You", @"You");
            cell.iconView.image = [UIImage imageNamed:@"ic_menu_home"];
            break;
        case 1:
            cell.titleLabel.text = NSLocalizedString(@"History", @"History");
            cell.iconView.image = [UIImage imageNamed:@"ic_menu_history"];
            break;
        case 2:
            cell.titleLabel.text = NSLocalizedString(@"Search", @"Search");
            cell.iconView.image = [UIImage imageNamed:@"ic_menu_globe"];
            break;
        case 3:
            cell.titleLabel.text = NSLocalizedString(@"Friends", @"Friends");
            cell.iconView.image = [UIImage imageNamed:@"ic_menu_friends"];
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            [self performSegueWithIdentifier:@"goHome" sender:self];
            break;
        case 1:

            break;
        case 2:
            [self performSegueWithIdentifier:@"goSearch" sender:self];
            break;
        case 3:

            break;
        default:
            break;
    }
}

@end
