//
//  YAMLHelper.m
//  c4msis-ios
//
//  Created by Skifary on 2018/9/4.
//  Copyright © 2018 skifary. All rights reserved.
//

#import "YAMLHelper.h"


#include <yaml-cpp/yaml.h>


class test {
    
    
public:
    static void t() { printf("hello world"); };
};

@implementation YAMLHelper

+ (void)load {
    
    
    test::t();
    
}

@end
