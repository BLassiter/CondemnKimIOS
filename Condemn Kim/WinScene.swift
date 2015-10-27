//
//  WinScene.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 10/22/15.
//  Copyright (c) 2015 Brandon Lassiter. All rights reserved.
//

import SpriteKit
import AVFoundation

class WinScene: SKScene {
   
    var continueButton : SKSpriteNode?;
    var bg : SKSpriteNode?
    var audioPlayer : AVAudioPlayer?
    override func didMoveToView(view: SKView) {
        
        
        var error : NSError?;
        
        let url:NSURL? = NSBundle.mainBundle().URLForResource("simplehappy", withExtension: "mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if(audioPlayer != nil) {
            audioPlayer!.play();
        } else {
            print("Error: \(error!.localizedDescription)")
        }
        
        self.backgroundColor = UIColor.blackColor();
        view.backgroundColor = UIColor.blackColor();
        bg = SKSpriteNode(imageNamed: "gameoverbg");
        bg!.position = CGPointMake(self.size.width / 2, self.size.height / 2);
        bg!.setScale(0.7);
        self.addChild(bg!);
        
        continueButton = SKSpriteNode(imageNamed: "continuebutton");
        continueButton!.position = CGPointMake(self.size.width / 2, 60);
        continueButton!.setScale(0.35);
        self.addChild(continueButton!);
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            if continueButton!.containsPoint(location) {
               
                if let scene = GameScene.unarchiveFromFile("GameScene", type: 0) as? GameScene {
                    // Configure the view.
                    audioPlayer!.stop();
                    let skView = self.view! as SKView
                    
                    /* Sprite Kit applies additional optimizations to improve rendering performance */
                    skView.ignoresSiblingOrder = true
                    
                    /* Set the scale mode to scale to fit the window */
                    scene.scaleMode = .AspectFill
                    
                    skView.presentScene(scene)
                }
                
            }
        }
        
    }

}
