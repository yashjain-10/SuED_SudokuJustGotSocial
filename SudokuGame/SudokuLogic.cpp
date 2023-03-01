//
//  SoudokuGame.cpp
//  Sudoku
//
//  Created by Yash Jain on 10/10/22.
//

#include <stdio.h>
//#include "SudokuClass.h"
#include <iostream>
#include <algorithm>
#include <ctime>
#include <cstdlib>
#include <string>
#include <vector>
#include <math.h>
#include <random>
#include <chrono>

using namespace std;

#define N 9
#define empty 0

class Sudoku
{
    private :
    int Grid[N][N];
    int SolnGrid[N][N];
    int GuessNum[N];
    int GridPos[N*N];
    
    /*
      * Difficulty levels explained :
      * Easy : 0
      * Medium : 1
      * Hard : 2
      * Expert : 3
    */
    int DifficultyLevel;
    
    unsigned seed;
    //bool GridStatus;
    
    public :
    Sudoku ();
    Sudoku (int);
    //Sudoku(string, bool row_major = true);
    void FillDiagonalBoxes(int);
    //void CreateSeed();
    void PrintSudoku();
    bool SolveSudoku();
    bool FindEmptyLocation(int &row, int &col);
    bool UsedInRow(int row, int num);
    bool UsedInColumn(int col, int num);
    bool UsedInBox(int row, int col, int num);
    bool isGridSafe(int row, int col, int num);
    //int** ReturnGrid();
    //string GetGrid();
    void CountSoln(int &soln);
    void GenerateSudoku();
    //bool VerifyGridStatus();
    void CalculateDifficulty();
    //int BranchDifficultyScore();
    bool SolveToGenerate();
    void GetDifficulty(int level);

    //extra
    bool FindRandomEmptyLocation(int &row, int &col);
};

// ------------------------------------------------------------------------------------
// -------------------------- CONSTRUCTORS FUNCTION START -----------------------------
// ------------------------------------------------------------------------------------

/*
  * Constructor Function 1
*/
Sudoku::Sudoku()
{
    int grid[N][N] =  {{0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0},
                        {0, 0, 0, 0, 0, 0, 0, 0, 0}};
                    
    for (int x=0 ; x < N; x++)
        for (int y=0 ; y < N; y++)
            Grid[x][y] = grid[x][y];

    DifficultyLevel = 0;

    // Initialising GuessNum for a list of N(9) numbers
    // Will be used to randomly enter numbers in boxes
    for (int i = 0; i < N; i++)
    {
        GuessNum[i] = i+1 ;
    }

    // Initialising GridPos for a list of all the 81 positions
    // Will be used to generate random positions to generate the sudoku
    for (int i = 0; i < N*N; i++)
    {
        GridPos[i] = i;
    }
    
    seed = std::chrono::system_clock::now().time_since_epoch().count();
}

/*
  * Constructor Function 2
*/
Sudoku::Sudoku(int second)
{
    int grid[N][N] = {{0, 0, 0, 5, 0, 0, 0, 8, 0},
                      {3, 0, 1, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 0, 0, 0, 0, 0},
                      {0, 0, 0, 0, 4, 3, 2, 0, 0},
                      {0, 0, 8, 0, 0, 0, 0, 7, 0},
                      {0, 0, 0, 0, 2, 0, 0, 0, 0},
                      {0, 6, 0, 0, 0, 0, 3, 0, 1},
                      {2, 0, 0, 0, 0, 0, 4, 0, 0},
                      {0, 5, 0, 7, 0, 0, 0, 0, 0}};
                    
    for (int x=0 ; x < N; x++)
        for (int y=0 ; y < N; y++)
        {
            Grid[x][y] = grid[x][y];
        }

    DifficultyLevel = 3;

    // Initialising GuessNum for a list of N(9) numbers
    // Will be used to randomly enter numbers in boxes
    for (int i = 0; i < N; i++)
    {
        GuessNum[i] = i+1 ;
    }
    // Initialising GridPos for a list of all the 81 positions
    // Will be used to generate random positions to generate the sudoku
    for (int i = 0; i < N*N; i++)
    {
        GridPos[i] = i;
    }

    seed = std::chrono::system_clock::now().time_since_epoch().count();
    shuffle(this->GridPos, (this->GridPos) + N*N, default_random_engine(seed));
    shuffle(this->GuessNum, (this->GuessNum) + N, default_random_engine(seed));
}

// ------------------------------------------------------------------------------------
// -------------------------- CONSTRUCTORS FUNCTIONS END -----------------------------
// ------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// -------------------------------- HELPER FUNCTIONS ----------------------------------
// ----------------------------------- START HERE -------------------------------------
// ------------------------------------------------------------------------------------


