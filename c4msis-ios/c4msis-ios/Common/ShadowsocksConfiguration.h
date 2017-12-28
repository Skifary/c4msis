//
//  ShadowsocksConfiguration.h
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Configuration.h"

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ShadowsocksProxyRuleAuto = 0,
    ShadowsocksProxyRuleGlobal,
} ShadowsocksProxyRule;

typedef enum : NSUInteger {
    ShadowsocksMethodAES256CFB = 0,
    ShadowsocksMethodAES192CFB,
    ShadowsocksMethodAES128CFB,
    ShadowsocksMethodCHACHA20,
    ShadowsocksMethodRC4MD5,
    ShadowsocksMethodSALSA20,
} ShadowsocksMethod;

@interface ShadowsocksConfiguration : Configuration

@property (nonatomic, copy) NSString* port;

@property (nonatomic, copy) NSString* password;

@property (nonatomic, assign) ShadowsocksProxyRule rule;

@property (nonatomic, assign) ShadowsocksMethod method;

@property (nonatomic, copy) NSString* remark;

+ (NSString *)ruleStringFromRule:(ShadowsocksProxyRule)rule;

+ (NSString *)methodStringFromMethod:(ShadowsocksMethod)method;

- (NSString *)methodString;

- (instancetype)initWithQRCodeValue:(NSString *)config;

- (void)setPropetyWithQRCodeValue:(NSString *)value;

- (UIImage *)qrcodeImageWithSize:(CGSize)size;

@end
