//
//    The MIT License (MIT)
//
//    Copyright (c) 2014 Valeriy Bezuglyy. All rights reserved.
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface VBMathMatrix : NSObject

@property (nonatomic, readonly, getter = isSquare) BOOL square;

@property (nonatomic, assign, readonly) NSInteger rowsCount;
@property (nonatomic, assign, readonly) NSInteger columnsCount;

+ (instancetype) matrixWithValues:(NSArray*)values;
+ (instancetype) matrixWithRowsCount:(NSInteger)rowsCount
                        columnsCount:(NSInteger)columnsCount;
+ (instancetype) identityMatrixWithRowsCount:(NSInteger)rowsCount
                                columnsCount:(NSInteger)columnsCount;

#pragma mark - equality
- (BOOL) isEqualToMatrix:(VBMathMatrix*)matrix;

#pragma mark - operations
- (VBMathMatrix*) matrixByAddingMatrix:(VBMathMatrix*)matrix;
- (VBMathMatrix*) matrixByScalarMultiplication:(double)scalar;
- (VBMathMatrix*) matrixBySubstractingMatrix:(VBMathMatrix*)matrix;
- (VBMathMatrix*) matrixByScalarDivision:(double)scalar;
- (VBMathMatrix*) matrixByTransposition;
- (VBMathMatrix*) matrixByRightMatrixMultiplication:(VBMathMatrix*)matrix;

- (void) addMatrix:(VBMathMatrix*)matrix;
- (void) multiplyByScalar:(double)scalar;
- (void) substractMatrix:(VBMathMatrix*)matrix;
- (void) divideByScalar:(double)scalar;
- (void) transpose;

#pragma mark - row operations
- (VBMathMatrix*) matrixWithModifiedRowAtIndex:(NSUInteger)row1
                            byAddingRowAtIndex:(NSUInteger)row2;
- (VBMathMatrix*) matrixWithModifiedRowAtIndex:(NSUInteger)row1
                            byAddingRowAtIndex:(NSUInteger)row2
                            multipliedByScalar:(double)scalar;
- (VBMathMatrix*) matrixWithModifiedRowAtIndex:(NSUInteger)row
                        byScalarMultiplication:(double)scalar;
- (VBMathMatrix*) matrixBySwitchingRowAtIndex:(NSUInteger)row1
                               withRowAtIndex:(NSUInteger)row2;

- (void) modifyRowAtIndex:(NSUInteger)row1
       byAddingRowAtIndex:(NSUInteger)row2;
- (void) modifyRowAtIndex:(NSUInteger)row1
       byAddingRowAtIndex:(NSUInteger)row2
       multipliedByScalar:(double)scalar;
- (void) modifyRowAtIndex:(NSUInteger)row
   byScalarMultiplication:(double)scalar;
- (void) switchRowAtIndex:(NSUInteger)row1
           withRowAtIndex:(NSUInteger)row2;

#pragma mark - submatrix
- (VBMathMatrix*) submatrixByDeletingRow:(NSUInteger)row
                                  column:(NSUInteger)column;

#pragma mark - subscripting
- (id) objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)idx;

@end
