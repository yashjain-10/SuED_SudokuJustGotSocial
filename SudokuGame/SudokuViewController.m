//
//  SudokuViewController.m
//  SudokuGame
//
//  Created by Yash Jain on 2/16/23.
//

#import "SudokuViewController.h"
#import "TimerManager.h"
#import "Sudoku.h"
#import "WinViewController.h"

@interface SudokuViewController ()

@property (nonatomic,strong) NSTimer *timerVar;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@property (nonatomic, assign) NSMutableArray *Grid;
@property (nonatomic, strong) NSMutableArray *SolnGrid;

@end

@implementation SudokuViewController

NSString *number;
UIButton *button = nil;
int mistakesCount = 0;
int hintCount = 0;

- (void)setButtonTitles
{
    [number1 setTitle:@"1" forState:UIControlStateNormal];
    number1.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number2 setTitle:@"2" forState:UIControlStateNormal];
    number2.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number3 setTitle:@"3" forState:UIControlStateNormal];
    number3.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number4 setTitle:@"4" forState:UIControlStateNormal];
    number4.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number5 setTitle:@"5" forState:UIControlStateNormal];
    number5.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number6 setTitle:@"6" forState:UIControlStateNormal];
    number6.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number7 setTitle:@"7" forState:UIControlStateNormal];
    number7.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number8 setTitle:@"8" forState:UIControlStateNormal];
    number8.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    [number9 setTitle:@"9" forState:UIControlStateNormal];
    number9.titleLabel.font = [UIFont systemFontOfSize:24.0];
}



/*
 * A function to load the sudoku into the table
 */
- (void)sudokuLoad
{
    Sudoku *sudoku = [[Sudoku alloc] init];
    [sudoku GenerateSudoku];
    _Grid = [sudoku GetFinalGrid];
    
    _SolnGrid = [sudoku GetSolnGrid];
    
    UIButton *tempbutton;
    for (int i = 0; i < N*N; ++i)
    {
        int gridNum = i;
        int row = gridNum / N;
        int col = gridNum % N;
        
        if (i == 0)
            tempbutton = [self.view viewWithTag:89];
        else
            tempbutton = [self.view viewWithTag:row*10 + col];
        [tempbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempbutton.titleLabel.font = [UIFont systemFontOfSize:25.0];
        
        if ([_Grid[row][col] intValue] != empty)
            [tempbutton setTitle:[NSString stringWithFormat:@"%@", _Grid[row][col]] forState:UIControlStateNormal];
    }
    [sudoku PrintSudoku:0];
}

/*
 * A function for the home button
 * Takes the user back home
 */
- (IBAction)goHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.timerVar invalidate];
    
}

/*
 * Timer Function to calculate the elapsed time of the sudoku
 */
- (void)timerFn
{
    //elapsedTime += 1.0;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    self.elapsedTime = currentTime - self.startTime;
    int minutes = (int)self.elapsedTime / 60;
    int seconds = (int)self.elapsedTime % 60;
    timer.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

/*
 * A function for the paused button
 * Stops the timer as well
 */
- (IBAction)pauseButtonPressed:(id)sender {
    [self.timerVar invalidate];
    self->PauseMenu.hidden = NO;
}

/*
 * A function for the Resume button
 * Resumes the timer as well
 */
- (IBAction)resumeButtonPressed:(id)sender {
    self.startTime = [NSDate timeIntervalSinceReferenceDate] - self.elapsedTime;
    self.timerVar = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFn) userInfo:nil repeats:YES];
    self->PauseMenu.hidden = YES;
}


/*
 * A function to change the colors of the row and column
 * of the box selected
 * Also responsible for undoing the same function
 * @param : the color to be used to change the color of the boxes
 */
