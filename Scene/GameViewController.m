//
//  GameViewController.m
//  Scene
//
//  Created by Omar on 7/24/14.
//  Copyright (c) 2014 omar. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // create a new scene
    
    ///load cow
    NSURL *vaca = [[NSBundle mainBundle] URLForResource: @"cowKit" withExtension:@"dae"];
    NSError *error;
    SCNScene *secondScene=[SCNScene sceneWithURL:vaca options:nil error:&error];

    //load Bear

    NSURL *oso = [[NSBundle mainBundle] URLForResource: @"oso" withExtension:@"dae"];
    SCNScene *thirdScene=[SCNScene sceneWithURL:oso options:nil error:&error];

    
    
    
    SCNScene *scene = [SCNScene scene];
    
//    scene.background=;

    // create and add a camera to the scene
    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    [scene.rootNode addChildNode:cameraNode];
    
    // place the camera
    cameraNode.position = SCNVector3Make(0, 0, 10);
    
    // create and add a light to the scene
    SCNNode *lightNode = [SCNNode node];
    lightNode.light = [SCNLight light];
    lightNode.light.type = SCNLightTypeOmni;
    lightNode.position = SCNVector3Make(0, 10, 10);
    [scene.rootNode addChildNode:lightNode];
    
    // create and add an ambient light to the scene
    SCNNode *ambientLightNode = [SCNNode node];
    ambientLightNode.light = [SCNLight light];
    ambientLightNode.light.type = SCNLightTypeAmbient;
    ambientLightNode.light.color = [UIColor darkGrayColor];
    [scene.rootNode addChildNode:ambientLightNode];
    
    // create and add a 3d box to the scene
//    SCNNode *boxNode = [SCNNode node];
//    boxNode.geometry = [SCNBox boxWithWidth:1 height:1 length:1 chamferRadius:0.02];
//    [scene.rootNode addChildNode:boxNode];
//    
    
    SCNNode *vaquita = [secondScene.rootNode clone];
    [vaquita setPosition:SCNVector3Make(5, 4, -10)];
    [scene.rootNode addChildNode:vaquita];
    
    SCNNode *osos = [thirdScene.rootNode clone];
    [osos setPosition:SCNVector3Make(10, 0, -10)];
    [osos setScale:SCNVector3Make(0.1, 0.1, 0.1)];
    [scene.rootNode addChildNode:osos];
    
    
    // create and configure a material
    SCNMaterial *material = [SCNMaterial material];
    material.diffuse.contents = [UIImage imageNamed:@"texture"];
    material.specular.contents = [UIColor grayColor];
    material.locksAmbientWithDiffuse = YES;
    
    // set the material to the 3d object geometry
//    boxNode.geometry.firstMaterial = material;
    vaquita.geometry.firstMaterial =material;
    osos.geometry.firstMaterial= material;
    
    // animate the 3d object
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
    animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(1, 1, 0, M_PI*2)];
    animation.duration = 5;
    animation.repeatCount = MAXFLOAT; //repeat forever
    [osos addAnimation:animation forKey:nil];
    
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // set the scene to the view
    scnView.scene = scene;
    
    // allows the user to manipulate the camera
    scnView.allowsCameraControl = YES;
        
    // show statistics such as fps and timing information
    scnView.showsStatistics = YES;

    // configure the view
    scnView.backgroundColor = [UIColor blackColor];
    
    // add a tap gesture recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    NSMutableArray *gestureRecognizers = [NSMutableArray array];
    [gestureRecognizers addObject:tapGesture];
    [gestureRecognizers addObjectsFromArray:scnView.gestureRecognizers];
    scnView.gestureRecognizers = gestureRecognizers;
}

- (void) handleTap:(UIGestureRecognizer*)gestureRecognize
{
    // retrieve the SCNView
    SCNView *scnView = (SCNView *)self.view;
    
    // check what nodes are tapped
    CGPoint p = [gestureRecognize locationInView:scnView];
    NSArray *hitResults = [scnView hitTest:p options:nil];
    
    // check that we clicked on at least one object
    if([hitResults count] > 0){
        // retrieved the first clicked object
        SCNHitTestResult *result = [hitResults objectAtIndex:0];
        
        // get its material
        SCNMaterial *material = result.node.geometry.firstMaterial;
        
        // highlight it
        [SCNTransaction begin];
        [SCNTransaction setAnimationDuration:0.5];
        
        // on completion - unhighlight
        [SCNTransaction setCompletionBlock:^{
            [SCNTransaction begin];
            [SCNTransaction setAnimationDuration:0.5];
            
            material.emission.contents = [UIColor blackColor];
            
            [SCNTransaction commit];
        }];
        
        material.emission.contents = [UIColor redColor];
        
        [SCNTransaction commit];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
