//
//  ProxyRuleTableViewController.m
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ProxyRuleTableViewController.h"

#import "StaticRadioTableViewCell.h"


@interface ProxyRuleTableViewController ()

@end


@implementation ProxyRuleTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSUInteger i = 0; i < self.tableView.visibleCells.count; i++) {
        
        StaticRadioTableViewCell* cell = self.tableView.visibleCells[i];
        cell.checkedImageView.hidden =  !(i == self.prev.configuration.rule);
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.prev updateMode:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
