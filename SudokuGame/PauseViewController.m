//
//  PauseViewController.m
//  SudokuGame
//
//  Created by Yash Jain on 2/28/23.
//

#import "PauseViewController.h"

@interface PauseViewController ()



@end

@implementation PauseViewController


- (IBAction)resumeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.startTime = [NSDate date];
    
    // To get the value of startTime:
    //NSDate *startTime = self.startTime;
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
