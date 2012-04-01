//
//  Tear.m
//  TheMaestro
//
//  Created by Matthew McGlincy on 3/31/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "GameClock.h"
#import "GameManager.h"
#import "GameUtils.h"
#import "Physics.h"
#import "Tear.h"

#define MIN_LIFE 4.0
#define MAX_LIFE 10.0

@interface Tear()
@property (nonatomic) NSTimeInterval timeToDie;
@property (nonatomic) BOOL isDead;
@end

@implementation Tear

@synthesize timeToDie = _timeToDie;
@synthesize isDead = _isDead;

- (id)init
{
    self = [super initWithFile:@"tear0.png" rect:CGRectMake(0, 0, 32, 32)];
    if (self) {
        self.timeToDie = [[GameClock sharedInstance] currentTime] + [GameUtils randomTimeBetweenMin:MIN_LIFE max:MAX_LIFE];
        
        CCAnimation *anim = [CCAnimation animation];
        [anim addFrameWithFilename:@"tear1.png"];
        [anim addFrameWithFilename:@"tear2.png"];
        [anim addFrameWithFilename:@"tear3.png"];
        [anim addFrameWithFilename:@"tear4.png"];
        [anim addFrameWithFilename:@"tear5.png"];
        [anim addFrameWithFilename:@"tear6.png"];
        [anim addFrameWithFilename:@"tear7.png"];
        [anim addFrameWithFilename:@"tear8.png"];
        [anim addFrameWithFilename:@"tear0.png"];
        
        id animationAction = [CCAnimate actionWithDuration:0.5f
                                                 animation:anim
                                      restoreOriginalFrame:YES];
        id repeatAnimation = [CCRepeatForever actionWithAction:animationAction];
        [self runAction:repeatAnimation];

        
        // receive updates so we can kill ourselves
        [self scheduleUpdate];
    }
    return self;
}

- (void)addToPhysics
{
    cpBody *body = cpBodyNew(1.0f, cpMomentForCircle(1.0f, 0, 100.0f, cpvzero)); //Tear diameter = 100. Using defines was causing compiler errors here :(

    body->p = self.position;
    Physics *physics = [Physics sharedInstance];
    cpSpaceAddBody(physics.space, body);
    
    cpShape* shape = cpCircleShapeNew(body, 50.0f, CGPointZero); //Tear radius = 50
    shape->e = 0.5f; shape->u = 0.5f;
    shape->collision_type = kCollisionTypeTear;
    shape->data = self;
    cpSpaceAddShape(physics.space, shape);
    
    [self setPhysicsBody:body];    
}

- (void)randomPush
{
    CGFloat x = -200.0 + (arc4random() % 250);
    CGFloat y = 50 + (arc4random() % 100);
    cpVect j = cpv(x, y);
    //j = cpvmult(j, 100);
    cpBodyApplyImpulse(body_, j, cpvzero);
}

- (void)update:(ccTime)delay
{
    if ([[GameClock sharedInstance] currentTime] > self.timeToDie) {
        [self die];
    }
}

- (void)die
{
    self.isDead = YES;
    // have use cleanup:NO or chipmunk will crash
    [self.parent removeChild:self cleanup:YES];    
}

- (void)hitBin
{
    if (!self.isDead) {
        GameManager *manager = [GameManager sharedInstance];
        [manager playerCollectedTear];
        [self die];
    }
}
@end
