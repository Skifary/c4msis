//
//  HeaderView.m
//  c4msis-ios
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "HeaderView.h"

#import "RadorView.h"

#import "Color.h"

#import "Utility.h"

@implementation HeaderView

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat width = CGRectGetWidth(self.frame);
        CGFloat height = CGRectGetHeight(self.frame);
        CGFloat x = CGRectGetMidX(self.frame);
        CGFloat y = CGRectGetMidY(self.frame);
        CGFloat len = fminf(width, height)*0.4;
        _button.frame = CGRectMake(x-len/2, y-len/2, len, len);

    }
    return _button;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        CGFloat y = CGRectGetMaxY(self.button.frame) + 50;
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kScreenWidth, 20)];
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = [UIColor whiteColor];
        _contentLabel.font = [UIFont systemFontOfSize:14];
    }
    return _contentLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.radorView = [self backgroundView:frame];
        self.backgroundView = self.radorView;
        [self addSubview:self.button];
        [self addSubview:self.contentLabel];
        [self.radorView setRadorDiameter:self.button.frame.size.height];
    }
    
    return self;
}

- (RadorView *)backgroundView:(CGRect)frame {
    
    RadorView* view = [[RadorView alloc] initWithFrame:frame];
    
    view.backgroundColor = kSystemBlue;
    
    return view;
}

@end
