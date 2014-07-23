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

@interface VBMathMatrix ()

@property (nonatomic, strong) NSMutableArray* values;

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


#pragma mark - subscripting
- (id) objectAtIndexedSubscript:(NSUInteger)index {
    return self.values[index];
}

- (void) setObject:(id)obj atIndexedSubscript:(NSUInteger)idx {
    if ([obj isKindOfClass:[NSNumber class]] == NO) {
        @throw [VBInvalidClassException exceptionWithUsedClass:[obj class]
                                                 expectedClass:[NSNumber class]];
    }
    self.values[idx] = obj;
}

@end
