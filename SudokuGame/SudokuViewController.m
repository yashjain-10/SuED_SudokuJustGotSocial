//
//  SudokuViewController.m
//  SudokuGame
//
//  Created by Yash Jain on 2/16/23.
//

#import "SudokuViewController.h"

@interface SudokuViewController ()


@end

@implementation SudokuViewController

NSString *number;

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

- (void)accessButtons
{
    UIButton *tempbutton = [self.view viewWithTag:80];
    [tempbutton setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction)goHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)addtoBoard:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *coord = (UIButton *)sender;
        NSString *title = coord.currentTitle;
        // Do something with the title
        if (title == nil)
        {
            [coord setTitle:number forState:UIControlStateHighlighted];
        }
    }
}

- (IBAction)boardTapAction:(id)sender
{
    [self addtoBoard:sender];
}

UIButton *button = nil;

- (IBAction)buttonTapped:(id)sender
{
    button = (UIButton *)sender;
    [button setBackgroundColor:[UIColor blackColor]];
}


- (IBAction)numberSelector:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *numberbutton = (UIButton *)sender;
        NSLog(@"%@", numberbutton.currentTitle);
        //number = @"9";
        number = numberbutton.currentTitle;
        
        if (button != nil)
        {
            [button setTitle:number forState:UIControlStateNormal];
        }
    }
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setButtonTitles];
    
    [self accessButtons];
    
    [Home addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
    
    //[Tester addTarget:self action:@selector(numberSelector:) forControlEvents:UIControlEventTouchUpInside];
    
    

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
