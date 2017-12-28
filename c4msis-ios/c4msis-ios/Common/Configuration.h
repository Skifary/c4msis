//
//  Configuration.h
//  c4msis-ios
//
//  Created by Skifary on 25/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ConfigurationTypeShadowsocks = 0,
} ConfigurationType;

@interface Configuration : NSObject<NSCoding>

@property (nonatomic, assign) ConfigurationType type;

@property (nonatomic, copy) NSString* host;

@end