/*
  * Fills the empty diagonal boxes
  * As it requires no rules to fill
  * Except : there cannot be same numbers in a box
*/
void Sudoku::FillDiagonalBoxes(int idx)
{
    int start = idx*3;
    shuffle(this->GuessNum, (this->GuessNum) + N, default_random_engine(seed));
    for (int i = 0; i < 3; ++i)
    {
        for (int j = 0; j < 3; ++j)
        {
        this->Grid[start+i][start+j] = GuessNum[i*3+j];
        }
    }
}

/*
  * Generating the Sudoku
  * @return A newly created Sudoku
*/
void Sudoku::GenerateSudoku()
{
    // Filling the diagonal boxes
    for (int idx = 0; idx < 3; idx++)
        FillDiagonalBoxes(idx);

    // shuffling the GridPos to find random positions to enter the numbers
    shuffle(this->GridPos, (this->GridPos) + N*N, default_random_engine(seed));

    // shuffling the GuessNum to get random numbers to enter the grid
    shuffle(this->GuessNum, (this->GuessNum) + N, default_random_engine(seed));
    
    // Entering random numbers in the random positions in the grid
    SolveToGenerate();

    // Declaring a row and col variable
    int row, col;
    
    // Storing the solution grid in a variable to check for answer later
    for (row = 0; row < N; row++)
        for (col = 0; col < N; col++)
            SolnGrid[row][col] = Grid[row][col];
     
    // Now deleting elements according to the difficulty level
    // A variable is required to set a target of the number of elememts to be deleted
    int target;
    switch(DifficultyLevel)
    {
        case 0 :
            target = 81 - 32;
            break;
        
        case 1 :
            target = 81 - 26;
            break;
        
        case 2 :
            target = 81 - 24;
            break;
        
        case 3 :
            target = 81 - 17;
            break;
        
        default :
            target = 81 - 32;
    }
    
    // keeping a count to calculate the number of deleted elements
    int count = 0;
    int flag = 0;
    // shuffling the GridPos to get random positions to delete the numbers
    shuffle(this->GridPos, (this->GridPos) + N*N, default_random_engine(seed));
    
    for (int i = 0; i < N*N; i++)
    {
        // Selecting a row and column
        row = GridPos[i] / N;
        col = GridPos[i] % N;
        if (flag == 1 && Grid[row][col] == empty)
        {
            Grid[row][col] = SolnGrid[row][col];
            if(i == N*N - 1)
                i = 0;
            else
                i++;
            flag = 0;
            count--;
        }

        // Selecting a row and column
        row = GridPos[i] / N;
        col = GridPos[i] % N;

        // Storing the value of that coordinate
        // In a temporary variable
        int temp = Grid[row][col];
        if (temp != empty && flag == 0)
        {
            cout <<" i : " << i << " , ";
            cout<<"GridPos : " << GridPos[i];
            cout<<" , " << "Count : "<< count <<endl;

            Grid[row][col] = empty;
            int soln = 0;
            CountSoln(soln);

            // If number of soln are not equal to 1
            // We put that deleted number back
            if (soln != 1)
                Grid[row][col] = temp;
            // Otherwise increase the count of deleted elements
            else
                count++;
        }
        // If we achieve our target of deleted numbers
        // Congratulations! Our sudoku is generated
        if (count == target)
            break;
        // Or if we reach the last GridPos we go back the starting GridPos
        else if (i == (N*N - 1))
        {
            i = 0;
            flag = 1;
        }
    }
}

bool Sudoku::SolveToGenerate()
{
    int row = 0;
    int col = 0;
    if (!FindRandomEmptyLocation(row,col))
        return true;
    // Try finding the solution with every number possible
    for (int i = 0; i < N; i++)
    {
        int num = GuessNum[i];
        if (isGridSafe(row, col, num))
        {
            Grid[row][col] = num;
            if (SolveToGenerate())
                return true;
            Grid[row][col] = empty;
        }
    }
    return false;
}

/*
  * Finds a random empty location in the grid
  * @param takes in the grid and references the row and column variables
  * @return true if there is an empty space and false if the sudoku is complete
*/
bool Sudoku::FindRandomEmptyLocation(int &row, int &col)
{
    for (int i = 0; i < N*N; i++)
    {
        int gridNum = GridPos[i];
        // Lets assume the coordinates like (0,0) , (0,1) ... (8,8)
        // Then every row index will be the grid number divided by N
        row = gridNum / N;
        // And every column index will be the grid number modulo N
        col = gridNum % N;
        if (gridNum > 80)
        {
            cout << "ERRORRRRRRRRRRRRR";
            exit(0);
        }
        if (Grid[row][col] == empty)
            return true;
    }
    return false;
}

void Sudoku::CountSoln(int &soln)
{
    // Initialsing the row and column
    int row = 0;
    int col = 0;
    
    // Find the next empty square to insert numbers
    // If no empty square can be found, the sudoku is solved and hence increase the number of solutions by 1
    if (!FindEmptyLocation(row, col))
    {
        ++soln;
        return ;
    }
    
    // Try finding the number of solutions with every number possible
    // The loop terminates if we find more than one solutions or the loop reaches its end
    for (int num = 1; num <= N && soln <= 1; num++)
    {
        if (isGridSafe(row, col, num))
        {
            Grid[row][col] = num;
            CountSoln(soln);
        }
        Grid[row][col] = empty;
    }
}

