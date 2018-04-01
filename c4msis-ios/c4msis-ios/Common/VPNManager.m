//
//  VPNManager.m
//  c4msis-ios
//
//  Created by Skifary on 24/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import "VPNManager.h"

#import "ShadowsocksConfiguration.h"

#import "ConfigurationManager.h"

#import <NetworkExtension/NetworkExtension.h>

@interface VPNManager()

@property (assign, nonatomic, readwrite) VPNStatus status;

@property (strong, nonatomic) NSMutableArray<StatusUpdateHandle>* statusUpdateHandles;

@property (assign, nonatomic) BOOL isAddObserver;

@end

@implementation VPNManager

#pragma mark Publick API

+ (instancetype)manager {
    static VPNManager* _manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[VPNManager alloc] init];
    });
    return _manager;
}

- (void)connect:(void (^)(NSError *))complete {
    Configuration* config = [[ConfigurationManager manager] currentConfiguration];

    if (!config) {
        NSError* error = [NSError errorWithDomain:@"current configuration is nil" code:-1 userInfo:nil];
        complete(error);
        return;
    }

    [self loadProviderManager:^(NETunnelProviderManager* manager) {
        NSError* error;
        [manager.connection startVPNTunnelWithOptions:nil andReturnError:&error];
        
        if (complete) {
            complete(error);
        }
    }];
}

- (void)disconnect {
    [self loadProviderManager:^(NETunnelProviderManager* manager) {
        [manager.connection stopVPNTunnel];
    }];
}

- (void)registerForStatusChange:(StatusUpdateHandle)handle {
    [self.statusUpdateHandles addObject:handle];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.statusUpdateHandles = [NSMutableArray array];
        self.isAddObserver = NO;
        [self loadProviderManager:^(NETunnelProviderManager* manager) {
            [self updateVPNStatus: manager.connection.status];
        }];
        
    }
    return self;
}

#pragma mark - status observer

- (void)updateVPNStatus:(NEVPNStatus)vpnStatus {

    switch (vpnStatus) {
        case NEVPNStatusDisconnected:
            self.status = VPNStatusDisconnect;
            break;
        case NEVPNStatusInvalid:
            self.status = VPNStatusDisconnect;
            break;
        case NEVPNStatusConnected:
            self.status = VPNStatusConnected;
            break;
        case NEVPNStatusDisconnecting:
            self.status = VPNStatusDisconnecting;
            break;
        case NEVPNStatusReasserting:
            self.status = VPNStatusConnecting;
            break;
        case NEVPNStatusConnecting:
            self.status = VPNStatusConnecting;
            break;
        default:
            break;
    }
    
    for (StatusUpdateHandle handle in self.statusUpdateHandles) {
        handle(self.status);
    }
}

#pragma mark - ProviderManager

- (void)loadProviderManager:(nullable void (^)(NETunnelProviderManager* manager))complete {
    [NETunnelProviderManager loadAllFromPreferencesWithCompletionHandler:^(NSArray<NETunnelProviderManager *> * _Nullable managers, NSError * _Nullable error) {
        NETunnelProviderManager* manager = nil;
        if (nil == error && [managers count] > 0) {
            manager = [managers firstObject];
        } else {
            manager = [self createProviderManager];
        }
        manager.enabled = YES;
        Configuration* config = [[ConfigurationManager manager] currentConfiguration];
        
        if (!config) {
            if (complete) {
                complete(nil);
            }
            return;
        }
        [self saveProviderManager:manager configuration:config complete:^(NSError* error) {
            if (error) {
                if (complete) {
                    complete(nil);
                }
                return;
            }
            // add observer
            if (!self.isAddObserver) {
                self.isAddObserver = YES;
                [NSNotificationCenter.defaultCenter addObserverForName:NEVPNStatusDidChangeNotification object:manager.connection queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                    [self updateVPNStatus:manager.connection.status];
                }];
            }
            if (complete) {
                complete(manager);
            }
        }];
    }];
}

- (void)saveProviderManager:(NETunnelProviderManager *)manager configuration:(Configuration *)config complete:(nullable void (^)(NSError *))complete {
    NETunnelProviderProtocol* protocol = (NETunnelProviderProtocol*)manager.protocolConfiguration;
    protocol.providerConfiguration = [self providerConfigurationWithConfiguration:config];
    manager.protocolConfiguration = protocol;
    [manager saveToPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            complete(error);
            return;
        }
        [manager loadFromPreferencesWithCompletionHandler:^(NSError * _Nullable error) {
            complete(error);
        }];
    }];
}

- (NETunnelProviderManager*)createProviderManager {
    NETunnelProviderManager* manager = [[NETunnelProviderManager alloc] init];
    NETunnelProviderProtocol* protocol = [[NETunnelProviderProtocol alloc] init];
    protocol.serverAddress = @"host";
    manager.protocolConfiguration = protocol;
    manager.localizedDescription = @"hbh";
    return manager;
}

- (NSDictionary*)providerConfigurationWithConfiguration:(Configuration *)config {
    NSDictionary* ret;
    switch (config.type) {
        case ConfigurationTypeShadowsocks:
            ret = [self providerConfigurationWithShadowsocksConfiguration:(ShadowsocksConfiguration *)config];
            break;

        default:
            break;
    }
    return ret;
}

- (NSString *)yamlConf {
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"NEKitRule" ofType:@"conf"];
    NSData* data = [NSData dataWithContentsOfFile:path];
    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSDictionary *)providerConfigurationWithShadowsocksConfiguration:(ShadowsocksConfiguration *)config {

    NSDictionary* ret = @{@"ss_address" : config.host,
                          @"ss_port" : @(config.port.integerValue),
                          @"ss_method" : config.methodString,
                          @"ss_password" : config.password,
                          @"ymal_conf" : [self yamlConf]};
    return ret;
}

@end
