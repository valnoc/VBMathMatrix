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
#import "VBInvalidMatrixDimensionException.h"
#import "VBRowSelfAdditionException.h"
#import "VBZeroMultiplicationException.h"

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

    values = @[@(1), @(2), @(3)];
    XCTAssertNoThrow(mtrx[0] = values, @"");
    
    values = @[@(1), @(2)];
    XCTAssertThrowsSpecific(mtrx[0] = values, VBInvalidColumnsCountException, @"");
}

- (void) testEquality {
    VBMathMatrix* a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2)],
                                                       @[@(3), @(4)]]];
    VBMathMatrix* b = [VBMathMatrix matrixWithValues:@[@[@(1), @(2)],
                                                       @[@(3), @(4)]]];
    XCTAssert([a isEqualToMatrix:b] == YES, @"");
    
    b[0][0] = @(14);
    XCTAssert([a isEqualToMatrix:b] == NO, @"");
}

- (void) testOperations {
    VBMathMatrix* a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                                       @[@(4), @(5), @(6)]]];
    VBMathMatrix* b = [VBMathMatrix matrixWithValues:@[@[@(1), @(4)],
                                                       @[@(2), @(5)],
                                                       @[@(3), @(6)]]];
    XCTAssert([[a matrixByTransposition] isEqualToMatrix:b], @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                         @[@(4), @(5), @(6)]]];
    b = [VBMathMatrix matrixWithValues:@[@[@(3), @(4), @(5)],
                                         @[@(2), @(5), @(8)]]];
    VBMathMatrix* c = [VBMathMatrix matrixWithValues:@[@[@(4), @(6), @(8)],
                                                       @[@(6), @(10), @(14)]]];
    XCTAssert([[a matrixByAddingMatrix:b] isEqualToMatrix:c], @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                         @[@(4), @(5), @(6)]]];
    b = [VBMathMatrix matrixWithValues:@[@[@(3), @(4), @(5)]]];
    XCTAssertThrowsSpecific([a matrixByAddingMatrix:b], VBInvalidMatrixDimensionException, @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1)],
                                         @[@(2)],
                                         @[@(3)]]];
    b = [VBMathMatrix matrixWithValues:@[@[@(8)],
                                         @[@(20)],
                                         @[@(-6)]]];
    c = [VBMathMatrix matrixWithValues:@[@[@(-7)],
                                         @[@(-18)],
                                         @[@(9)]]];
    XCTAssert([[a matrixBySubstractingMatrix:b] isEqualToMatrix:c], @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(15), @(-3)],
                                         @[@(2), @(9), @(11)],
                                         @[@(3), @(-100), @(5)]]];
    c = [VBMathMatrix matrixWithValues:@[@[@(2), @(30), @(-6)],
                                         @[@(4), @(18), @(22)],
                                         @[@(6), @(-200), @(10)]]];
    XCTAssert([[a matrixByScalarMultiplication:2] isEqualToMatrix:c], @"");

    a = [VBMathMatrix matrixWithValues:@[@[@(2), @(30), @(-6)],
                                         @[@(4), @(18), @(22)],
                                         @[@(6), @(-200), @(10)]]];
    c = [VBMathMatrix matrixWithValues:@[@[@(1), @(15), @(-3)],
                                         @[@(2), @(9), @(11)],
                                         @[@(3), @(-100), @(5)]]];
    XCTAssert([[a matrixByScalarDivision:2] isEqualToMatrix:c], @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                         @[@(4), @(5), @(6)]]];
    b = [VBMathMatrix matrixWithValues:@[@[@(10), @(11), @(12)],
                                         @[@(13), @(14), @(15)],
                                         @[@(16), @(17), @(18)]]];
    c = [VBMathMatrix matrixWithValues:@[@[@(84), @(90), @(96)],
                                         @[@(201), @(216), @(231)]]];
    XCTAssert([[a matrixByRightMatrixMultiplication:b] isEqualToMatrix:c], @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3), @(0)],
                                         @[@(4), @(5), @(6), @(0)]]];
    b = [VBMathMatrix matrixWithValues:@[@[@(10), @(11), @(12)],
                                         @[@(13), @(14), @(15)],
                                         @[@(16), @(17), @(18)]]];
    XCTAssertThrowsSpecific([a matrixByRightMatrixMultiplication:b], VBInvalidMatrixDimensionException, @"");
}

- (void) testProps {
    VBMathMatrix* a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                                       @[@(4), @(5), @(6)]]];
    XCTAssert(a.square == NO, @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(4)],
                                         @[@(2), @(5)],
                                         @[@(3), @(6)]]];
    XCTAssert(a.isSquare == NO, @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(4), @(0)],
                                         @[@(2), @(5), @(1)],
                                         @[@(3), @(6), @(2)]]];
    XCTAssert(a.isSquare == YES, @"");
}

- (void) testRowOps {
    VBMathMatrix* a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                                       @[@(4), @(5), @(6)],
                                                       @[@(7), @(8), @(9)]]];
    VBMathMatrix* b = [VBMathMatrix matrixWithValues:@[@[@(5), @(7), @(9)],
                                                       @[@(4), @(5), @(6)],
                                                       @[@(7), @(8), @(9)]]];
    XCTAssert([[a matrixWithModifiedRowAtIndex:0 byAddingRowAtIndex:1] isEqualToMatrix:b], @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                         @[@(4), @(5), @(6)],
                                         @[@(7), @(8), @(9)]]];
    b = [VBMathMatrix matrixWithValues:@[@[@(9), @(12), @(15)],
                                         @[@(4), @(5), @(6)],
                                         @[@(7), @(8), @(9)]]];
    XCTAssert([[a matrixWithModifiedRowAtIndex:0 byAddingRowAtIndex:1 multipliedByScalar:2.0f] isEqualToMatrix:b], @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                         @[@(4), @(5), @(6)],
                                         @[@(7), @(8), @(9)]]];
    XCTAssertThrowsSpecific([a modifyRowAtIndex:1 byAddingRowAtIndex:1], VBRowSelfAdditionException, @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                         @[@(4), @(5), @(6)],
                                         @[@(7), @(8), @(9)]]];
    XCTAssertThrowsSpecific([a modifyRowAtIndex:1 byAddingRowAtIndex:2 multipliedByScalar:0.0f], VBZeroMultiplicationException, @"");
    
    a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                         @[@(4), @(5), @(6)],
                                         @[@(7), @(8), @(9)]]];
    b = [VBMathMatrix matrixWithValues:@[@[@(4), @(5), @(6)],
                                         @[@(1), @(2), @(3)],
                                         @[@(7), @(8), @(9)]]];
    XCTAssert([[a matrixBySwitchingRowAtIndex:0 withRowAtIndex:1] isEqualToMatrix:b], @"");
}

@end
