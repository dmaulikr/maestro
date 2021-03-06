//
//  ShopSign.m
//  Maestro
//
//  Created by Matthew McGlincy on 4/1/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "ShopSign.h"

@implementation ShopSign

- (id)init
{
    self = [super initWithFile:@"shop_sign_0.png"];
    if (self) {
        CCAnimation *anim = [CCAnimation animation];
        [anim addFrameWithFilename:@"shop_sign_1.png"];
        [anim addFrameWithFilename:@"shop_sign_2.png"];
        [anim addFrameWithFilename:@"shop_sign_0.png"];
        
        id animationAction = [CCAnimate actionWithDuration:1.5f
                                                 animation:anim
                                      restoreOriginalFrame:YES];
        id repeatAnimation = [CCRepeatForever actionWithAction:animationAction];
        [self runAction:repeatAnimation];
    }
    return self;
}

@end
