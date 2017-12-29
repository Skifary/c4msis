//
//  ScanView.m
//  c4msis-ios
//
//  Created by Skifary on 29/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ScanView.h"
#import "Utility.h"

#import <objc/runtime.h>

@interface ScanView()

@property (nonatomic, strong) CAShapeLayer* backgroundLayer;

@property (nonatomic, strong) CALayer* scanLayer;

@end

@implementation ScanView

- (void)setTransparencyLength:(CGFloat)transparencyLength {
    
    _transparencyLength = transparencyLength;

    [self addTransparencyLayer];
}

- (void)setCornerColor:(UIColor *)cornerColor {
    _cornerColor = cornerColor;
    [self addTransparencyLayer];
}

- (void)setLShapeWidth:(CGFloat)lShapeWidth {
    _lShapeWidth = lShapeWidth;
    
    [self addTransparencyLayer];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        _transparencyLength = kScreenWidth / 2;
        _lShapeWidth = 2.0;
        _cornerColor = [UIColor greenColor];
        [self addTransparencyLayer];
    }
    return self;
}

- (void)addTransparencyLayer {
    
    if (self.backgroundLayer) {
        [self.backgroundLayer removeFromSuperlayer];
        self.backgroundLayer = nil;
    }
    
    CGFloat screenWidth = kScreenWidth;
    CGFloat screenHeigth = kScreenHeight;
    CGFloat x = (screenWidth - self.transparencyLength)/2;
    CGFloat y = (screenHeigth - self.transparencyLength)/2;
    
    //中间镂空的矩形框
    CGRect transparencyRect = CGRectMake(x,y,self.transparencyLength, self.transparencyLength);
    
    //背景
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.frame cornerRadius:0];
    //镂空
    UIBezierPath *transparencyPath = [UIBezierPath bezierPathWithRoundedRect:transparencyRect cornerRadius:0];
    [path appendPath:transparencyPath];
    [path setUsesEvenOddFillRule:YES]; //???
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    fillLayer.path = path.CGPath;
    fillLayer.fillRule = kCAFillRuleEvenOdd;
    fillLayer.fillColor = [UIColor blackColor].CGColor;
    fillLayer.opacity = 0.5;
    
    [self addLShapeCorner:fillLayer withBasePoint:transparencyRect];
    
    [self startScanAnimation:fillLayer withRect:transparencyRect];
    self.backgroundLayer = fillLayer;
    [self.layer addSublayer:fillLayer];
}

- (void)addLShapeCorner:(CALayer *)layer withBasePoint:(CGRect)rect {
    UIBezierPath* lShapePath = [UIBezierPath bezierPath];
    
    CGFloat lengthOfLShape = 25.0f;

    // 左上角
    CGPoint basePoint = rect.origin;
    [lShapePath moveToPoint:CGPointMake(basePoint.x, basePoint.y + lengthOfLShape)];
    [lShapePath addLineToPoint:basePoint];
    [lShapePath addLineToPoint:CGPointMake(basePoint.x + lengthOfLShape, basePoint.y)];
    
    // 右上角
    basePoint.x += self.transparencyLength;
    [lShapePath moveToPoint:CGPointMake(basePoint.x - lengthOfLShape,  basePoint.y)];
    [lShapePath addLineToPoint:basePoint];
    [lShapePath addLineToPoint:CGPointMake(basePoint.x, basePoint.y + lengthOfLShape)];
    
    // 右下角
    basePoint.y += self.transparencyLength;
    [lShapePath moveToPoint:CGPointMake(basePoint.x - lengthOfLShape,  basePoint.y)];
    [lShapePath addLineToPoint:basePoint];
    [lShapePath addLineToPoint:CGPointMake(basePoint.x, basePoint.y - lengthOfLShape)];
    
    // 左下角
    basePoint.x -= self.transparencyLength;
    [lShapePath moveToPoint:CGPointMake(basePoint.x + lengthOfLShape,  basePoint.y)];
    [lShapePath addLineToPoint:basePoint];
    [lShapePath addLineToPoint:CGPointMake(basePoint.x, basePoint.y - lengthOfLShape)];

    CAShapeLayer *lShapleLayer = [CAShapeLayer layer];
    lShapleLayer.path = lShapePath.CGPath;
    lShapleLayer.lineWidth = self.lShapeWidth;
    lShapleLayer.strokeColor = self.cornerColor.CGColor;
    lShapleLayer.fillColor = [UIColor clearColor].CGColor;
    [layer addSublayer:lShapleLayer];
    
    // 边框
    CAShapeLayer* borderLayer = [CAShapeLayer layer];
    UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:0];
    borderLayer.path = borderPath.CGPath;
    borderLayer.strokeColor = [UIColor whiteColor].CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    [layer insertSublayer:borderLayer atIndex:0];

}

- (void)startScanAnimation:(CALayer *)layer withRect:(CGRect)rect {
    CALayer* scanLayer = [CALayer layer];
    
    scanLayer.frame = CGRectMake(CGRectGetMinX(rect) + 4.0f, CGRectGetMinY(rect), CGRectGetWidth(rect) - 8.0f, 3.0f);
    scanLayer.cornerRadius = 1.5f;
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.duration = 3.0f;
    
    positionAnima.fromValue = @(CGRectGetMinY(rect) + 5.0f);
    positionAnima.toValue = @(CGRectGetMaxY(rect));
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    positionAnima.repeatCount = HUGE;
    
    positionAnima.fillMode = kCAFillModeForwards;
    positionAnima.removedOnCompletion = NO;
    
    [scanLayer addAnimation:positionAnima forKey:@"AnimationMoveY"];
    
    scanLayer.backgroundColor = self.cornerColor.CGColor;
    self.scanLayer = scanLayer;
    [layer addSublayer:scanLayer];
}

- (void)removeScanAnimation {
 
    self.scanLayer.position = self.scanLayer.presentationLayer.position;
    [self.scanLayer removeAllAnimations];
}

@end
