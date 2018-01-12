//
//  ConfigurationManager.m
//  c4msis-ios
//
//  Created by Skifary on 25/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "ConfigurationManager.h"
#import "Utility.h"

@interface ConfigurationManager()

@property (nonatomic, strong, readwrite) NSMutableArray<Configuration*>* configurations;

@property (nonatomic, strong) NSMutableArray* configurationsChangedBlock;

@property (nonatomic, assign) BOOL isSave;

@end

static NSString* kCurrentConfigurationsKey = @"CurrentConfigurationsKey";

@implementation ConfigurationManager


#pragma mark Publick API

+ (instancetype)manager {
    static ConfigurationManager* _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[ConfigurationManager alloc] init];
    });
    return _manager;
}

- (Configuration *)currentConfiguration {
    
    if (self.configurations.count > self.currentConfigurationIndex && self.currentConfigurationIndex >= 0 ) {
        return self.configurations[self.currentConfigurationIndex];
    }
    
    return nil;
}

- (void)save {
    
    NSString* path = [self configurationsArchiverPath];
    if (![NSKeyedArchiver archiveRootObject:self.configurations toFile:path]) {
        Log(@"archive failed")
    }
    [[NSUserDefaults standardUserDefaults] setInteger:self.currentConfigurationIndex forKey:kCurrentConfigurationsKey];
}

- (void)addConfiguration:(Configuration *)configuration {
    
    if ([self.configurations containsObject:configuration]) {
        self.currentConfigurationIndex = [self.configurations indexOfObject:configuration];
        return;
    }
    [self.configurations addObject:configuration];
    self.currentConfigurationIndex = self.configurations.count - 1;
    for (void (^block)(void)  in self.configurationsChangedBlock) {
        block();
    }
}

- (void)deleteConfiguration:(Configuration *)configuration {
    
    if ([self.configurations indexOfObject:configuration] == self.currentConfigurationIndex) {
        self.currentConfigurationIndex = -1;
    }
    
    [self.configurations removeObject:configuration];
    for (void (^block)(void)  in self.configurationsChangedBlock) {
        block();
    }
}

- (void)registerForNotifacationWhenConfigurationsChanged:(void (^)(void))block {
    [self.configurationsChangedBlock addObject:block];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        
        NSString* path = [self configurationsArchiverPath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            self.configurations = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        }
        
        if (!self.configurations) {
            self.configurations = [NSMutableArray array];
        }

        self.currentConfigurationIndex = self.configurations.count == 0 ? -1 : [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentConfigurationsKey];
        
        self.configurationsChangedBlock = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark -

- (NSString *)configurationsArchiverPath {
    
    NSString* docPath = [PathUtility documentDirectory];
    return [docPath stringByAppendingString:@"/configurations.archiver"];
}

@end
