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

@interface VBMathMatrix ()

@property (nonatomic, strong) NSMutableArray* values;

#warning TODO make readonly
@property (nonatomic, assign) NSInteger rowsCount;
@property (nonatomic, assign) NSInteger columnsCount;

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
        self.rowsCount = values.count;
        self.columnsCount = [values[0] count];
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
    NSMutableArray* values = [NSMutableArray new];
    for (NSInteger row = 0; row < rowsCount; row++) {
        NSMutableArray* rowValues = [NSMutableArray new];
        for (NSInteger column = 0; column < columnsCount; column++) {
            [rowValues addObject:@(0)];
        }
        [values addObject:rowValues];
    }
    return [self initWithValues:values];
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
    self.rowsCount = self.columnsCount;
    self.columnsCount = tmp;
    
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

@end
