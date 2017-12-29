//
//  ConfigurationsTableViewController.m
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ConfigurationsTableViewController.h"
#import "ConfigurationManager.h"

#import "ConfigurationTableViewCell.h"

#import "NewConfigurationTableViewController.h"

#import "ShadowsocksConfigurationTableViewController.h"

@interface ConfigurationsTableViewController ()

@property (nonatomic, weak, readonly) ConfigurationManager* configurationManager;

@end


static NSString* kConfigurationCellIdentifier = @"ConfigurationCellIdentifier";

@implementation ConfigurationsTableViewController

- (ConfigurationManager *)configurationManager {
    return [ConfigurationManager manager];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    [self setup];
}

- (void)setup {

    [self.tableView registerNib:[UINib nibWithNibName:@"ConfigurationTableViewCell" bundle:nil] forCellReuseIdentifier:kConfigurationCellIdentifier];
    
    [self.configurationManager registerForNotifacationWhenConfigurationsChanged:^{
        [self.tableView reloadData];
    }];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.configurationManager.configurations.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ConfigurationTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kConfigurationCellIdentifier forIndexPath:indexPath];
   
    if (indexPath.row == self.configurationManager.configurations.count) {
        cell.checkedImageView.hidden = YES;
        cell.configurationNameLabel.text = @"Add New Configuration";
        cell.configurationNameLabel.textAlignment = NSTextAlignmentCenter;
        cell.detailButton.hidden = YES;
    } else {
        cell.checkedImageView.hidden = !(indexPath.row == self.configurationManager.currentConfigurationIndex);
        Configuration* configuration = self.configurationManager.configurations[indexPath.row];
        cell.configurationNameLabel.text = configuration.host;
        [cell.detailButton addTarget:self action:@selector(detailAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.detailButton.tag = indexPath.row;
    }
    return cell;
}

- (void)detailAction:(UIButton *)sender {
    
    ShadowsocksConfigurationTableViewController* sctvc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:kSCTVCStoryBoardIndentifier];
    
    [sctvc setType: SCTVCTypeModify];
    sctvc.configuration = (ShadowsocksConfiguration *)self.configurationManager.configurations[sender.tag];
    [self.navigationController pushViewController:sctvc animated:YES];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.row == self.configurationManager.configurations.count) {
        NewConfigurationTableViewController* nctvc = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:kNCTVCStoryBoardIndentifier];
        [self.navigationController pushViewController:nctvc animated:YES];
    } else {
        self.configurationManager.currentConfigurationIndex = indexPath.row;
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

@end