- (void)changeColors:(UIColor *)color
{
    // Adding Borders to the button
    NSInteger tag = button.tag;
    if (color != [UIColor whiteColor])
    {
        button.layer.borderWidth = 2.0f;
        // Set the stroke color
        button.layer.borderColor = [UIColor tintColor].CGColor;
    }
    else
    {
        button.layer.borderWidth = 0.0f;
        // Set the stroke color
        button.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    if (tag == 89)
        tag = 0;
    
    UIButton *toColor = nil;
    // Coloring Column
    for (NSInteger i = tag % 10; i <= 88; i += 10)
    {
        if (i == 0)
        {
            toColor = [self.view viewWithTag:89];
            toColor.backgroundColor = color;
        }
        else
        {
            toColor = [self.view viewWithTag:i];
            toColor.backgroundColor = color;
        }
    }
    // Coloring Row
    for (NSInteger i = tag - (tag % 10); i % 10 <= 8; i++)
    {
        if (i == 0)
        {
            toColor = [self.view viewWithTag:89];
            toColor.backgroundColor = color;
        }
        else
        {
            toColor = [self.view viewWithTag:i];
            toColor.backgroundColor = color;
        }
    }
}

/*
 * A function to change the color of all the boxes
 * that contains the same number as the one user tapped
 * @param : The color to be used to color the row and col
 */
- (void)numberChangeColor:(UIColor *)color
{
    UIButton *tempbutton;
    for (int i = 0; i < N*N; ++i)
    {
        int gridNum = i;
        int row = gridNum / N;
        int col = gridNum % N;
        if (i == 0)
            tempbutton = [self.view viewWithTag:89];
        else
            tempbutton = [self.view viewWithTag:row*10 + col];
        if ([tempbutton.titleLabel text]== [button.titleLabel text] && tempbutton.tag != button.tag && ![[tempbutton.titleLabel text] isEqualToString:@" "])
            tempbutton.backgroundColor = color;
    }
}

/*
 * Check for mistake
 * @param : Button that was pressed
 */
- (void)CheckForMistake
{
    NSInteger tag = button.tag;
    int row = 0;
    int col = 0;
    if (tag != 89)
    {
        row = (int)tag / 10;
        col = (int)tag % 10;
    }
    if ([NSString stringWithFormat:@"%@", number] != [NSString stringWithFormat:@"%@", _SolnGrid[row][col]])
    {
        mistakesCount++;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

/*
 * A function to check for completion
 * Returns true if the sudoku is completed
 */
- (bool)checkForCompletion
{
    UIButton *tempbutton;
    for (int i = 0; i < N*N; ++i)
    {
        int row = i / N;
        int col = i % N;
        
        if (i == 0)
            tempbutton = [self.view viewWithTag:89];
        else
            tempbutton = [self.view viewWithTag:row*10 + col];
            
        if ([tempbutton.titleLabel text] == nil || [tempbutton.titleLabel textColor] == [UIColor redColor] || [[tempbutton.titleLabel text]  isEqual: @" "])
            return false;
    }
    return true;
}

/*
 * The functions to add the numbers to the board
 */
- (IBAction)addtoBoard:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        // When another button is pressed,
        // Color the previous selection white
        if (button != nil)
        {
            [self changeColors:[UIColor whiteColor]];
            [self numberChangeColor:[UIColor whiteColor]];
        }
        
        button = (UIButton *)sender;
        NSLog(@"%@", button.currentTitle);
        [self changeColors:[UIColor lightGrayColor]];
        if([button.titleLabel text] != nil)
            [self numberChangeColor:[UIColor lightGrayColor]];
    }
}

/*
 * A function to select the numbers from the bottom row
 * Which gets further added to the board
 */
- (IBAction)numberSelector:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *numberbutton = (UIButton *)sender;
        //NSLog(@"%@", numberbutton.currentTitle);
        //number = @"9";
        number = numberbutton.currentTitle;
        
        if ([button.titleLabel textColor] != [UIColor blackColor])
        {
            [button setTitle:number forState:UIControlStateNormal];
            [button setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
            [self CheckForMistake];
            if (mistakesCount > 3)
            {
                UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoseViewController"];
                nextViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nextViewController animated:YES completion:nil];
            }
            if ([self checkForCompletion])
            {
                [self.timerVar invalidate];
                //self -> PauseMenu.hidden = NO;
                UIViewController *nextViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WinViewController"];
                nextViewController.modalPresentationStyle = UIModalPresentationFullScreen;
                [self presentViewController:nextViewController animated:YES completion:nil];
            }
        }
    }
}


/*
 * Eraser Function
 * @param : The button who's value is to be deleted/erased
 */
- (IBAction)EraserFunction:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        if ([button.titleLabel text] != nil && [button.titleLabel textColor] != [UIColor blackColor])
        {
            NSNumber *xyz = nil;
            [button setTitle:[NSString stringWithFormat:@"%@", xyz] forState:UIControlStateNormal];
            [button setTitle:@" " forState:UIControlStateNormal];
        }
    }
}

/*
 * A hint function
 * @param : The button who's value is to be revealed
 */
- (IBAction)HintFn:(id)sender
{
    if (hintCount >= 3)
        return;
    if ([sender isKindOfClass:[UIButton class]] && [button.titleLabel textColor] != [UIColor blackColor])
    {
        int index = (int)button.tag;
        int row,col;
        if (index == 89)
        {
            row = 0;
            col = 0;
        }
        else
        {
            row = index / 10;
            col = index % 10;
        }
        [button setTitle:[NSString stringWithFormat:@"%@", _SolnGrid[row][col]] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        hintCount++;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Hiding thr pause menu in the beginning
    self->PauseMenu.hidden = YES;
    
    // Resetting the mistake and hint counters
    hintCount = 0;
    mistakesCount = 0;
    
    // Setting the nutton titles of the bottom row
    [self setButtonTitles];
    
    // Integrating the sudoku to the board
    [self sudokuLoad];
    
    // Home button
    [Home addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    
    // Starts the time
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    self.timerVar = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFn) userInfo:nil repeats:YES];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
