//
//  PauseViewController.h
//  SudokuGame
//
//  Created by Yash Jain on 2/28/23.
//

#import <UIKit/UIKit.h>
#import "TimerManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface PauseViewController : UIViewController
{
    IBOutlet UIButton *resume;
}
@property (nonatomic, strong) NSDate *startTime;

@end

NS_ASSUME_NONNULL_END
