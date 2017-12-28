//
//  ShadowsocksConfiguration.m
//  c4msis-ios
//
//  Created by Skifary on 21/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ShadowsocksConfiguration.h"


#import "Utility.h"

#import "QRCoder.h"

static NSString* kShadowsocksConfigurationCoderKeyPort = @"ShadowsocksConfigurationCoderKeyPort";

static NSString* kShadowsocksConfigurationCoderKeyPassword = @"ShadowsocksConfigurationCoderKeyPassword";

static NSString* kShadowsocksConfigurationCoderKeyRule = @"ShadowsocksConfigurationCoderKeyRule";

static NSString* kShadowsocksConfigurationCoderKeyMethod = @"ShadowsocksConfigurationCoderKeyMethod";

static NSString* kShadowsocksConfigurationCoderKeyRemark = @"ShadowsocksConfigurationCoderKeyRemark";

@implementation ShadowsocksConfiguration

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.host = nil;
        self.port = nil;
        self.password = nil;
        self.remark = nil;
        self.rule = ShadowsocksProxyRuleAuto;
        self.method = ShadowsocksMethodAES256CFB;
        self.type = ConfigurationTypeShadowsocks;
    }
    
    return self;
}

- (instancetype)initWithQRCodeValue:(NSString *)value {
    self = [self init];
    if (self) {
        [self setPropetyWithQRCodeValue:value];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:self.port forKey:kShadowsocksConfigurationCoderKeyPort];
    [aCoder encodeObject:self.password forKey:kShadowsocksConfigurationCoderKeyPassword];
    [aCoder encodeInteger:self.rule forKey:kShadowsocksConfigurationCoderKeyRule];
    [aCoder encodeInteger:self.method forKey:kShadowsocksConfigurationCoderKeyMethod];
    [aCoder encodeObject:self.remark forKey:kShadowsocksConfigurationCoderKeyRemark];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    self  = [super initWithCoder:aDecoder];
    
    if (self) {
   
        self.port = [aDecoder decodeObjectForKey:kShadowsocksConfigurationCoderKeyPort];
        self.password = [aDecoder decodeObjectForKey:kShadowsocksConfigurationCoderKeyPassword];
        self.rule = [aDecoder decodeIntegerForKey:kShadowsocksConfigurationCoderKeyRule];
        self.method = [aDecoder decodeIntegerForKey:kShadowsocksConfigurationCoderKeyMethod];
        
        self.remark = [aDecoder decodeObjectForKey:kShadowsocksConfigurationCoderKeyRemark];
    }
    
    return self;
}

#pragma mark Publick API

+ (NSString *)ruleStringFromRule:(ShadowsocksProxyRule)rule {
    switch (rule) {
        case ShadowsocksProxyRuleAuto:
            return @"Auto Mode";
        case ShadowsocksProxyRuleGlobal:
            return @"Globol Mode";
        default:
            break;
    }
    return nil;
}

+ (NSString *)methodStringFromMethod:(ShadowsocksMethod)method {
    switch (method) {
        case ShadowsocksMethodAES256CFB:
            return @"AES-256-CFB";
        case ShadowsocksMethodAES192CFB:
            return @"AES-192-CFB";
        case ShadowsocksMethodAES128CFB:
            return @"AES-128-CFB";
        case ShadowsocksMethodCHACHA20:
            return @"CHACHA20";
        case ShadowsocksMethodRC4MD5:
            return @"RC4-MD5";
        case ShadowsocksMethodSALSA20:
            return @"SALSA20";
        default:
            break;
    }
    return nil;
}

- (NSString *)methodString {
    return [ShadowsocksConfiguration methodStringFromMethod:self.method];
}

- (ShadowsocksMethod)methodFromStringMethod:(NSString*)stringMethod {
    static NSDictionary* methods = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        methods = @{
                    @"AES-256-CFB" : @0,
                    @"AES-192-CFB" : @1,
                    @"AES-128-CFB" : @2,
                    @"CHACHA20" : @3,
                    @"RC4-MD5" : @4,
                    @"SALSA20" : @5
                    };
    });
    return [methods[stringMethod] integerValue];
}

- (void)setPropetyWithQRCodeValue:(NSString *)value {

    NSString* base64Value = [value substringFromIndex:5];
    
    // 添加某些未带==的（URL Safe Base64）
    // 例如 ss://YWVzLTI1Ni1jZmI6c0p1aG1IOGhQdUAxNzIuOTMuNDIuMTQ5OjQ0Mw
    if (base64Value.length % 4) {
        NSUInteger paddingLength = base64Value.length + (4 - base64Value.length % 4);
        base64Value = [base64Value stringByPaddingToLength:paddingLength withString:@"=" startingAtIndex:0];
    }
    
    // 除去某些结尾带名字的
    // 例如 ss://YWVzLTI1Ni1jZmI6c0p1aG1IOGhQdUAxNzIuOTMuNDIuMTQ5OjQ0Mw==#123
    while (![[base64Value substringFromIndex:base64Value.length - 1] isEqualToString:@"="]) {
        base64Value = [base64Value substringToIndex:base64Value.length - 1];
    }
    
    NSString* config = [NSString decodeBase64String:base64Value];
    //aes-256-cfb:sJuhmH8hPu@172.93.42.149:443?Remark=banwagong&OTA=false
    unichar separators[4] = {':','@','?','&'};
    size_t startIndex = 0;
    int index = 0;
    NSUInteger indexOfAT = 0;
    for (size_t i = 0; i < config.length; i++) {
        unichar ch = [config characterAtIndex:i];
        if (ch == *(separators + index)) {
            switch (*(separators + index)) {
                case ':': {
                    NSString* methodStr = [config substringWithRange:NSMakeRange(startIndex, i - startIndex)];
                    self.method = [self methodFromStringMethod:methodStr];
                }
                    break;
                case '@':
                    self.password = [config substringWithRange:NSMakeRange(startIndex, i - startIndex)];
                    indexOfAT = i;
                    break;
                case '?': {
                    NSString* hostAndPort = [config substringWithRange:NSMakeRange(startIndex, i - startIndex)];
                    NSArray* array = [hostAndPort componentsSeparatedByString:@":"];
                    self.host = array[0];
                    self.port = array[1];
                }
                    break;
                case '&':
                    self.remark = [config substringWithRange:NSMakeRange(startIndex + 7, i - startIndex)];
                    break;
                default:
                    break;
            }
            startIndex = i + 1;
            index++;
        }
    }
    // 解决标准SS格式
    if (!self.host || !self.port) {
        NSString* hostAndPort = [config substringFromIndex:indexOfAT + 1];
        NSArray* array = [hostAndPort componentsSeparatedByString:@":"];
        self.host = array[0];
        self.port = array[1];
    }
}

- (UIImage *)qrcodeImageWithSize:(CGSize)size {
    
    NSString* config = [NSString stringWithFormat:@"%@:%@@%@:%@?%@",[ShadowsocksConfiguration methodStringFromMethod:self.method],self.password,self.host,self.port,self.remark];
    NSString* value = [NSString stringWithFormat:@"ss://%@",[NSString encodeStringToBase64:config]];
    
    return [QRCoder qrcodeWithString:value withSize:size];
}

@end
