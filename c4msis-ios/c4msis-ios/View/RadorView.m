//
//  RadorView.m
//  c4msis-ios
//
//  Created by Skifary on 19/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "RadorView.h"

@interface RadorView()<CAAnimationDelegate>

@property(nonatomic, strong) CALayer* animationLayer;

@property(nonatomic, copy) void (^animationCompleteBlock)(void);

@property(nonatomic, assign) CGFloat diameter;

@end

@implementation RadorView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        CGFloat width = CGRectGetWidth(frame);
        CGFloat height = CGRectGetHeight(frame);
        self.diameter = width > height ? height / 2 : width / 2;
    }
    return self;
}

- (void)setRadorDiameter:(CGFloat)diameter {
    self.diameter = diameter;
}

- (void)runAnimation:(void (^)(void))complete {
    
    if (self.animationLayer) {
        return;
    }

    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGRect rect = width > height ? CGRectMake((width - height)/2, 0, height, height) : CGRectMake(0, (height-width)/2, width, width);

    NSInteger pulsingCount = 1;
    double animationDuration = 3;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = rect;
        pulsingLayer.borderColor = [UIColor whiteColor].CGColor;
        pulsingLayer.borderWidth = 1;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = INT_MAX;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @(self.diameter/rect.size.height);
        scaleAnimation.toValue = @1.0;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.9, @0.8, @0.7, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        
        animationGroup.delegate = self;
        
        // 解决闪一下的问题
        animationGroup.removedOnCompletion = NO;
        animationGroup.fillMode = kCAFillModeForwards;
        
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    
    [self.layer addSublayer:animationLayer];
    
    self.animationLayer = animationLayer;
    self.animationCompleteBlock = complete;
}

- (void)stopAnimation {
    if (self.animationLayer) {
        [self.animationLayer removeAllAnimations];
        [self.animationLayer removeFromSuperlayer];
        self.animationLayer = nil;
        if (self.animationCompleteBlock) {
            self.animationCompleteBlock();
            self.animationCompleteBlock = nil;
        }
    }
}

#pragma mark - CAAnimationDelegate

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {

    [self stopAnimation];
//    if (self.animationLayer) {
//        [self.animationLayer removeFromSuperlayer];
//        self.animationLayer = nil;
//        if (self.animationCompleteBlock) {
//            self.animationCompleteBlock();
//            self.animationCompleteBlock = nil;
//        }
//    }
}

@end
