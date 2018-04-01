//
//  AboutViewController.m
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "AboutViewController.h"

#import "APPInfo.h"

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.logoImageView.layer.cornerRadius = 10;
    self.logoImageView.clipsToBounds = YES;
    
    self.infoLabel.textAlignment = NSTextAlignmentCenter;
    self.infoLabel.text = [self info];
    
    self.copyrightLabel.textAlignment = NSTextAlignmentCenter;
    self.copyrightLabel.text = [self copyright];
}

- (NSString *)info {

    NSString* appName = [APPInfo name];
    NSString* appVersion = [APPInfo version];
    NSString* appBuild = [APPInfo build];
    
    return [NSString stringWithFormat:@"%@ V%@(%@)", appName, appVersion, appBuild];
}

- (NSString *)copyright {
    return @"Copyright © 2017-2018 Skifary. All rights reserved.";
}

@end
