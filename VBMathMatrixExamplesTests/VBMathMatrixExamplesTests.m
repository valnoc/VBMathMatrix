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
#import "VBInvalidColumnsCountException.h"

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
    XCTAssertThrowsSpecific([VBMathMatrix matrixWithValues:nil], VBInvalidClassException, @"");
    XCTAssertThrowsSpecific([VBMathMatrix matrixWithValues:@[@(1)]], VBInvalidClassException, @"");
    XCTAssertThrowsSpecific([VBMathMatrix matrixWithValues:@[@[@"s"]]], VBInvalidClassException, @"");

    NSArray* values = @[@[@(1)], @(1)];
    XCTAssertThrowsSpecific([VBMathMatrix matrixWithValues:values], VBInvalidClassException, @"");

    XCTAssertThrowsSpecific([VBMathMatrix matrixWithValues:@[]], VBZeroDimensionMatrixException, @"");
    
    values = @[@[@(1), @(2)],
               @[@(1)]];
    XCTAssertThrowsSpecific([VBMathMatrix matrixWithValues:values], VBInvalidColumnsCountException, @"");

    values = @[@[@(1), @(2)],
               @[@(2), @(3)]];
    XCTAssertNoThrow([VBMathMatrix matrixWithValues:values], @"");
    
    XCTAssertNoThrow([VBMathMatrix matrixWithRowsCount:3
                                          columnsCount:3], @"");
    
    VBMathMatrix* mtrx = [VBMathMatrix matrixWithRowsCount:3
                                              columnsCount:3];
    XCTAssertNoThrow(mtrx[0][0], @"");
    XCTAssertNoThrow(mtrx[0][0] = @(1), @"");
    
    XCTAssertThrowsSpecific(mtrx[0] = @"as", VBInvalidClassException, @"");
}

@end
