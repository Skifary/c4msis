//
//  StaticRadioTableViewCell.m
//  c4msis-ios
//
//  Created by Skifary on 24/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "StaticRadioTableViewCell.h"

@implementation StaticRadioTableViewCell

- (UIImageView *)checkedImageView {
    for (UIImageView* view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            return view;
        }
    }
    return nil;
}

@end
