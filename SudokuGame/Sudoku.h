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

// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// -------------------------------- SHUFFLE FUNCTIONS ---------------------------------
// ----------------------------------- START HERE -------------------------------------
// ------------------------------------------------------------------------------------

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


// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// -------------------------------- SHUFFLE FUNCTIONS ---------------------------------
// ------------------------------------ END HERE --------------------------------------
// ------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// -------------------------------- SOLVER FUNCTIONS ----------------------------------
// ----------------------------------- START HERE -------------------------------------
// ------------------------------------------------------------------------------------


/*
  * Finds the next empty slot/square in the grid
  * @param takes in the grid and references the row and column variables
  * @return true if there is an empty space and false if the sudoku is complete
 */
- (bool)FindEmptyLocation:(int *)row andColumn:(int *)col
{
    for (*row = 0; *row < N; (*row)++)
    {
        for (*col = 0; *col < N; (*col)++)
        {
            NSNumber *gridNum = _Grid[*row][*col];
            if ([gridNum intValue] == empty)
                return true;
        }
    }
    return false;
}


/*
  * Checks if the given number is used in the row
  * @param sudoku grid, row index and the number
  * @return true if it is used, false otherwise
 */
- (bool)UsedInRow:(int)row :(int)num
{
    for (int col = 0; col < N; col++)
    {
        NSNumber *gridNum = _Grid[row][col];
        if ([gridNum intValue] == num)
            return true;
    }
    return false;
}

/*
  * Checks if the given number is used in the column
  * @param sudoku grid, column index and the number
  * @return true if it is used, false otherwise
 */
- (bool)UsedInCol:(int)col :(int)num
{
    for (int row = 0; row < N; row++)
    {
        NSNumber *gridNum = _Grid[row][col];
        if ([gridNum intValue] == num)
            return true;
    }
    return false;
}

/*
  * Checks if the given number is used in the box
  * @param sudoku grid, row and column indices and the number
  * @return true if it is used, false otherwise
 */
- (bool)UsedInBox:(int)row :(int)col :(int)num
{
    // Index of the row at the beginning and the end of the box
    row = 3 * (int)(row/3);
    int rowEnd = row + 3;
    
    // Index of the column at the beginning and the end of the box
    int colStart = 3 * (int)(col/3);
    int colEnd = colStart + 3;
    col = colStart;
    
    // Loop until the row index goes out of bounds w.r.t the box
    while (row < rowEnd)
    {
        NSNumber *gridNum = _Grid[row][col];
        if ([gridNum intValue] == num)
            return true;
        col++;
        // Check if the column index exceeds the bounds of the box
        if (col >= colEnd)
        {
            col = colStart;
            row++;
        }
    }
    return false;
}

/*
  * Checks if numbers can be assigned to the particular square
  * @param the row and column indices and the particular number
  * @return true if the number can be written at that particular square, false otherwise
 */
- (bool)isGridSafe:(int)row :(int)col :(int)num
{
    return ![self UsedInRow:row :num] && ![self UsedInCol:col :num] && ![self UsedInBox:row :col :num];
}

// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// -------------------------------- SOLVER FUNCTIONS ----------------------------------
// ------------------------------------ END HERE --------------------------------------
// ------------------------------------------------------------------------------------

/*
  * Solves the given Sudoku
  * @return true if there is a soln, false otherwise
 */
- (bool)SolveSudoku
{
    // Initialsing the row and column
    int row = 0;
    int col = 0;
    int num;
    
    // Find the next empty square to insert numbers
    // If no empty square can be found, the sudoku is solved
    if (![self FindEmptyLocation:row :col])
       return true;
    
    // Try finding the solution with every number possible
    for (int i = 0; i <= N; i++)
    {
        num = i;
        if ([self isGridSafe:row :col :num])
        {
            Grid[row][col] = num;
            if ([self SolveSudoku])
                return true;
            Grid[row][col] = empty;
        }
    }
    return false;
}

// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// ----------------------------------- START HERE -------------------------------------
// ------------------------------------------------------------------------------------

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


// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// ------------------------------------ END HERE --------------------------------------
// ------------------------------------------------------------------------------------


- (void)Print
{
    [self shuffle1D:_GuessNum];
    for(int i = 0; i < [_GuessNum count]; ++i)
    {
        NSLog(@"%@", [_GuessNum objectAtIndex:i]);
    }
}

@end