void Sudoku::GetDifficulty(int level)
{
    DifficultyLevel = level;
}

// ------------------------------------------------------------------------------------
// ------------------------------- SUDOKU GENERATION ----------------------------------
// -------------------------------- HELPER FUNCTIONS ----------------------------------
// ------------------------------------ END HERE --------------------------------------
// ------------------------------------------------------------------------------------

// ------------------------------------------------------------------------------------
// ------------------------ SOLVING SUDOKU HELPER FUNCTIONS ---------------------------
// ----------------------------------- START HERE -------------------------------------
// ------------------------------------------------------------------------------------

/*
  * Finds the next empty slot/square in the grid
  * @param takes in the grid and references the row and column variables
  * @return true if there is an empty space and false if the sudoku is complete
 */

bool Sudoku::FindEmptyLocation(int &row, int &col)
{
    for (row = 0; row < N; row++)
        for (col = 0; col < N; col++)
            if (Grid[row][col] == empty)
                return true;
    
    return false;
}

/*
  * Checks if the given number is used in the row
  * @param sudoku grid, row index and the number
  * @return true if it is used, false otherwise
 */
bool Sudoku::UsedInRow (int row, int num)
{
    for (int col = 0; col < N; col++)
        if (Grid[row][col] == num)
            return true;
    return false;
}

/*
  * Checks if the given number is used in the column
  * @param sudoku grid, column index and the number
  * @return true if it is used, false otherwise
 */
bool Sudoku::UsedInColumn (int col, int num)
{
    for (int row = 0; row < N; row++)
        if (Grid[row][col] == num)
            return true;
    return false;
}

/*
  * Checks if the given number is used in the box
  * @param sudoku grid, row and column indices and the number
  * @return true if it is used, false otherwise
 */
bool Sudoku::UsedInBox (int row, int col, int num)
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
        if (Grid[row][col] == num)
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

bool Sudoku::isGridSafe(int row, int col, int num)
{
    return !UsedInRow(row, num) && !UsedInColumn(col, num) && !UsedInBox(row, col, num);
}

// ------------------------------------------------------------------------------------
// SOLVING SUDOKU HELPER FUNCTIONS
// END HERE
// ------------------------------------------------------------------------------------

bool Sudoku::SolveSudoku()
{
    // Initialsing the row and column
    int row = 0;
    int col = 0;
    int num;
    
    // Find the next empty square to insert numbers
    // If no empty square can be found, the sudoku is solved
    if (!FindEmptyLocation(row, col))
       return true;
    
    // Try finding the solution with every number possible
    for (int i = 0; i <= N; i++)
    {
        num = i;
        if (isGridSafe(row, col, num))
        {
            Grid[row][col] = num;
            if (SolveSudoku())
                return true;
            Grid[row][col] = empty;
        }
    }
    return false;
}

void Sudoku::PrintSudoku()
{
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            cout << to_string(Grid[i][j]) + "  ";
            if ((j+1)%3 == 0)
                cout << "|  ";
        }
        cout << "\n";
        if ((i+1)%3 == 0)
            cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    }
    cout << "\n";
}

// ------------------------------------------------------------------------------------
// ------------------------------ CARDINALITY FUNCTIONS -------------------------------
// ------------------------------------ START HERE ------------------------------------
// ------------------------------------------------------------------------------------

void Sudoku::CalculateDifficulty()
{
    int DiffGrid[N][N];
    int sum = 0;
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            // If a number is present at that spot,
            // The difficulty of that spot is 0
            if (Grid[i][j] != empty)
                DiffGrid[i][j] = 0;
            else
            {
                // Temp is the difficulty level of that coordinate
                int temp = 0;
                for (int k = 1; k <= N; k++)
                    if (isGridSafe(i, j, k))
                        temp += 1;
                DiffGrid[i][j] = temp;
                sum += temp;
            }
        }
    }
    cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    for (int i = 0; i < N; i++)
    {
        for (int j = 0; j < N; j++)
        {
            cout << to_string(DiffGrid[i][j]) + "  ";
            if ((j+1)%3 == 0)
                cout << "|  ";
        }
        cout << "\n";
        if ((i+1)%3 == 0)
            cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    }
    cout << "\n";
    cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    cout << "_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _\n";
    float avg = sum / 55.0;
    cout << "Sum : " << sum << endl;
    cout << " Avg : " << avg << endl;

}

// ------------------------------------------------------------------------------------
// ------------------------------ CARDINALITY FUNCTIONS -------------------------------
// ------------------------------------ END HERE --------------------------------------
// ------------------------------------------------------------------------------------
