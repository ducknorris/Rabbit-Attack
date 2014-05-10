//
//  GameScene.m
//  Rabbit-Attack
//
//  Created by Sava Virtosu on 10/05/14.
//  Copyright Sava Virtosu 2014. All rights reserved.
//
// -----------------------------------------------------------------------

#import "GameScene.h"
#import "IntroScene.h"

// -----------------------------------------------------------------------
#pragma mark - GameScene
// -----------------------------------------------------------------------
//MACROS
#define BACKGROUND_SPEED 0.01f



@implementation GameScene
{
    CCSprite *_sprite;
    CCSprite *main_hero;
    CCSprite *main_background_1;
    CCSprite *main_background_2;
    
}

// -----------------------------------------------------------------------
#pragma mark - Create & Destroy
// -----------------------------------------------------------------------

+ (GameScene *)scene
{
    return [[self alloc] init];
}

// -----------------------------------------------------------------------

- (id)init
{
    // Apple recommend assigning self with supers return value
    self = [super init];
    if (!self) return(nil);
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a infinitScroll background (Dark Grey)
    main_background_1 = [CCSprite spriteWithImageNamed:@"main_background.png"];
    main_background_1.anchorPoint = ccp(0,0);
    main_background_1.position = ccp(10,10);
    main_background_1.scale = 0.25f;
    [self addChild:main_background_1];
    main_background_2 = [CCSprite spriteWithImageNamed:@"main_background.png"];
    main_background_2.anchorPoint = ccp(0,0);
    main_background_2.position = ccp([main_background_1 boundingBox].size.width-1,10);
    main_background_2.scale = 0.25f;
    [self addChild:main_background_2];
    
    [self schedule:@selector(backgroundScroll:) interval:BACKGROUND_SPEED];
    
    // Add a sprite
//    _sprite = [CCSprite spriteWithImageNamed:@"main_hero.png"];
//    _sprite.scale = 0.25f;
//    _sprite.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
//    [self addChild:_sprite];
    
    //checking memory 
//    for (int i = 0; i<500;i++) {
//        CCSprite *sprite = [CCSprite spriteWithImageNamed:@"2.png"];
//        sprite.position  = ccp(i,i);
//        sprite.scale = 0.25f;
//        [self addChild:sprite];
//    }
    
    
    // Animate sprite with action
//    CCActionRotateBy* actionSpin = [CCActionRotateBy actionWithDuration:1.5f angle:360];
//    [_sprite runAction:[CCActionRepeatForever actionWithAction:actionSpin]];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Exit to Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.85f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
//    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"main_hero.png"];
//    
//    //The sprite animation
//    NSMutableArray *walkAnimFrames = [NSMutableArray array];
//    for(int i = 1; i <= 5; ++i)
//    {
//        [walkAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"main_hero%d.png", i]]];
//    }
//    CCAnimation *walkAnim = [CCAnimation
//                             animationWithSpriteFrames:walkAnimFrames delay:0.1f]; //Speed in which the frames will go at
//    
//    //Adding png to sprite
//    main_hero = [CCSprite spriteWithImageNamed:@"main_hero.png"];
//    
//    //Positioning the sprite
//    main_hero.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
//    
//    //Repeating the sprite animation
//    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
//    CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
//    
//    //Animation continuously repeating
//    [main_hero runAction:repeatingAnimation];
//    
//    //Adding the Sprite to the Scene
//    [self addChild:main_hero];

    // done
	return self;
}

// -----------------------------------------------------------------------

- (void)dealloc
{
    // clean up code goes here
}

// -----------------------------------------------------------------------
#pragma mark - Enter & Exit
// -----------------------------------------------------------------------

- (void)onEnter
{
    // always call super onEnter first
    [super onEnter];
    
    // In pre-v3, touch enable and scheduleUpdate was called here
    // In v3, touch is enabled by setting userInterActionEnabled for the individual nodes
    // Per frame update is automatically enabled, if update is overridden
    
}

// -----------------------------------------------------------------------

- (void)onExit
{
    // always call super onExit last
    [super onExit];
}

// -----------------------------------------------------------------------
#pragma mark - Touch Handler
// -----------------------------------------------------------------------

-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLoc = [touch locationInNode:self];
    
    // Log touch location
    CCLOG(@"Move sprite to @ %@",NSStringFromCGPoint(touchLoc));
    
    // Move our sprite to touch location
    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
    [_sprite runAction:actionMove];
}

// -----------------------------------------------------------------------
#pragma mark - Button Callbacks
// -----------------------------------------------------------------------

- (void)onBackClicked:(id)sender
{
    // back to intro scene with transition
    [[CCDirector sharedDirector] replaceScene:[IntroScene scene]
                               withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:1.0f]];
}


- (void)backgroundScroll:(CCTime)dt{
    main_background_1.position = ccp(main_background_1.position.x-1,main_background_1.position.y);
    main_background_2.position = ccp(main_background_2.position.x-1,main_background_2.position.y);
    if(main_background_1.position.x<-[main_background_1 boundingBox].size.width) {
        main_background_1.position = ccp(main_background_2.position.x+[main_background_2 boundingBox].size.width,main_background_1.position.y);
        CCLOG(@"First Background Sprite");
    }
    if(main_background_2.position.x<-[main_background_2 boundingBox].size.width) {
        main_background_2.position = ccp(main_background_1.position.x+[main_background_1 boundingBox].size.width,main_background_2.position.y);
        CCLOG(@"Second Background Sprite");
    }
}

// -----------------------------------------------------------------------
@end