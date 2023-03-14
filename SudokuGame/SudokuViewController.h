//
//  SudokuViewController.h
//  SudokuGame
//
//  Created by Yash Jain on 2/16/23.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIButton.h>


NS_ASSUME_NONNULL_BEGIN

@interface SudokuViewController : UIViewController
{
    // Main Buttons
    IBOutlet UIButton *Pause;
    IBOutlet UIButton *Resume;
    IBOutlet UIButton *Home;
    IBOutlet UIView *PauseMenu;
    
    // Bottom buttons
    IBOutlet UIButton *Eraser;
    IBOutlet UIButton *Hint;
    
    
    // ALL the sudoku numbers
    IBOutlet UIButton *number1;
    IBOutlet UIButton *number2;
    IBOutlet UIButton *number3;
    IBOutlet UIButton *number4;
    IBOutlet UIButton *number5;
    IBOutlet UIButton *number6;
    IBOutlet UIButton *number7;
    IBOutlet UIButton *number8;
    IBOutlet UIButton *number9;
    
    // Timer control
    IBOutlet UILabel *timer;
}
@end

NS_ASSUME_NONNULL_END
