//
//  QRCodeDisplayViewController.m
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "QRCodeDisplayViewController.h"


@interface QRCodeDisplayViewController ()



@end

@implementation QRCodeDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.imageView.backgroundColor = [UIColor redColor];

    self.imageView.image = [self.configuration qrcodeImageWithSize:self.imageView.frame.size];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
