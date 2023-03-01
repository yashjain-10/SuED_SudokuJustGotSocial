//
//  SudokuViewController.m
//  SudokuGame
//
//  Created by Yash Jain on 2/16/23.
//

#import "SudokuViewController.h"
#import "TimerManager.h"
#import "Sudoku.h"
//#import "SudokuLogic.mm"

@interface SudokuViewController ()

@property (nonatomic,strong) NSTimer *timerVar;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@end

@implementation SudokuViewController

NSString *number;
UIButton *button = nil;

- (void)setButtonTitles
{
    [number1 setTitle:@"1" forState:UIControlStateNormal];
    [number2 setTitle:@"2" forState:UIControlStateNormal];
    [number3 setTitle:@"3" forState:UIControlStateNormal];
    [number4 setTitle:@"4" forState:UIControlStateNormal];
    [number5 setTitle:@"5" forState:UIControlStateNormal];
    [number6 setTitle:@"6" forState:UIControlStateNormal];
    [number7 setTitle:@"7" forState:UIControlStateNormal];
    [number8 setTitle:@"8" forState:UIControlStateNormal];
    [number9 setTitle:@"9" forState:UIControlStateNormal];
}


// Temporary function : TO BE DELETED
- (void)tempfunc
{
    for (int i = 0; i < 30; ++i)
    {
        int randomNumber = arc4random_uniform(89) + 1;
        UIButton *tempbutton = [self.view viewWithTag:randomNumber];
        [tempbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        randomNumber = arc4random_uniform(9) + 1;
        [tempbutton setTitle:[NSString stringWithFormat:@"%d", randomNumber] forState:UIControlStateNormal];
    }
}
//static NSTimeInterval elapsedTime = 0.0;

- (IBAction)goHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.timerVar invalidate];
    
}

// For Timer Functions
- (void)timerFn
{
    //elapsedTime += 1.0;
    NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
    self.elapsedTime = currentTime - self.startTime;
    int minutes = (int)self.elapsedTime / 60;
    int seconds = (int)self.elapsedTime % 60;
    timer.text = [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

- (IBAction)pauseButtonPressed:(id)sender {
    [self.timerVar invalidate];
    self->PauseMenu.hidden = NO;
}

- (IBAction)resumeButtonPressed:(id)sender {
    self.startTime = [NSDate timeIntervalSinceReferenceDate] - self.elapsedTime;
    self.timerVar = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFn) userInfo:nil repeats:YES];
    self->PauseMenu.hidden = YES;
}



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

- (IBAction)addtoBoard:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        // When another button is pressed,
        // Color the previous selection white
        if (button != nil)
            [self changeColors:[UIColor whiteColor]];
        
        button = (UIButton *)sender;
        [self changeColors:[UIColor lightGrayColor]];
    }
}


- (IBAction)numberSelector:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *numberbutton = (UIButton *)sender;
        NSLog(@"%@", numberbutton.currentTitle);
        //number = @"9";
        number = numberbutton.currentTitle;
        
        if ([button.titleLabel textColor] != [UIColor blackColor])
        {
            [button setTitle:number forState:UIControlStateNormal];
        }
    }
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    self->PauseMenu.hidden = YES;
    
    // Do any additional setup after loading the view.
    [self setButtonTitles];
    
    [self tempfunc];
    
    
    [Home addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    
    //elapsedTime = 0.0;
    //self.timerVar = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFn) userInfo:nil repeats:YES];
    
    self.startTime = [NSDate timeIntervalSinceReferenceDate];
    self.timerVar = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFn) userInfo:nil repeats:YES];
    
    Sudoku *sudoku = [[Sudoku alloc] init];
    [sudoku PrintSudoku];
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
