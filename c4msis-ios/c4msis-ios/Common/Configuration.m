//
//  Configuration.m
//  c4msis-ios
//
//  Created by Skifary on 25/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "Configuration.h"

static NSString* kConfigurationCoderKeyType = @"ConfigurationCoderKeyType";

static NSString* kConfigurationCoderKeyHost = @"ConfigurationCoderKeyHost";

@implementation Configuration

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    
    [aCoder encodeInteger:self.type forKey:kConfigurationCoderKeyType];
    
    [aCoder encodeObject:self.host forKey:kConfigurationCoderKeyHost];
    
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    
    self  = [self init];
    
    if (self) {
        self.type = [aDecoder decodeIntegerForKey:kConfigurationCoderKeyType];
        
        self.host = [aDecoder decodeObjectForKey:kConfigurationCoderKeyHost];
    }
    
    return self;
}

@end
