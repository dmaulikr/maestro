//
//  TitleLayer.m
//  Daleks
//
//  Created by Matthew McGlincy on 3/26/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "GameScene.h"
#import "TitleLayer.h"

@implementation TitleLayer

-(id)init { 
    self = [super init];                                           
    if (self != nil) {    
        self.isTouchEnabled = YES;
        CCSprite *backgroundImage = [CCSprite spriteWithFile:@"title_screen.png"];
        
        CGSize screenSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:CGPointMake(screenSize.width/2, screenSize.height/2)];
        [self addChild:backgroundImage z:0 tag:0];
        
    }
    return self;
}

#pragma mark - touch handlers

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[GameScene node]]];
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

@end