//
//  VictoryLayer.m
//  Maestro
//
//  Created by Matthew McGlincy on 4/1/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "Constants.h"
#import "TitleScene.h"
#import "VictoryLayer.h"
#import "VictoryMaestro.h"
#import "GameSoundManager.h"

@implementation VictoryLayer

-(id) init
{
    self = [super init];
	if (self) {
        self.isTouchEnabled = YES;
        
		CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"victory_background.png"];
        backgroundImage.position = CGPointMake(winSize.width/2, winSize.height/2);
        [self addChild:backgroundImage z:-1 tag:0];

        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Victory!!!" fontName:FONT_NAME fontSize:60.0];
        label.position = ccp(winSize.width / 2, winSize.height / 2 + 200);
        [self addChild:label];   
        
        VictoryMaestro *maestro = [VictoryMaestro node];
        maestro.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:maestro];
        
        [[GameSoundManager sharedInstance].soundEngine playBackgroundMusic:@"victory_theme.mp3"];
    }
    return self;
}

#pragma mark - touch handlers

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //    [[GameManager sharedInstance] reset];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[TitleScene node]]];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end
