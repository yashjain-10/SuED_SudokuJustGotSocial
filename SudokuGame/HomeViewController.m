//
//  HomeViewController.m
//  SudokuGame
//
//  Created by Yash Jain on 2/6/23.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (IBAction)playOnlineButton:(id)sender
{
    self->playOnlineMenu.hidden = NO;
}

- (IBAction)CompetitiveButton:(id)sender
{
    self->playOnlineMenu.hidden = YES;
}

- (IBAction)CollabButton:(id)sender
{
    self->playOnlineMenu.hidden = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self->playOnlineMenu.hidden = YES;
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
