//
//  CompetitiveViewController.m
//  SudokuGame
//
//  Created by Yash Jain on 3/14/23.
//

#import "CompetitiveViewController.h"
#import "SudokuMultiplayer.h"
#import <GameKit/GameKit.h>

//@interface CompetitiveViewController ()
@interface CompetitiveViewController ()

@property (nonatomic,strong) NSTimer *timerVar;
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval elapsedTime;

@property (nonatomic, strong) NSMutableArray *Grid;
@property (nonatomic, strong) NSMutableArray *SolnGrid;

@property (nonatomic, strong) GKMatchmakerViewController *mmvc;

@end

@implementation CompetitiveViewController


NSString *Number;
UIButton *Button = nil;

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
    UIButton *tempbutton;
    for (int i = 0; i < X*X; ++i)
    {
        int gridNum = i;
        int row = gridNum / X;
        int col = gridNum % X;
        
        if (i == 0)
            tempbutton = [self.view viewWithTag:89];
        else
            tempbutton = [self.view viewWithTag:row*10 + col];
        [tempbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        tempbutton.titleLabel.font = [UIFont systemFontOfSize:25.0];
        
        if ([_Grid[row][col] intValue] != Empty)
            [tempbutton setTitle:[NSString stringWithFormat:@"%@", _Grid[row][col]] forState:UIControlStateNormal];
    }
}

/*
 * A function for the home Button
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
 * A function for the paused Button
 * Stops the timer as well
 */
- (IBAction)pauseButtonPressed:(id)sender {
    //[self.timerVar invalidate];
    self->PauseMenu.hidden = NO;
}

/*
 * A function for the Resume Button
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
    // Adding Borders to the Button
    NSInteger tag = Button.tag;
    if (color != [UIColor whiteColor])
    {
        Button.layer.borderWidth = 2.0f;
        // Set the stroke color
        Button.layer.borderColor = [UIColor tintColor].CGColor;
    }
    else
    {
        Button.layer.borderWidth = 0.0f;
        // Set the stroke color
        Button.layer.borderColor = [UIColor whiteColor].CGColor;
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
 * that contains the same Number as the one user tapped
 * @param : The color to be used to color the row and col
 */
- (void)numberChangeColor:(UIColor *)color
{
    UIButton *tempbutton;
    NSLog(@"Button.titleLabel : %@", [Button.titleLabel text]);
    for (int i = 0; i < X*X; ++i)
    {
        int gridNum = i;
        int row = gridNum / X;
        int col = gridNum % X;
        if (i == 0)
            tempbutton = [self.view viewWithTag:89];
        else
            tempbutton = [self.view viewWithTag:row*10 + col];
        if ([tempbutton.titleLabel text]== [Button.titleLabel text] && tempbutton.tag != Button.tag)
            tempbutton.backgroundColor = color;
    }
}


/*
 * The functions to add the numbers to the board
 */
- (IBAction)addtoBoard:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        // When another Button is pressed,
        // Color the previous selection white
        if (Button != nil)
        {
            [self changeColors:[UIColor whiteColor]];
            [self numberChangeColor:[UIColor whiteColor]];
        }
        
        Button = (UIButton *)sender;
        [self changeColors:[UIColor lightGrayColor]];
        if([Button.titleLabel text] != nil)
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
        NSLog(@"%@", numberbutton.currentTitle);
        //Number = @"9";
        Number = numberbutton.currentTitle;
        
        if ([Button.titleLabel textColor] != [UIColor blackColor])
        {
            [Button setTitle:Number forState:UIControlStateNormal];
            [Button setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
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
        if ([Button.titleLabel text] != nil && [Button.titleLabel textColor] != [UIColor blackColor])
        {
            NSNumber *xyz = nil;
            [Button setTitle:[NSString stringWithFormat:@"%@", xyz] forState:UIControlStateNormal];
            [Button setTitle:@" " forState:UIControlStateNormal];
        }
    }
}

/*
 * Multiplayer function
 * Aythenticates the user with Game Center
 * Finds a match for the user
 * @param : void
 * @return :    0 if authentication failed
 *              1 if match making failed
 *              2 if match found
 */
- (void)multiPlayerFn
{
    [GKLocalPlayer localPlayer].authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil)
        {
            // Show the Game Center login view controller
            [self presentViewController:viewController animated:YES completion:nil];
        }
        else if ([GKLocalPlayer localPlayer].authenticated)
        {
            // The player is authenticated and ready to play
            NSLog(@"Player authenticated");
            
            // Create a match request
            GKMatchRequest *request = [[GKMatchRequest alloc] init];
            request.minPlayers = 2;
            request.maxPlayers = 2;
            request.defaultNumberOfPlayers = 2;
            
            // Create a matchmaker view controller
            [[GKMatchmaker sharedMatchmaker] findMatchForRequest:request withCompletionHandler:^(GKMatch *match, NSError *error) {
                if (error) {
                    NSLog(@"Error finding match: %@", error);
                } else {
                    NSLog(@"Match found with %lu players", (unsigned long)self.match.players.count);
                }
            }];

            self.mmvc = [[GKMatchmakerViewController alloc] initWithMatchRequest:request];
            self.mmvc.matchmakerDelegate = self;
            
            // View the view controller
            [self presentViewController:self.mmvc animated:YES completion:nil];
        }
        else
        {
            // Authentication failed
            [self dismissViewControllerAnimated:YES completion:nil];
            //[self.timerVar invalidate];
            NSLog(@"Authentication failed: %@", error);
        }
    };
    
}

