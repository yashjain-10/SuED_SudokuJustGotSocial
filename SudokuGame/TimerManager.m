//
//  TimerManager.m
//  SudokuGame
//
//  Created by Yash Jain on 2/28/23.
//

#import <Foundation/Foundation.h>

// TimerManager.m

#import "TimerManager.h"

@implementation TimerManager

+ (instancetype)sharedManager {
    static TimerManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

@end
