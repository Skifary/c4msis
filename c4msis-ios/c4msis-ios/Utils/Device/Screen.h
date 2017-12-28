//
//  Screen.h
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#ifndef Screen_h
#define Screen_h


#pragma mark - screen size

#define kScreenWidth                        CGRectGetWidth([UIScreen mainScreen].bounds)

#define kScreenHeight                       CGRectGetHeight([UIScreen mainScreen].bounds)

#define kScreenFrame                        [UIScreen mainScreen].bounds

#define kScreenFrameUnderNavigation         CGRectMake(0, kNavigationAndStatusBarHeight, kScreenWidth, kScreenHeight)


#pragma mark - screen defualt value

#define kNavigationAndStatusBarHeight       64.0f

#endif /* Screen_h */
