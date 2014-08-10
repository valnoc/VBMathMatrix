VBMathMatrix
============

VBMathMatrix instance represents a mathematical matrix (numbers organized in rows and columns). This class supports a number of features such as basic matrix operations, row operations, matrix transformations, calculation of different matrix values.

## How to use
1. Drag VBMathMatrix dir into your project.
2. Import header

    `#import "VBMathMatrix.h”`

3. Use one of the variants to create new matrix
    
    Create matrix with an array of values:
    
        VBMathMatrix* a = [VBMathMatrix matrixWithValues:@[@[@(1), @(2), @(3)],
                                                           @[@(4), @(5), @(6)]]];
        VBMathMatrix* b = [VBMathMatrix matrixWithValues:@[@[@(1), @(4)],
                                                           @[@(2), @(5)],
                                                           @[@(3), @(6)]]];
    
    Create an empty matrix of specific dimension (filled with zeroes):

        VBMathMatrix* c = [VBMathMatrix matrixWithRowsCount:3
                                               columnsCount:3];

## Supported features
1. get and set values using subscripting
    
        NSLog(@"%@", a[0][0]);
        a[1][2] = b[0][1];

2. matrix addition, subsctraction, right multiplication, scalar multiplication/division
3. transposition
4. row addition, multiplication, switching
5. submatrix creation

## Coming soon
Feel free to left a feature request

## License
VBMathMatrix is available under the MIT license. See the LICENSE file for more info.
