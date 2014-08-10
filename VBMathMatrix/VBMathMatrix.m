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

#import "VBMathMatrix.h"

#import "VBInvalidClassException.h"
#import "VBZeroDimensionMatrixException.h"
#import "VBInvalidColumnsCountException.h"
#import "VBInvalidMatrixDimensionException.h"
#import "VBRowSelfAdditionException.h"
#import "VBZeroMultiplicationException.h"

@interface VBMathMatrix ()

@property (nonatomic, strong) NSMutableArray* values;

@end

@implementation VBMathMatrix

+ (instancetype) matrixWithValues:(NSArray*)values {
    return [[self alloc] initWithValues:values];
}
- (instancetype) initWithValues:(NSArray*)values {
    self = [super init];
    if (self) {
        if (values == nil || [values isKindOfClass:[NSNull class]]) {
            @throw [VBInvalidClassException exceptionWithUsedClass:[NSNull class]
                                                     expectedClass:[NSArray class]];
        }
        
        //  check classes
        for (id objArr in values) {
            if ([objArr isKindOfClass:[NSArray class]] == NO) {
                @throw [VBInvalidClassException exceptionWithUsedClass:[objArr class]
                                                         expectedClass:[NSArray class]];
            }
            for (id objNum in objArr) {
                if ([objNum isKindOfClass:[NSNumber class]] == NO) {
                    @throw [VBInvalidClassException exceptionWithUsedClass:[objNum class]
                                                             expectedClass:[NSNumber class]];
                }
            }
        }
        
        // check dimensions
        if (values.count == 0 || [values[0] count] == 0) {
            @throw [VBZeroDimensionMatrixException exception];
        }
        _rowsCount = values.count;
        _columnsCount = [values[0] count];
        for (NSArray* row in values) {
            if (row.count != self.columnsCount) {
                @throw [VBInvalidColumnsCountException exceptionWithColumnsCount:row.count
                                                                   expectedCount:self.columnsCount];
            }
        }
        
        //  everything is ok
        self.values = [NSMutableArray new];
        for (NSInteger i = 0; i < values.count; i++) {
            [self.values addObject:[NSMutableArray arrayWithArray:values[i]]];
        }
    }
    return self;
}

+ (instancetype) matrixWithRowsCount:(NSInteger)rowsCount
                        columnsCount:(NSInteger)columnsCount {
    return [[self alloc] initWithRowsCount:rowsCount
                              columnsCount:columnsCount];
}
- (instancetype) initWithRowsCount:(NSInteger)rowsCount
                      columnsCount:(NSInteger)columnsCount {
    return [self initWithValues:[self arrayWithRowsCount:rowsCount
                                            columnsCount:columnsCount]];
}

+ (instancetype) identityMatrixWithSize:(NSInteger)size {
    return [[self alloc] initIdentityWithSize:size];
}
- (instancetype) initIdentityWithSize:(NSInteger)size {
    NSMutableArray* values = [self arrayWithRowsCount:size
                                         columnsCount:size];
    for (NSInteger i = 0; i < size; i++) {
        values[i][i] = @(1.0f);
    }
    return [self initWithValues:values];
}

#pragma mark - props
- (BOOL) isSquare {
    return self.rowsCount == self.columnsCount;
}
- (BOOL) isIdentityMatrix {
    BOOL res = self.isSquare;
    if (res) {
        for (NSInteger row = 0; self.rowsCount; row++) {
            for (NSInteger col = 0; self.columnsCount; col++) {
                double val = [self[row][col] doubleValue];
                if ((row == col && val != 1.0f) || (row != col && val != 0.0f)) {
                    res = NO;
                    break;
                }
            }
            if (res == NO) {
                break;
            }
        }
    }
    return res;
}

#pragma mark - equality
- (BOOL) isEqual:(id)object {
    return [object isKindOfClass:[VBMathMatrix class]] ? [self isEqualToMatrix:object] : [super isEqual:object];
}
- (BOOL) isEqualToMatrix:(VBMathMatrix*)matrix {
    BOOL eq = YES;
    for (NSInteger r = 0; r < self.rowsCount; r++) {
        for (NSInteger c = 0; c < self.columnsCount; c++) {
            if ([self[r][c] isEqualToNumber:matrix[r][c]] == NO) {
                eq = NO;
                break;
            }
        }
    }
    return eq;
}

