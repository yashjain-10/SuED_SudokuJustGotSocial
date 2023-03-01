//
//  TimerManager.h
//  SudokuGame
//
//  Created by Yash Jain on 2/28/23.
//

#ifndef TimerManager_h
#define TimerManager_h

// TimerManager.h

#import <Foundation/Foundation.h>

@interface TimerManager : NSObject

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic) BOOL timerRunning;

+ (instancetype)sharedManager;

@end


#endif /* TimerManager_h */
