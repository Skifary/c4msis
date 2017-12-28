//
//  ScanQRCodeViewController.h
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanQRCodeViewController : UIViewController

// 扫描区域占横屏的比例 0~1,default is 0.75
@property(nonatomic, assign) CGFloat scaleOfInterest;

@end
