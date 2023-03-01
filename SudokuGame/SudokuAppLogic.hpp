//
//  SudokuAppLogic.hpp
//  SudokuGame
//
//  Created by Yash Jain on 2/24/23.
//

#ifndef SudokuAppLogic_hpp
#define SudokuAppLogic_hpp

#include <stdio.h>
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



#endif /* SudokuAppLogic_hpp */
