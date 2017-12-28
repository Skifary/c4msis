//
//  QRCodeDisplayViewController.h
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShadowsocksConfiguration.h"

@interface QRCodeDisplayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (nonatomic, strong) ShadowsocksConfiguration* configuration;

@end