#pragma mark - operations
- (VBMathMatrix*) matrixByAddingMatrix:(VBMathMatrix*)matrix {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result addMatrix:matrix];
    return result;
}
- (VBMathMatrix*) matrixByScalarMultiplication:(double)scalar {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result multiplyByScalar:scalar];
    return result;
}
- (VBMathMatrix*) matrixBySubstractingMatrix:(VBMathMatrix*)matrix {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result substractMatrix:matrix];
    return result;
}
- (VBMathMatrix*) matrixByScalarDivision:(double)scalar {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result divideByScalar:scalar];
    return result;
}
- (VBMathMatrix*) matrixByTransposition {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result transpose];
    return result;
}
- (VBMathMatrix*) matrixByRightMatrixMultiplication:(VBMathMatrix*)matrix {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result multiplyRightByMatrix:matrix];
    return result;
}

- (void) addMatrix:(VBMathMatrix*)matrix {
    if (self.rowsCount != matrix.rowsCount || self.columnsCount != matrix.columnsCount) {
        @throw [VBInvalidMatrixDimensionException exceptionWithRowsCount:matrix.rowsCount
                                                            columnsCount:matrix.columnsCount
                                                       expectedRowsCount:self.rowsCount
                                                    expectedColumnsCount:self.columnsCount];
    }
    
    for (NSInteger row = 0; row < self.rowsCount; row++) {
        for (NSInteger col = 0; col < self.columnsCount; col++) {
            double a = [self[row][col] doubleValue];
            double b = [matrix[row][col] doubleValue];
            self[row][col] = @(a + b);
        }
    }
}
- (void) multiplyByScalar:(double)scalar {
    for (NSInteger row = 0; row < self.rowsCount; row++) {
        for (NSInteger col = 0; col < self.columnsCount; col++) {
            double a = [self[row][col] doubleValue];
            self[row][col] = @(a * scalar);
        }
    }
}
- (void) substractMatrix:(VBMathMatrix*)matrix {
    [self addMatrix:[matrix matrixByScalarMultiplication:-1]];
}
- (void) divideByScalar:(double)scalar {
    [self multiplyByScalar:1.0f / scalar];
}
- (void) transpose {
    NSInteger tmp = self.rowsCount;
    _rowsCount = self.columnsCount;
    _columnsCount = tmp;
    
    NSArray* oldValues = [NSArray arrayWithArray:self.values];
    [self.values removeAllObjects];
    
    for (NSInteger row = 0; row < self.rowsCount; row++) {
        [self.values addObject:[NSMutableArray new]];
        for (NSInteger col = 0; col < self.columnsCount; col++) {
            [self.values[row] addObject:[NSNull null]];
        }
    }
    
    for (NSInteger row = 0; row < self.rowsCount; row++) {
        for (NSInteger col = 0; col < self.columnsCount; col++) {
            self[row][col] = oldValues[col][row];
        }
    }
}
- (void) multiplyRightByMatrix:(VBMathMatrix*)matrix {
    if (self.columnsCount != matrix.rowsCount) {
        @throw [VBInvalidMatrixDimensionException exceptionWithRowsCount:matrix.rowsCount
                                                            columnsCount:matrix.columnsCount
                                                       expectedRowsCount:self.columnsCount
                                                    expectedColumnsCount:matrix.columnsCount];
    }
    // mxn, nxp
    double m = self.rowsCount;
    double n = self.columnsCount;
    double p = matrix.columnsCount;

    NSArray* oldValues = [NSArray arrayWithArray:self.values];
    
    _rowsCount = m;
    _columnsCount = p;
    
    [self.values removeAllObjects];
    self.values = [self arrayWithRowsCount:self.rowsCount
                              columnsCount:self.columnsCount];
    
    for (NSInteger row = 0; row < self.rowsCount; row++) {
        for (NSInteger col = 0; col < self.columnsCount; col++) {
            double sum = 0;
            for (NSInteger i = 0; i < n; i++) {
                double a = [oldValues[row][i] doubleValue];
                double b = [matrix[i][col] doubleValue];
                sum += a*b;
            }
            self[row][col] = @(sum);
        }
    }
}

