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
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    
    //Pause.hidden = NO;
    //PauseMenu.hidden = YES;
    
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
