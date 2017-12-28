//
//  UIAlertController+Message.h
//  c4msis-ios
//
//  Created by Skifary on 03/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Message)


/**
 show message

 @param message message
 @param title title
 @param presenter present view controller
 */
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andPresenter:(UIViewController *)presenter;


/**
 show mesaage

 @param message message
 @param title title
 @param presenter presenter
 @param cancelStyle cancelStyle
 @param okStyle okStyle
 @param cancelTitle cancelTitle
 @param okTitle okTitle
 @param cancel cancel
 @param ok ok
 */
+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andPresenter:(UIViewController *)presenter cancelStyle:(UIAlertActionStyle)cancelStyle okStyle:(UIAlertActionStyle)okStyle cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle cancel:(void (^)(void))cancel ok:(void (^)(void))ok;

@end