#pragma mark - row operations
- (VBMathMatrix*) matrixWithModifiedRowAtIndex:(NSUInteger)row1
                            byAddingRowAtIndex:(NSUInteger)row2 {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result modifyRowAtIndex:row1
          byAddingRowAtIndex:row2];
    return result;
}
- (VBMathMatrix*) matrixWithModifiedRowAtIndex:(NSUInteger)row1
                            byAddingRowAtIndex:(NSUInteger)row2
                            multipliedByScalar:(double)scalar {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result modifyRowAtIndex:row1
          byAddingRowAtIndex:row2
          multipliedByScalar:scalar];
    return result;
}
- (VBMathMatrix*) matrixWithModifiedRowAtIndex:(NSUInteger)row
                        byScalarMultiplication:(double)scalar {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result modifyRowAtIndex:row
      byScalarMultiplication:scalar];
    return result;
}
- (VBMathMatrix*) matrixBySwitchingRowAtIndex:(NSUInteger)row1
                               withRowAtIndex:(NSUInteger)row2 {
    VBMathMatrix* result = [VBMathMatrix matrixWithValues:self.values];
    [result switchRowAtIndex:row1
              withRowAtIndex:row2];
    return result;
}

- (void) modifyRowAtIndex:(NSUInteger)row1
       byAddingRowAtIndex:(NSUInteger)row2 {
    [self modifyRowAtIndex:row1
        byAddingRowAtIndex:row2 
        multipliedByScalar:1.0f];
}
- (void) modifyRowAtIndex:(NSUInteger)row1
       byAddingRowAtIndex:(NSUInteger)row2
       multipliedByScalar:(double)scalar {
    
    if (row1 == row2) {
        @throw [VBRowSelfAdditionException exceptionWithRowIndex:row1];
    }
    if (scalar == 0.0f) {
        @throw [VBZeroMultiplicationException exception];
    }
    for (NSInteger col = 0; col < self.columnsCount; col++) {
        self[row1][col] = @([self[row1][col] doubleValue] + [self[row2][col] doubleValue] * scalar);
    }
}
- (void) modifyRowAtIndex:(NSUInteger)row
   byScalarMultiplication:(double)scalar {
    
    if (scalar == 0.0f) {
        @throw [VBZeroMultiplicationException exception];
    }
    for (NSInteger col = 0; col < self.columnsCount; col++) {
        self[row][col] = @([self[row][col] doubleValue] * scalar);
    }
}
- (void) switchRowAtIndex:(NSUInteger)row1
           withRowAtIndex:(NSUInteger)row2 {
    
    NSArray* arr1 = self[row1];
    self[row1] = self[row2];
    self[row2] = arr1;
}

#pragma mark - submatrix
- (VBMathMatrix*) submatrixByDeletingRow:(NSUInteger)row
                                  column:(NSUInteger)column {
    NSMutableArray* newVal = [self arrayWithRowsCount:self.rowsCount-1 columnsCount:self.columnsCount-1];
    
    BOOL rowS = NO;
    for (NSInteger r = 0; r < self.rowsCount; r++) {
        if (r == row) {
            rowS = YES;
            continue;
        }
        BOOL colS = NO;
        for (NSInteger c = 0 ; c < self.columnsCount; c++) {
            if (c == column) {
                colS = YES;
                continue;
            }
            newVal[r - rowS ? 1 : 0][c - colS ? 1 : 0] = @([self[r][c] doubleValue]);
        }
    }
    return [VBMathMatrix matrixWithValues:newVal];
}

#pragma mark - subscripting
- (id) objectAtIndexedSubscript:(NSUInteger)index {
    return self.values[index];
}

- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
#warning TODO check nil
#warning TODO check nil
    if ([obj isKindOfClass:[NSArray class]] == NO) {
        @throw [VBInvalidClassException exceptionWithUsedClass:[obj class]
                                                 expectedClass:[NSNumber class]];
    }
    if ([obj count] != self.columnsCount) {
        @throw [VBInvalidColumnsCountException exceptionWithColumnsCount:[obj count]
                                                           expectedCount:self.columnsCount];
    }
    self.values[idx] = obj;
}

#pragma mark - helpers
- (NSMutableArray*) arrayWithRowsCount:(NSInteger)rowsCount
                          columnsCount:(NSInteger)columnsCount {
    NSMutableArray* values = [NSMutableArray new];
    for (NSInteger row = 0; row < rowsCount; row++) {
        NSMutableArray* rowValues = [NSMutableArray new];
        for (NSInteger column = 0; column < columnsCount; column++) {
            [rowValues addObject:@(0)];
        }
        [values addObject:rowValues];
    }
    return values;
}

@end
