//
//  ViewController.m
//  spritybird
//
//  Created by Alexis Creuzot on 09/02/2014.
//  Copyright (c) 2014 Alexis Creuzot. All rights reserved.
//

#import "ViewController.h"
#import "BouncingScene.h"

@interface ViewController ()
@property (weak,nonatomic) IBOutlet SKView * gameView;
@end

@implementation ViewController
{
    BouncingScene * scene;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Configure the view.
    self.gameView.showsFPS = YES;
    self.gameView.showsNodeCount = YES;
    
    // Create and configure the scene.
    scene = [BouncingScene sceneWithSize:self.gameView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    scene.delegate = self;
    
    // Present the scene.
    [self.gameView presentScene:scene];
    
    
}


#pragma mark - Bouncing scene delegate

- (void)eventStart
{

}

- (void)eventPlay
{

}

- (void)eventWasted
{
    UIView * flash = [[UIView alloc] initWithFrame:self.view.frame];
    flash.backgroundColor = [UIColor whiteColor];
    flash.alpha = .8;
    [self.view.window addSubview:flash];
    [UIView animateWithDuration:.8 animations:^{
        flash.alpha = .0;
    } completion:^(BOOL finished) {
        [flash removeFromSuperview];
    }];
    
}


@end
