//
//  BasicTableViewController.m
//  c4msis-ios
//
//  Created by Skifary on 24/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "BasicTableViewController.h"
#import "Color.h"

@interface BasicTableViewController ()

@end

@implementation BasicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = kUITbaleViewBackgroundColor;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

@end
