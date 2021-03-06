//
//  ViolinCase.m
//  Maestro
//
//  Created by Matthew McGlincy on 3/31/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "Physics.h"
#import "ViolinCase.h"

@implementation ViolinCase

- (id)init
{
    self = [super initWithFile:@"violin_case.png"];
    if (self) {
    }
    return self;
}

- (void)addToPhysics
{
    int num = 4;
    CGPoint verts[] = {
        ccp(-1 * self.contentSize.width / 2, -1 * self.contentSize.height / 2),
        ccp(-1 * self.contentSize.width / 2, self.contentSize.height / 2),
        ccp(self.contentSize.width / 2, self.contentSize.height / 2),
        ccp(self.contentSize.width / 2, -1 * self.contentSize.height / 2),
    };
    
    cpBody *body = cpBodyNew(INFINITY, INFINITY);
    
    body->p = self.position;
    cpBodySetMass(body, MAXFLOAT);
    cpBodySetMoment(body, MAXFLOAT);
    
    Physics *physics = [Physics sharedInstance];
    //cpSpaceAddBody(physics.space, body);
    
    cpShape* shape = cpPolyShapeNew(body, num, verts, CGPointZero);
    shape->e = 0.5f; shape->u = 0.5f;
    shape->collision_type = kCollisionTypeViolinCase;
    cpSpaceAddShape(physics.space, shape);
    
    [self setPhysicsBody:body];    
}

@end
