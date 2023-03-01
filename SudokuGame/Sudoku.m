//
//  Sudoku.m
//  SudokuGame
//
//  Created by Yash Jain on 3/1/23.
//

#import <Foundation/Foundation.h>
// Sudoku.h
int N = 9;
int empty = 0;

@interface Sudoku : NSObject

@property (nonatomic, strong) NSMutableArray *Grid;
@property (nonatomic, strong) NSMutableArray *SolnGrid;
@property (nonatomic, strong) NSMutableArray *GuessNum;
@property (nonatomic, strong) NSMutableArray *GuessPos;

/*
 * Difficulty levels explained :
 * Easy : 0
 * Medium : 1
 * Hard : 2
 * Expert : 3
 */
@property (nonatomic) NSInteger difficultyLevel;

@end

// Sudoku.m
@implementation Sudoku

// Constructor Function
- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialising the Grid to be array of 81 0s
        _Grid = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0; i < 9; i++)
        {
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:9];
            for (int j = 0; j < 9; j++) {
                [row addObject:@(0)]; // set initial value to 0
            }
            [_Grid addObject:row];
        }
        
        // Initialising the SolnGrid to be array of 81 0s
        _SolnGrid = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0; i < 9; i++)
        {
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:9];
            for (int j = 0; j < 9; j++) {
                [row addObject:@(0)]; // set initial value to 0
            }
            [_SolnGrid addObject:row];
        }
        
        // Initialising the GuessNum array to be array from 1 - 9
        _GuessNum = [NSMutableArray arrayWithCapacity:9];
        for (int i = 1; i <= 9; i++) {
            [_GuessNum addObject:@(i)];
        }
        
        // Initialising GuessPos to be an array of positions from 0 - 88
        _GuessPos = [NSMutableArray arrayWithCapacity:9];
        for (int i = 0; i < 9; i++)
        {
            NSMutableArray *row = [NSMutableArray arrayWithCapacity:9];
            for (int j = 0; j < 9; j++) {
                [row addObject:@(0)]; // set initial value to 0
            }
            [_GuessPos addObject:row];
        }
        
        _difficultyLevel = 0;
        
        // Initialize the arrays with values here, if needed
    }
    return self;
}

/*
  * Shuffles the elements of a 1-D array
  * @param : an array to be shuffled
*/
- (void)shuffle1D:(NSMutableArray *)array
{
    NSUInteger count = [array count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [array exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
}

/*
  * Shuffles the elements of a 2-D array
  * @param : an array to be shuffled
*/
- (void)shuffle2DArray:(NSMutableArray *)array
{
    NSUInteger rows = [array count];
    if (rows == 0)
        return;
    NSUInteger columns = [array[0] count];
    for (NSUInteger i = 0; i < rows; i++)
    {
        for (NSUInteger j = 0; j < columns; j++)
        {
            NSUInteger remainingRows = rows - i;
            NSUInteger remainingColumns = columns - j;
            NSUInteger exchangeRow = i + arc4random_uniform((u_int32_t)remainingRows);
            NSUInteger exchangeColumn = j + arc4random_uniform((u_int32_t)remainingColumns);
            id temp = array[i][j];
            array[i][j] = array[exchangeRow][exchangeColumn];
            array[exchangeRow][exchangeColumn] = temp;
        }
    }
}


/*
  * Fills the empty diagonal boxes
  * As it requires no rules to fill
  * Except : there cannot be same numbers in a box
*/
- (void)FillDiagonalBoxes:(int)idx
{
    [self shuffle1D:_GuessNum];
    int start = idx*3;
    for (int i = 0; i < 3; ++i)
    {
        for (int j = 0; j < 3; ++j)
            _Grid[start+i][start+j] = _GuessNum[i*3+j];
    }
}

- (void)Print
{
    for(int i = 0; i < [_GuessNum count]; ++i)
    {
        NSLog(_GuessNum[i]);
    }
}

@end
