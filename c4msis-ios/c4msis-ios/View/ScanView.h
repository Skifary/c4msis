//
//  ScanView.h
//  c4msis-ios
//
//  Created by Skifary on 29/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanView : UIView


// default is half of screen width
@property (nonatomic, assign) CGFloat transparencyLength;

// default is green
@property (nonatomic, strong) UIColor* cornerColor;

// default is 2
@property (nonatomic, assign) CGFloat lShapeWidth;

- (void)removeScanAnimation;

@end