- (void)matchmakerViewControllerWasCancelled:(GKMatchmakerViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFailWithError:(NSError *)error
{
    NSLog(@"Matchmaking failed: %@", error.localizedDescription);
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)matchmakerViewController:(GKMatchmakerViewController *)viewController didFindMatch:(GKMatch *)_match
{
    NSLog(@"Match found with %lu players", (unsigned long)self.match.players.count);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    NSError *error = nil;
    NSString *playerUUID = [[NSUUID UUID] UUIDString];
    NSData *data = [playerUUID dataUsingEncoding:NSUTF8StringEncoding];
    BOOL success = [self.match sendDataToAllPlayers:data withDataMode:GKMatchSendDataReliable error:&error];
    if (!success) {
        NSLog(@"Error sending data: %@", error);
    }
    
    NSString *playerID;
    for (GKPlayer *player in _match.players)
    {
        playerID = player.gamePlayerID;
        NSLog(@"Player ID: %@", playerID);
    }
    
    // Check for Player 1
    NSLog(@"Players count : %lu", _match.players.count);
    
    NSString *localPlayerID = [GKLocalPlayer localPlayer].gamePlayerID;
    NSLog(@"Local player ID: %@", localPlayerID);


    
    // Player 1 generates the sudoku and sends it to player 2
    if (localPlayerID <= playerID)
    {
        self->PauseMenu.hidden = NO;
        tester.text = @"Generating Sudoku";
        
        // Generate a sudoku
        SudokuMultiplayer *sudoku = [[SudokuMultiplayer alloc] init];
        [sudoku GenerateSudoku];
        tester.text = @"Sudoku Generated";
        
        self.Grid = [sudoku GetFinalGrid:0];
        self.SolnGrid = [sudoku GetFinalGrid:1];
        
        // Share the puzzle with the other player
        NSData *puzzleData = [NSKeyedArchiver archivedDataWithRootObject:self.Grid requiringSecureCoding:NO error:nil];
        NSError *error;
        
        NSArray *player2 = @[_match.players[1]]; // send the puzzle to player 2
        [self.match sendData:puzzleData toPlayers:player2 dataMode:GKMatchSendDataReliable error:&error];
        if (error) {
            NSLog(@"Error sending puzzle: %@", error);
        }
        else
        {
            tester.text = @"Sudoku Sent";
            self->PauseMenu.hidden = YES;
        }
        
        // Load the sudoku
        [self sudokuLoad];
        
        // Starts the time
        self.startTime = [NSDate timeIntervalSinceReferenceDate];
        self.timerVar = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFn) userInfo:nil repeats:YES];
    }
    else
    {
        NSLog(@"Waiting for Data from Player 1");
    }
    
    CompetitiveViewController *compVC = [[CompetitiveViewController alloc] initWithNibName:@"CompetitiveViewController" bundle:nil];
    compVC.match = _match;
    compVC.Grid = _Grid;
    compVC.SolnGrid = _SolnGrid;
    [self.navigationController pushViewController:compVC animated:YES];
    
    
}

- (void)match:(GKMatch *)match didReceiveData:(NSData *)data fromPlayer:(GKPlayer *)player {
    
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Received data: %@ from player: %@", receivedString, player.displayName);

    // Unarchive the puzzle data
    NSString *playerID;
    for (GKPlayer *player in _match.players)
    {
        playerID = player.teamPlayerID;
        NSLog(@"Player ID: %@", playerID);
    }
    
    // Check for Player 1
    NSLog(@"Players count : %lu", _match.players.count);
    
    NSString *localPlayerID = [GKLocalPlayer localPlayer].teamPlayerID;
    NSLog(@"Local player ID: %@", localPlayerID);
    
    if (localPlayerID >= playerID)
    {
        NSMutableArray *grid = [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:data error:nil];
        
        _Grid = grid;
        NSLog(@"Puzzle data received");
        [self sudokuLoad];
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Hiding thr pause menu in the beginning
    self->PauseMenu.hidden = YES;
    
    // Setting the nutton titles of the bottom row
    [self setButtonTitles];
    
    // Calling multiplayerfn
    [self multiPlayerFn];
    
    // Integrating the sudoku to the board
    //[self sudokuLoad];
    
    // Home Button
    [Home addTarget:self action:@selector(goHome:) forControlEvents:UIControlEventTouchUpInside];

}


@end
