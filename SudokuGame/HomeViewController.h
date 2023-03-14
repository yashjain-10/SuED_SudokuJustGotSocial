//
//  HomeViewController.h
//  SudokuGame
//
//  Created by Yash Jain on 2/6/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController
{
    IBOutlet UIView *playOnlineMenu;
    
    IBOutlet UIButton *PlayOnline;
    IBOutlet UIButton *Competitive;
    IBOutlet UIButton *Collaborative;
}
@end

NS_ASSUME_NONNULL_END
