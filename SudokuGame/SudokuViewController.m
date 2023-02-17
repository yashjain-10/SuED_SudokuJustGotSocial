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

- (IBAction)goHome:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}

- (IBAction)addtoBoard:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *button = (UIButton *)sender;
        NSString *title = button.currentTitle;
        // Do something with the title
        if (title == nil)
        {
            [button setTitle:@"9" forState:UIControlStateHighlighted];
        }
    }
}

- (IBAction)boardTapAction:(id)sender
{
    [self addtoBoard:sender];
}



- (IBAction)numberSelector:(id)sender
{
    
    
}
    
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [Home addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];
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
