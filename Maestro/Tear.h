//
//  Tear.h
//  TheMaestro
//
//  Created by Matthew McGlincy on 3/31/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameObject.h"
#import "PhysicsSprite.h"

@interface Tear : PhysicsSprite
- (void)addToPhysics;
- (void)randomPush;
- (void)hitViolinCase;

@end

