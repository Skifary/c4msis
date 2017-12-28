//
//  UIAlertController+Message.m
//  c4msis-ios
//
//  Created by Skifary on 03/12/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "UIAlertController+Message.h"

@implementation UIAlertController (Message)

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andPresenter:(UIViewController *)presenter {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:action];
    [presenter presentViewController:alert animated:YES completion:nil];
}

+ (void)showMessage:(NSString *)message withTitle:(NSString *)title andPresenter:(UIViewController *)presenter cancelStyle:(UIAlertActionStyle)cancelStyle okStyle:(UIAlertActionStyle)okStyle cancelTitle:(NSString *)cancelTitle okTitle:(NSString *)okTitle cancel:(void (^)(void))cancel ok:(void (^)(void))ok {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:cancelStyle handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel();
        }
    }];
    [alert addAction:cancelAction];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:okTitle style:okStyle handler:^(UIAlertAction * _Nonnull action) {
        if (ok) {
            ok();
        }
    }];
    [alert addAction:okAction];
    [presenter presentViewController:alert animated:YES completion:nil];
}

@end
