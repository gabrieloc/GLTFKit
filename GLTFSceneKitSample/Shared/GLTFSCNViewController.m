//
//  Copyright (c) 2018 Warren Moore. All rights reserved.
//
//  Permission to use, copy, modify, and distribute this software for any
//  purpose with or without fee is hereby granted, provided that the above
//  copyright notice and this permission notice appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
//  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
//  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
//  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
//  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
//  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
//

#import "GLTFSCNViewController.h"
#import <GLTFSCN/GLTFSCN.h>

@interface GLTFSCNViewController ()
@property (nonatomic, weak) SCNView *scnView;
@end

@implementation GLTFSCNViewController

- (SCNView *)scnView {
    return (SCNView *)self.view;
}

- (void)setView:(NSView *)view {
    [super setView:view];
    
    self.scnView.allowsCameraControl = YES;
    
    id<MTLCommandQueue> commandQueue = self.scnView.commandQueue;
    // Setting the command queue's label to something other than "com.apple.SceneKit" allows us to capture it for debugging purposes.
    commandQueue.label = @"gltf.scenekit";
}

- (void)setAsset:(GLTFAsset *)asset {
    GLTFSCNAsset *scnAsset = [SCNScene assetFromGLTFAsset:asset options:@{}];
    _scene = scnAsset.defaultScene;
    for (GLTFSCNAnimationTargetPair *animation in scnAsset.animations) {
        [animation.target addAnimation:animation.animation forKey:nil];
    }
    
    _scene.lightingEnvironment.contents = @"tropical_beach.hdr";
    _scene.lightingEnvironment.intensity = 2.0;
    
    _scene.background.contents = @"tropical_beach.hdr";

    SCNNode *cameraNode = [SCNNode node];
    cameraNode.camera = [SCNCamera camera];
    cameraNode.camera.wantsHDR = YES;
    cameraNode.camera.wantsExposureAdaptation = YES;
    cameraNode.camera.bloomIntensity = 1.0;
    cameraNode.camera.zNear = 0.01;
    cameraNode.camera.zFar = 100.0;
    cameraNode.camera.automaticallyAdjustsZRange = YES;
    cameraNode.position = SCNVector3Make(0, 0, 4);
    [_scene.rootNode addChildNode:cameraNode];

    self.scnView.scene = _scene;
}

@end
