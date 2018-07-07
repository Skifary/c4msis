//
//  NewConfigurationTableViewController.m
//  c4msis-ios
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "NewConfigurationTableViewController.h"

#import "ScanQRCodeViewController.h"

#import "ShadowsocksConfigurationTableViewController.h"

#import "UIAlertController+Message.h"

@interface NewConfigurationTableViewController ()

@end

@implementation NewConfigurationTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)setup {
    
    self.title = @"Choose Mode";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self pushScanQRCodeViewcontroller];
            break;
        case 1:
            [self pushShadowsocksConfigurationTableViewController];
            break;
        default:
            break;
    }
}

- (void)pushScanQRCodeViewcontroller {
    if (![ScanQRCodeViewController hasCameraAuthority]) {
        [ScanQRCodeViewController requestAuthor:^(BOOL granted) {
            if (granted) {
                ScanQRCodeViewController* sqrcvc = [[ScanQRCodeViewController alloc] init];
                [self.navigationController pushViewController:sqrcvc animated:YES];
            }else {
                [UIAlertController showMessage:@"相机未授权，请去设置中授权" withTitle:@"授权失败" andPresenter:self];
            }
        }];
    } else {
        ScanQRCodeViewController* sqrcvc = [[ScanQRCodeViewController alloc] init];
        [self.navigationController pushViewController:sqrcvc animated:YES];
    }
}

- (void)pushShadowsocksConfigurationTableViewController {
    ShadowsocksConfigurationTableViewController* sctvc = [self.storyboard instantiateViewControllerWithIdentifier:kSCTVCStoryBoardIndentifier];
    [self.navigationController pushViewController:sctvc animated:YES];
}

@end
