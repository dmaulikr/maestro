//
//  GameManager.m
//  Maestro
//
//  Created by Matthew McGlincy on 3/31/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "GameClock.h"
#import "GameManager.h"
#import "GameScene.h"

#define TICK_INTERVAL 1.0

@interface GameManager()
//@property (nonatomic) NSTimeInterval nextTimerTick;
@end

@implementation GameManager

@synthesize tearsCollectedTotal = _tearsCollectedTotal;
@synthesize tearsCollectedThisLevel = _tearsCollectedThisLevel;
@synthesize tearsNeededThisLevel = _tearsNeededThisLevel;
@synthesize purchasedItems = _purchasedItems;
@synthesize timeLeft = _timeLeft;
@synthesize nextTimerTick = _nextTimerTick;

- (void)dealloc
{
    [_purchasedItems release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (id)sharedInstance
{
    static GameManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[GameManager alloc] init];
    });
    return sharedInstance;
}

- (void)update:(ccTime)delta
{
    NSTimeInterval now = [GameClock sharedInstance].currentTime;
    if ([GameClock sharedInstance].currentTime > self.nextTimerTick) {
        self.timeLeft = MIN(0, self.timeLeft - 1);
        self.nextTimerTick = now + TICK_INTERVAL;
    }
}

- (void)reset
{
    self.tearsCollectedTotal = 0;
    self.tearsCollectedThisLevel = 0;
}

- (void)resetForGameScene:(GameScene *)scene
{
    self.tearsCollectedThisLevel = 0;
    // per level number?
    self.timeLeft = scene.maxTime;
    self.tearsNeededThisLevel = scene.tearsNeeded;
}

- (void)playerCollectedTear
{
    self.tearsCollectedTotal = self.tearsCollectedTotal + 1;
    self.tearsCollectedThisLevel = self.tearsCollectedThisLevel + 1;
}

@end
