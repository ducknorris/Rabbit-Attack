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
#import "CCAnimation.h"
#import "Enemy.h"
#import "Missile.h"

// -----------------------------------------------------------------------
#pragma mark - GameScene
// -----------------------------------------------------------------------
//MACROS
#define BACKGROUND_SPEED 0.01f
#define ANIMATION_SPEED_MAIN_HERO 0.15f
#define MAX_ENEMY_NUMBER 10
#define ENEMY_GENERATION_SPEED 5



@implementation GameScene
{
    CCSprite *main_hero;
    CCSprite *main_background_1;
    CCSprite *main_background_2;
    NSMutableArray *enemyArray;
    int enemy_number;
    
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
    
    enemy_number = 0;
    
    // Enable touch handling on scene node
    self.userInteractionEnabled = YES;
    
    // Create a infinitScroll background (Dark Grey)
    main_background_1 = [CCSprite spriteWithImageNamed:@"main_background.png"];
    main_background_1.anchorPoint = ccp(0,0);
    main_background_1.position = ccp(10,10);
    main_background_1.scale = 0.3f;
    [self addChild:main_background_1];
    main_background_2 = [CCSprite spriteWithImageNamed:@"main_background.png"];
    main_background_2.anchorPoint = ccp(0,0);
    main_background_2.position = ccp([main_background_1 boundingBox].size.width-1,10);
    main_background_2.scale = 0.3f;
    [self addChild:main_background_2];
    
    [self schedule:@selector(backgroundScroll:) interval:BACKGROUND_SPEED];
    [self schedule:@selector(enemySpawner:) interval:ENEMY_GENERATION_SPEED];
    
    // Create a back button
    CCButton *backButton = [CCButton buttonWithTitle:@"[ Exit to Menu ]" fontName:@"Verdana-Bold" fontSize:18.0f];
    backButton.positionType = CCPositionTypeNormalized;
    backButton.position = ccp(0.80f, 0.95f); // Top Right of screen
    [backButton setTarget:self selector:@selector(onBackClicked:)];
    [self addChild:backButton];
    
    
    //MAIN HERO
    //***************************
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"main_hero.plist"];
    
    //The sprite animation
    NSMutableArray *flyAnimFrames = [NSMutableArray array];
    for(int i = 1; i <= 4; ++i)
    {
        [flyAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName: [NSString stringWithFormat:@"%d.png", i]]];
    }
    CCAnimation *walkAnim = [CCAnimation
                             animationWithSpriteFrames:flyAnimFrames delay:ANIMATION_SPEED_MAIN_HERO]; //Speed in which the frames will go at
    
    //Adding png to sprite
    main_hero = [CCSprite spriteWithImageNamed:@"1.png"];
    
    //Positioning the sprite
    main_hero.position  = ccp(self.contentSize.width/2,self.contentSize.height/2);
    main_hero.scale = 0.125;
    
    //Repeating the sprite animation
    CCActionAnimate *animationAction = [CCActionAnimate actionWithAnimation:walkAnim];
    CCActionRepeatForever *repeatingAnimation = [CCActionRepeatForever actionWithAction:animationAction];
    
    //Animation continuously repeating
    [main_hero runAction:repeatingAnimation];
    
    //Adding the Sprite to the Scene
    [self addChild:main_hero];
    
    //END MAIN HERO
    //***************************
    
    
    //ENEMY INIT
    //***************************
    enemyArray = [[NSMutableArray alloc] initWithCapacity:10];
    
    for(int i=0; i<MAX_ENEMY_NUMBER; i++){
        Enemy *enemyInstance = [[Enemy alloc] initWithType:EnemyTypeAstro];
        
        [enemyArray addObject:enemyInstance];
    }
    Enemy *new_enemy;
    new_enemy = [enemyArray objectAtIndex:enemy_number];
//
//    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:5.0f position:ccp(-100,main_hero.position.y)];
//    [[enemyArray objectAtIndex:0] runAction:actionMove];
    
    
    
    //END ENEMY
    //***************************

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
//    CCLOG(@"Touch @ %@",NSStringFromCGPoint(touchLoc));
    
    if(touchLoc.x > self.contentSize.width/1.5f) {
        CCLOG(@"Touch Right Side @ %@",NSStringFromCGPoint(touchLoc));
        Missile *missile = [[Missile alloc] initWithType:MissileTypeOne];
        missile.position = ccp(main_hero.position.x,main_hero.position.y);
        [self addChild:missile];
        
        [missile animate];
        [missile move:main_hero.position.y ];
    }
    if(touchLoc.x <= self.contentSize.width/1.5f) {
        CCLOG(@"Touch Left Side @ %@",NSStringFromCGPoint(touchLoc));
        CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:0.8f position:touchLoc];
        [main_hero runAction:actionMove];
    }
    
    
    // Move our sprite to touch location
//    CCActionMoveTo *actionMove = [CCActionMoveTo actionWithDuration:1.0f position:touchLoc];
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

- (void)enemySpawner:(CCTime)dt{
    CCLOG(@"Spawner @ %f",dt);
    CCLOG(@"Enemy @ %i",enemy_number);
    Enemy *new_enemy;
    new_enemy = [enemyArray objectAtIndex:enemy_number];
    new_enemy.position = ccp(self.contentSize.width+300,self.contentSize.height/2);
    [self addChild:new_enemy];

    [new_enemy animate];
    [new_enemy move:main_hero.position.y ];
    
    enemy_number++;
    if(enemy_number >= MAX_ENEMY_NUMBER) {
        enemy_number = 0;
    }
}

// -----------------------------------------------------------------------
@end
