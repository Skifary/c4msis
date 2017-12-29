//
//  MainTableViewController.m
//  c4msis-ios
//
//  Created by Skifary on 18/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "MainTableViewController.h"

#import "Utility.h"

#include "HeaderView.h"

#import "Color.h"

#import "RadorView.h"

#import "ConfigurationsTableViewController.h"

#import "VPNManager.h"

#import "AboutViewController.h"


@interface MainTableViewController ()

@property(nonatomic, strong) HeaderView *headerView;

@end

static NSString* kImageNameConnected = @"main_connected";

static NSString* kImageNameDisconnected = @"main_disconnected";

static NSString* kConfigurationNotFoundMessage = @"No Configutaion";

static NSString* kConfigurationNotFoundTitle = @"Error";

@implementation MainTableViewController


#pragma mark - property



- (HeaderView *)headerView {
    
    if (!_headerView) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*3/5)];
        
        [_headerView.button setImage:[UIImage imageNamed:kImageNameConnected] forState:UIControlStateNormal];
        [_headerView.button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _headerView;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    VPNManager* manager = [VPNManager manager];
    
    [manager registerForStatusChange:^(VPNStatus status) {
        [self vpnStatusChangedHandle:status];
    }];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationBarTranslucent:self.navigationController.navigationBar];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self setNavigationBarOpacity:self.navigationController.navigationBar];
    
}

- (void)setup {

    self.tableView.contentInset = UIEdgeInsetsMake(-kNavigationAndStatusBarHeight,0,0,0);
    self.tableView.tableHeaderView = self.headerView;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
}

// 设置成 透明
- (void)setNavigationBarTranslucent:(UINavigationBar *)navigationBar {
    UIImage *translucentImage = [[UIImage alloc] init];
    [navigationBar setBackgroundImage:translucentImage forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = translucentImage;
}

// 恢复成默认状态
- (void)setNavigationBarOpacity:(UINavigationBar *)navigationBar {
    [navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    navigationBar.shadowImage = nil;
}
#pragma mark - action && status

- (void)buttonAction:(UIButton *)sender {
    VPNManager* manager = [VPNManager manager];
    if (manager.status == VPNStatusDisconnect) {
        [manager connect:^(NSError* error) {
            if (error) {
                NSLog(@"%@",error);
            }
            [UIAlertController showMessage:kConfigurationNotFoundMessage withTitle:kConfigurationNotFoundTitle andPresenter:self];
        }];
    } else if (manager.status == VPNStatusConnected) {
        [manager disconnect];
    }
}

- (void)vpnStatusChangedHandle:(VPNStatus)status {
    switch (status) {
        case VPNStatusConnecting:
            [self.headerView.radorView runAnimation:nil];
            self.headerView.button.enabled = NO;
            break;
        case VPNStatusDisconnecting:
            [self.headerView.radorView runAnimation:nil];
            self.headerView.button.enabled = NO;
            break;
        case VPNStatusConnected:
            [self.headerView.radorView stopAnimation];
            [self.headerView.button setImage:[UIImage imageNamed:kImageNameConnected] forState:UIControlStateNormal];
            self.headerView.button.enabled = YES;
            self.headerView.contentLabel.text = @"Connected";
            break;
        case VPNStatusDisconnect:
            [self.headerView.radorView stopAnimation];
            [self.headerView.button setImage:[UIImage imageNamed:kImageNameDisconnected] forState:UIControlStateNormal];
            self.headerView.button.enabled = YES;
            self.headerView.contentLabel.text = @"Disconnect";
            break;
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        // configurations
        ConfigurationsTableViewController* ctvc = [[ConfigurationsTableViewController alloc] init];
        [self.navigationController pushViewController:ctvc animated:YES];
    } else {
        // about
        AboutViewController* avc = [[AboutViewController alloc] init];
        [self.navigationController pushViewController:avc animated:YES];
    }
    
}



@end
