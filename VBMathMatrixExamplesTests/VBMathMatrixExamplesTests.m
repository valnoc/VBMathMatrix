//
//  VBMathMatrixExamplesTests.m
//  VBMathMatrixExamplesTests
//
//  Created by Valeriy Bezuglyy on 12/07/14.
//  Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "VBMathMatrix.h"
#import "VBInvalidClassException.h"
#import "VBZeroDimensionMatrixException.h"

@interface VBMathMatrixExamplesTests : XCTestCase

@end

@implementation VBMathMatrixExamplesTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInit
{
    XCTAssertThrowsSpecific([VBMathMatrix matrixWIthValues:nil], VBInvalidClassException, @"Nil array of values wasn't detected");
    XCTAssertThrowsSpecific([VBMathMatrix matrixWIthValues:@[@(1)]], VBInvalidClassException, @"Nil array of values wasn't detected");
    XCTAssertThrowsSpecific([VBMathMatrix matrixWIthValues:@[@[@"s"]]], VBInvalidClassException, @"Nil array of values wasn't detected");
    XCTAssertThrowsSpecific([VBMathMatrix matrixWIthValues:@[@[@"s"]]], VBInvalidClassException, @"Nil array of values wasn't detected");
}

@end
