//
//  GameScene.m
//  Molyjam
//
//  Created by Matthew McGlincy on 3/30/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "BackgroundLayer.h"
#import "GameLayer.h"
#import "GameManager.h"
#import "GameScene.h"
#import "GameSoundManager.h"
#import "GameClock.h"
#import "HUDLayer.h"

@interface GameScene()
@property (nonatomic, retain) NSString *background;
@property (nonatomic) int music;
@property (nonatomic) NSTimeInterval maestroAudioStartTime;   
@property (nonatomic) BOOL  maestroAudioStarted;
@end

@implementation GameScene

@synthesize levelNum = _levelNum;
@synthesize background = _background;
@synthesize music = _music;
@synthesize maestroAudioStartTime = _maestroAudioStartTime;
@synthesize maestroAudioStarted = _maestroAudioStarted;
@synthesize maxTime = _maxTime;
@synthesize tearsNeeded = _tearsNeeded;

- (void)dealloc
{
    [_background release];
    [super dealloc];
}

+ (GameScene *)nodeWithLevelNum:(NSInteger)levelNum
{
    GameScene *scene = [[[GameScene alloc] initWithLevelNum:levelNum] autorelease];
    return scene;
}

- (id)initWithLevelNum:(NSInteger)levelNum
{
    self = [super init];
    if (self != nil) {
        self.levelNum = levelNum;
        [self configureForLevelNum];
        
        // set up the GameManager for this level
        GameManager *gameManager = [GameManager sharedInstance];
        [gameManager resetForGameScene:self];

        BackgroundLayer *backgroundLayer = [BackgroundLayer nodeWithBackground:self.background];
        [self addChild:backgroundLayer z:0];  
        
        HUDLayer *hudLayer = [HUDLayer node];       
        [self addChild:hudLayer z:1];                         
        
        GameLayer *gameLayer = [GameLayer nodeWithLevelNum:levelNum];
        [self addChild:gameLayer z:0];                         
    }
    return self;    
}

- (id)init {
    return [self initWithLevelNum:1];
}

- (void)configureForLevelNum
{
    switch (self.levelNum) {
        case 0:
            self.background = @"level1_background.png";
            self.music = 0;
            self.maxTime = 99;
            self.tearsNeeded = 10;
            break;
        case 1:
            self.background = @"level2_background.png";
            self.music = 1;
            self.maxTime = 75;
            self.tearsNeeded = 20;
            break;
        case 2:
            self.background = @"level3_background.png";
            self.music = 2;
            self.maxTime = 50;
            self.tearsNeeded = 30;
            break;            
        default:
            break;
    }
}

- (void)onEnter
{
    [super onEnter];
    
    //Fade out the intro music if it's playing
    //currently buggy, disabling
    //[[GameSoundManager sharedInstance] fadeOutMusic];
    [[GameSoundManager sharedInstance].soundEngine stopBackgroundMusic];
    [[GameSoundManager sharedInstance] stopMaestro];
    
    [GameSoundManager sharedInstance].nextMaestroTrack = self.music;
    [GameSoundManager sharedInstance].loopMaestroTrack = YES;
    //Wait 3 seconds before playing maestro music
    _maestroAudioStarted = NO;
    _maestroAudioStartTime = [[GameClock sharedInstance] currentTime] + 3;
    
    [[GameSoundManager sharedInstance].soundEngine playEffect:SOUND_CRYING pitch:1.0f pan:0.0f gain:1.0f];
    
    [self scheduleUpdate];
}

-(void) update:(ccTime) delta
{
    // update global singletons
    [[GameClock sharedInstance] update:delta];
    
    //Check timers
    if (!_maestroAudioStarted &&
        [[GameClock sharedInstance] currentTime] > _maestroAudioStartTime) {
        NSLog(@"Starting Maestro music.");
        [[GameSoundManager sharedInstance] playMaestro];
        _maestroAudioStarted = YES;
    }
}

@end
