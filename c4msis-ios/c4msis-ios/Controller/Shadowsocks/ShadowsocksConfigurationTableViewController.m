//
//  ShadowsocksConfigurationTableViewController.m
//  c4msis-ios
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ShadowsocksConfigurationTableViewController.h"

#import "Utility.h"

#import "QRCodeDisplayViewController.h"

#import "ProxyRuleTableViewController.h"

#import "MethodTableViewController.h"

#import "ConfigurationManager.h"

static NSString* kImageNameQRCode = @"sc_qrcode";

static NSString* kImageNameShowPassword = @"sc_show_password";

static NSString* kImageNameHidePassword = @"sc_hide_password";

static NSString* kDoneTitle = @"done";

static NSString* kDeleteAlertTitle = @"Delete";

static NSString* kDeleteAlertMessage = @"Delete this Configuration?";

@interface ShadowsocksConfigurationTableViewController ()

@property(assign, nonatomic) SCTVCType type;

@property (weak, nonatomic) IBOutlet UITextField *hostTextField;

@property (weak, nonatomic) IBOutlet UITextField *portTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UILabel *modeLabel;

@property (weak, nonatomic) IBOutlet UILabel *methodLabel;

@property (weak, nonatomic) IBOutlet UIButton *showPasswordButton;
@end

@implementation ShadowsocksConfigurationTableViewController

#pragma mark Property

- (ShadowsocksConfiguration *)configuration {
    if (!_configuration) {
        _configuration = [[ShadowsocksConfiguration alloc] init];
    }
    return _configuration;
}

- (void)setType:(SCTVCType)type {
    _type = type;
}

#pragma mark Publick API

- (void)updateMode:(ShadowsocksProxyRule)rule {
    
    self.modeLabel.text = [ShadowsocksConfiguration ruleStringFromRule:rule];
    self.configuration.rule = rule;
}

- (void)updateMethod:(ShadowsocksMethod)method {
    self.methodLabel.text = [ShadowsocksConfiguration methodStringFromMethod:method];
    self.configuration.method = method;
}

#pragma mark Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
}

- (void)setup {
    
    UIBarButtonItem* doneItem = [[UIBarButtonItem alloc] initWithTitle:kDoneTitle style:UIBarButtonItemStyleDone target:self action:@selector(doneAction:)];
    
    self.navigationItem.rightBarButtonItem = doneItem;
    doneItem.enabled = NO;
    if (self.type == SCTVCTypeModify) {
        [self addShowQRCodeButton];
        doneItem.enabled = YES;
    }

    self.hostTextField.text = self.configuration.host;
    self.portTextField.text = self.configuration.port;
    self.passwordTextField.text = self.configuration.password;
    [self updateMethod:self.configuration.method];
    [self updateMode:self.configuration.rule];
    self.showPasswordButton.imageEdgeInsets = UIEdgeInsetsMake(14.25, 10, 14.25, 10);
}

- (void)addShowQRCodeButton {
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    // show qrcdoe button size
    CGFloat len = 24.0f;

    button.frame = CGRectMake(kScreenWidth - len - 16, kScreenHeight - kNavigationAndStatusBarHeight - len - 16, len, len);
    [button setImage:[UIImage imageNamed:kImageNameQRCode] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showQRCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:button];
}

- (void)showQRCode:(id)sender {
    
    QRCodeDisplayViewController *qdvc = [[QRCodeDisplayViewController alloc] init];
    qdvc.configuration = self.configuration;
    [self presentViewController:qdvc animated:YES completion:nil];
}

- (void)doneAction:(id)sender {

    self.configuration.host = self.hostTextField.text;
    self.configuration.port = self.portTextField.text;
    self.configuration.password = self.passwordTextField.text;
    
    [[ConfigurationManager manager] addConfiguration:self.configuration];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
                                  

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.type == SCTVCTypeNew ? 1 : 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    
    return  view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self showProxyRuleSelectedView];
        } else if (indexPath.row == 4) {
            [self showMethodSeletedView];
        }
    } else {
        [UIAlertController showMessage:kDeleteAlertMessage withTitle:kDeleteAlertTitle andPresenter:self cancelStyle:UIAlertActionStyleCancel okStyle:UIAlertActionStyleDestructive cancelTitle:@"Cancel" okTitle:@"Delete" cancel:nil ok:^{
            [[ConfigurationManager manager] deleteConfiguration:self.configuration];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

- (void)showProxyRuleSelectedView {
    ProxyRuleTableViewController* sctvc = [self.storyboard instantiateViewControllerWithIdentifier:kPRTVCStoryBoardIndentifier];
    sctvc.prev = self;
    [self.navigationController pushViewController:sctvc animated:YES];
}

- (void)showMethodSeletedView {
    MethodTableViewController* mtvc = [self.storyboard instantiateViewControllerWithIdentifier:kMTVCStoryBoardIndentifier];
    mtvc.prev = self;
    [self.navigationController pushViewController:mtvc animated:YES];
}

#pragma mark - IBAction

- (IBAction)textFieldEditingChanged:(id)sender {
    
    if (self.hostTextField.text.length != 0 && self.portTextField.text.length != 0 && self.passwordTextField.text.length != 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
}

- (IBAction)showPasswordAction:(UIButton *)sender {
    
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    
    NSString* imageName = self.passwordTextField.secureTextEntry ? kImageNameShowPassword : kImageNameHidePassword;
    
    [sender setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}


@end
