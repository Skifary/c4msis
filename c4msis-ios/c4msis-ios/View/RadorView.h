//
//  RadorView.h
//  c4msis-ios
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadorView : UIView

/**
 开始动画

 @param complete 动画结束回调
 */
- (void)runAnimation:(nullable void (^)(void))complete;


/**
 停止动画
 */
- (void)stopAnimation;

/**
 设置直径

 @param diameter diameter
 */
- (void)setRadorDiameter:(CGFloat)diameter;

@end
