//
//  MethodTableViewController.m
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "MethodTableViewController.h"
#import "StaticRadioTableViewCell.h"

@interface MethodTableViewController ()

@end

@implementation MethodTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSUInteger i = 0; i < self.tableView.visibleCells.count; i++) {
        
        StaticRadioTableViewCell* cell = self.tableView.visibleCells[i];
        
        cell.checkedImageView.hidden =  !(i == self.prev.configuration.method);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    [self.prev updateMethod:indexPath.row];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
