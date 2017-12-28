//
//  c4msis_iosTests.m
//  c4msis-iosTests
//
//  Created by Skifary on 16/11/2017.
//  Copyright © 2017 skifary. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "Utility.h"


#define kScreenWidth CGRectGetWidth([UIScreen mainScreen].bounds)

#define kScreenHeight CGRectGetHeight([UIScreen mainScreen].bounds)

#define kScreenFrame [UIScreen mainScreen].bounds

@interface c4msis_iosTests : XCTestCase

@end

@implementation c4msis_iosTests

- (void)setUp {
    [super setUp];

    CGFloat f = CGRectGetHeight([UIScreen mainScreen].bounds);

    NSLog(@"");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
