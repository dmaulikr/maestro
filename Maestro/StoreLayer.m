//
//  StoreLayer.m
//  Maestro
//
//  Created by Matthew McGlincy on 4/1/12.
//  Copyright (c) 2012 n/a. All rights reserved.
//

#import "Constants.h"
#import "Devil.h"
#import "GameManager.h"
#import "GameScene.h"
#import "Floor.h"
#import "ShopSign.h"
#import "Store.h"
#import "StoreItem.h"
#import "StoreLayer.h"
#import "GameSoundManager.h"

@interface StoreLayer()

@property (nonatomic, retain) CCMenu *storeMenu;
@property (nonatomic, retain) CCLabelTTF *tearsLabel;
@property (nonatomic, retain) Devil *devil;

@end

@implementation StoreLayer

@synthesize devil = _devil;
@synthesize storeMenu = _storeMenu;
@synthesize tearsLabel = _tearsLabel;

- (void)dealloc
{
    [[GameManager sharedInstance] removeObserver:self forKeyPath:@"tearsCollectedTotal"];

    [_devil release];
    [_storeMenu release];
    [_tearsLabel release];
    [super dealloc];
}

-(id)init { 
    self = [super init];                                           
    if (self != nil) {       
        self.isTouchEnabled = YES;
        
        // background
        CCSprite *backgroundImage;
        backgroundImage = [CCSprite spriteWithFile:@"store_background.png"];        
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        [backgroundImage setPosition:
         CGPointMake(winSize.width/2, winSize.height/2)];
        [self addChild:backgroundImage z:-1 tag:0];

        // tears remaining
        self.tearsLabel = [CCLabelTTF labelWithString:[self tearsString] fontName:FONT_NAME fontSize:28.0];
        self.tearsLabel.position =  ccp(winSize.width - self.tearsLabel.contentSize.width / 2 - 20.0, 
                                        0 + self.tearsLabel.contentSize.height / 2 + 5);
        [self addChild:self.tearsLabel z:2];

        // store sign
        ShopSign *shopSign = [ShopSign node];
        shopSign.position = ccp(250, 620);
        [self addChild:shopSign];
        
        // store menu
        [CCMenuItemFont setFontName:FONT_NAME];
        [CCMenuItemFont setFontSize:24];
        self.storeMenu = [CCMenu menuWithItems:nil];
        [self updateMenu];
        [self.storeMenu setPosition:ccp(250, 378)];        
        [self addChild:self.storeMenu];
        
        // done/continue button
        CCMenuItemFont *doneItem = [CCMenuItemFont itemWithString:@"Continue" block:^(id sender) {
            [self doneStore];
        }];
        doneItem.fontSize = 60;
        [doneItem setColor:ccc3(255, 255, 255)];
        CCMenu *doneMenu = [CCMenu menuWithItems:doneItem, nil];
        doneMenu.position = ccp(250, 98);
        [self addChild:doneMenu];
        
        GameManager *gameManager = [GameManager sharedInstance];
        [gameManager addObserver:self
                      forKeyPath:@"tearsCollectedTotal"
                         options:0
                         context:nil];

        // the devil
        self.devil = [Devil node];
        self.devil.position = ccp(900, 40 + self.devil.contentSize.height / 2);
        [self addChild:self.devil z:1];
        
        // floor
        Floor *floor = [Floor node];
        floor.position = ccp(winSize.width / 2, 0 + floor.contentSize.height / 2);
        [self addChild:floor];

        // reset music 
        [[GameSoundManager sharedInstance] stopMaestro];
        [[GameSoundManager sharedInstance].soundEngine playBackgroundMusic:@"shop_theme.mp3"];
    }
    return self;
}

- (NSString *)tearsString
{
    return [NSString stringWithFormat:@"Tears: %02d", [GameManager sharedInstance].tearsCollectedTotal];
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context
{
    if ([keyPath isEqualToString:@"tearsCollectedTotal"]) {
        self.tearsLabel.string = [self tearsString];
    } else {
        [super observeValueForKeyPath:keyPath
                             ofObject:object
                               change:change
                              context:context];
    }
}

- (void)buyStoreItem:(StoreItem *)item 
{
    GameManager *gameManager = [GameManager sharedInstance];
    if ([gameManager canAffordStoreItem:item] &&
        ![gameManager hasAlreadyPurchasedStoreItem:item]) {
        // if we can afford it and haven't bought it already
        gameManager.tearsCollectedTotal = gameManager.tearsCollectedTotal - item.price;
        [gameManager.purchasedItems addObject:item];
        
        [[GameSoundManager sharedInstance].soundEngine playEffect:SOUND_STORE_REGISTER];
        [self updateMenu];
        
        [self.devil animateForPurchase];
    }
}

- (void)updateMenu
{    
    [self.storeMenu removeAllChildrenWithCleanup:YES];
    GameManager *gameManager = [GameManager sharedInstance];
    
    for (StoreItem *storeItem in gameManager.store.items) {
        BOOL canAfford = [gameManager canAffordStoreItem:storeItem];
        BOOL alreadyPurchased = [gameManager hasAlreadyPurchasedStoreItem:storeItem];
        NSString *itemString = [NSString stringWithFormat:@"%02d - %@", storeItem.price, storeItem.name];
        CCMenuItemFont *menuItem = [CCMenuItemFont itemWithString:itemString block:^(id sender) {
            [self buyStoreItem:storeItem];
        }];
        [menuItem setColor:ccc3(255, 255, 255)];
        if (!canAfford || alreadyPurchased) {
            menuItem.isEnabled = NO;
        }
        [self.storeMenu addChild:menuItem];
    }
    [self.storeMenu alignItemsVerticallyWithPadding:30];
}

- (void)doneStore 
{
    [[GameSoundManager sharedInstance].soundEngine playEffect:SOUND_MENU_1];
    GameManager *gameManager = [GameManager sharedInstance];
    NSInteger nextLevelNum = gameManager.currentLevelNum + 1;
    [[CCDirector sharedDirector] replaceScene:[CCTransitionCrossFade transitionWithDuration:0.5f scene:[GameScene nodeWithLevelNum:nextLevelNum]]];                        
}

@end
