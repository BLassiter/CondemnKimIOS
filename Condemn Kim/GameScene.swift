//
//  GameScene.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 10/22/15.
//  Copyright (c) 2015 Brandon Lassiter. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var kimSprite : SKSpriteNode?;
    var kimCategory : UInt32 = 2;
    var projectileCategory : UInt32 = 4;
    let screenSize: CGRect = UIScreen.mainScreen().bounds;
    var hitsLeftLabel : SKLabelNode?;
    var storeButton : SKSpriteNode?;
    var settingsButton : SKSpriteNode?;
    var divorceButton : SKSpriteNode?
    var missesButton : SKSpriteNode?
    var missesLabel : SKLabelNode?
    var divorceLabel : SKLabelNode?
    var inventoryButton : SKSpriteNode?
    var helpButton : SKSpriteNode?;
    
    var misses = 0;
    var numHits = 0;
    
    override func didMoveToView(view: SKView) {

        self.physicsBody = nil;
        self.physicsWorld.contactDelegate = self
        setupGame()
        
    }
    
    func setupGame() {
        
        var swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
        kimSprite = SKSpriteNode(imageNamed:"kimnormal")

        kimSprite!.setScale(0.5);
        kimSprite!.zPosition = 0;
        kimSprite!.position = CGPointMake(self.size.width / 2, self.size.height / 1.7);
        kimSprite!.physicsBody = nil;
        
        kimSprite!.physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(kimSprite!.size.width, kimSprite!.size.height / 2), center: CGPointMake(0,40))
        kimSprite!.physicsBody!.node!.name = "kim";
        kimSprite!.physicsBody!.affectedByGravity = false;
        
        
        
        kimSprite!.physicsBody!.dynamic = true; // 2
        kimSprite!.physicsBody!.categoryBitMask = kimCategory; // 3
        kimSprite!.physicsBody!.contactTestBitMask = projectileCategory; // 4
        kimSprite!.physicsBody!.collisionBitMask = 0;
        
        let bgTop = SKSpriteNode(imageNamed: "bgTop");
        bgTop.zPosition = -500;
        bgTop.setScale(0.4);
        bgTop.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height - bgTop.size.height / 2);

        let bgBottom = SKSpriteNode(imageNamed: "bgBottom");
        bgBottom.zPosition = -500;
        bgBottom.setScale(0.45);
        
        bgBottom.position = CGPointMake(self.frame.size.width / 2, bgBottom.size.height / 2);
        bgBottom.zPosition = 500;
        
        var level = NSUserDefaults.standardUserDefaults().integerForKey("level");
        
        if(level <= 0) {
            level = 1;
        }
        
        hitsLeftLabel = SKLabelNode(text: "Hits Left: \(level)");
        hitsLeftLabel!.position = CGPointMake(self.size.width / 2, self.size.height - 50);
        hitsLeftLabel!.zPosition = 1000;
        hitsLeftLabel!.fontName = "Helvetica-Bold";
        
        storeButton = SKSpriteNode(imageNamed: "storebutton");
        storeButton!.setScale(0.20);
        storeButton!.position = CGPointMake(self.size.width * 0.324, self.size.height - 34);
        storeButton!.zPosition = 1000;
        
        settingsButton = SKSpriteNode(imageNamed: "settingsicon");
        settingsButton!.setScale(0.305);
        settingsButton!.position = CGPointMake(self.size.width * 0.379, self.size.height - 34);
        settingsButton!.zPosition = 1000;
        
        divorceButton = SKSpriteNode(imageNamed: "divorcebuttonnew");
        divorceButton!.setScale(0.305);
        divorceButton!.position = CGPointMake(self.size.width * 0.33, 50);
        divorceButton!.zPosition = 1000;
        
        missesButton = SKSpriteNode(imageNamed: "missesbutton");
        missesButton!.setScale(0.305);
        missesButton!.position = CGPointMake(self.size.width * 0.66, 50);
        missesButton!.zPosition = 1000;
        
        missesLabel = SKLabelNode(text: "3");
        missesLabel!.position = CGPointMake(self.size.width * 0.66, 27);
        missesLabel!.zPosition = 1001;
        missesLabel!.fontName = "Helvetica-Bold";
        missesLabel!.fontColor = UIColor.blackColor();
        missesLabel!.fontSize = 14;
        
        divorceLabel = SKLabelNode(text: "0");
        divorceLabel!.position = CGPointMake(self.size.width * 0.33, 27);
        divorceLabel!.zPosition = 1001;
        divorceLabel!.fontName = "Helvetica-Bold";
        divorceLabel!.fontColor = UIColor.blackColor();
        divorceLabel!.fontSize = 14;
        
        inventoryButton = SKSpriteNode(imageNamed: "inventorybutton");
        inventoryButton!.setScale(0.3);
        inventoryButton!.position = CGPointMake(self.size.width / 2, 55);
        inventoryButton!.zPosition = 1001;
        
        helpButton = SKSpriteNode(imageNamed: "questionbutton");
        helpButton!.setScale(0.35);
        helpButton!.position = CGPointMake(self.size.width * 0.68, self.size.height - 34);
        helpButton!.zPosition = 1001;
        
        self.addChild(helpButton!);
        self.addChild(inventoryButton!);
        self.addChild(divorceLabel!);
        self.addChild(missesLabel!);
        self.addChild(missesButton!);
        self.addChild(divorceButton!);
        self.addChild(storeButton!);
        self.addChild(settingsButton!);
        self.addChild(hitsLeftLabel!);
        self.addChild(bgTop);
        self.addChild(kimSprite!);
        self.addChild(bgBottom);
        
        startDefaultAnimation();
        changeDirection();
        updateHits();
        updateLabels();
        
    }
    
    func updateHits() {
        var level = NSUserDefaults.standardUserDefaults().integerForKey("level");
        
        if(level <= 0) {
            level = 1;
        }
        
        var hitsLeft : Int = level - numHits;
        
        if(hitsLeft <= 0) {
            hitsLeft = 0;
            endGame(true);
        }
        
        hitsLeftLabel!.text = "Hits Left: \(hitsLeft)";
        
    }
   
    func endGame(win: Bool) {
        
        if(win) {
            
            var level = NSUserDefaults.standardUserDefaults().integerForKey("level");
            level++;
            NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "level");
            println("Win!");
            
        } else {
            
            println("Lost!");
            
        }
        
    }
    
    func updateLabels() {
        
        missesLabel!.text = (3 - misses > 0) ? "\(3 - misses)" : "0";
        
        var divorces = NSUserDefaults.standardUserDefaults().integerForKey("divorces");
        
        divorceLabel!.text = "\(divorces)";
        
    }
    
    func startDefaultAnimation() {
        
        kimSprite!.removeActionForKey("blinkAnimation");
        
        let blinkAnimation = SKAction.animateWithTextures([SKTexture(imageNamed: "kimblink")], timePerFrame: 0.25);
        let normalAnimation = SKAction.animateWithTextures([SKTexture(imageNamed: "kimnormal")], timePerFrame: 3);
        
        let animationSequence = SKAction.sequence([normalAnimation, blinkAnimation]);
        
        kimSprite!.runAction(SKAction.repeatActionForever(animationSequence), withKey: "blinkAnimation");
        
        let rotateLeft = SKAction.rotateToAngle(0.25, duration: 0.25);
        
        let rotateRight = SKAction.rotateToAngle(-0.25, duration: 0.25);
        
        let sequence = SKAction.sequence([rotateLeft, rotateRight]);
        
        kimSprite!.runAction(SKAction.rotateToAngle(-0.05, duration: 0.01));
        
        kimSprite!.runAction(SKAction.repeatActionForever(sequence));
    }
    
    func hitAnimation() {
        
        kimSprite!.removeActionForKey("blinkAnimation");
        
        let hitAnimation = SKAction.animateWithTextures([SKTexture(imageNamed: "kimhitsprite")], timePerFrame: 0.25);
        let normalAnimation = SKAction.animateWithTextures([SKTexture(imageNamed: "kimnormal")], timePerFrame: 1);
        
        let animationSequence = SKAction.sequence([hitAnimation, normalAnimation]);
        
        kimSprite!.runAction(animationSequence, completion: { () -> Void in
            self.startDefaultAnimation();
        });
    }
    
    var speedScale = 0.5;
    var staticSpeedScale = 5.0;
    var targetX : Float = 0;
    var divorceUsed = false;
    func changeDirection() {
        
        if (targetX == 0) {
            targetX = Float(self.size.width / 2)
        }
        
        var level : Int? = NSUserDefaults.standardUserDefaults().integerForKey("level");
        
        if(level == nil) {
            level = 1;
            NSUserDefaults.standardUserDefaults().setInteger(level!, forKey: "level");
        }
        
        
        var speedModifier = 1 + floor(Double(level!) / 100);
        
        if(speedModifier < 1) {
            speedModifier = 1;
        }
        
        
        var tempX = targetX;
        var diff : Float = 0;
        
        println("Width: \(screenSize.width)");
        if(targetX < (Float(self.size.width) / 2)) {
            //go right
            
            var random = arc4random_uniform(UInt32(self.size.width / 2));
            var randomFloat : Float = Float(random);
            
            targetX = (Float(self.size.width) / 2) + randomFloat;
            
            println("TargetX: \(targetX)");
            
            diff = targetX - tempX;
            
        } else {
            // go left
            var random = arc4random_uniform(UInt32(self.size.width / 2));
            var randomFloat : Float = Float(random);
            
            targetX = (Float(self.size.width) / 2) - randomFloat;
            
            println("TargetX: \(targetX)");

            diff = tempX - targetX;
            
        }
        
        
        
        var targetPosition = CGPointMake(CGFloat(targetX), kimSprite!.position.y);
        
        println("Target Position: \(targetPosition)")
        
//        if(speedModifier > 0) {
//            speedScale = staticSpeedScale + (speedModifier);
//        }
        
        var temp1 : Float = Float((2 / speedScale) * speedModifier);
        var speed : NSTimeInterval = NSTimeInterval((diff / temp1) / 60);

        if(divorceUsed) {
            speed *= 2;
        }
        
        kimSprite!.runAction(SKAction.moveTo(targetPosition, duration: speed), completion: { () -> Void in
            self.changeDirection();
        })
    };
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Up:
                throwObject()
            default:
                break
            }
        }
    }
    
    var selectedThrowable : String?;
    
    func throwObject() {

        
        selectedThrowable = NSUserDefaults.standardUserDefaults().stringForKey("throwable");
        
        if(selectedThrowable == nil) {
            selectedThrowable = "marriagelicense";
        }
        
        var projectile = SKSpriteNode(imageNamed: selectedThrowable!)
        projectile.setScale(0.5);
        projectile.zPosition = 501;
        
        let rotateAction = SKAction.rotateByAngle(5, duration: 0.25);
        projectile.runAction(SKAction.repeatActionForever(rotateAction));
        
        projectile.position = CGPointMake(self.frame.size.width / 2, 0);
        
        projectile.physicsBody = SKPhysicsBody(rectangleOfSize: projectile.size, center: CGPointMake(0,0))
        
        projectile.physicsBody!.affectedByGravity = false;
        projectile.physicsBody!.dynamic = true; // 2
        projectile.physicsBody!.node!.name = "projectile";
        projectile.physicsBody!.categoryBitMask = projectileCategory; // 3
        projectile.physicsBody!.contactTestBitMask = kimCategory; // 4
        projectile.physicsBody!.collisionBitMask = 0; // 5
        
        self.addChild(projectile);
        // 0.65 speed
        projectile.runAction(SKAction.moveTo(CGPointMake(projectile.position.x, (self.frame.size.height + 0.2)), duration: 0.65), completion: { () -> Void in
            projectile.removeFromParent();
            
            self.addMiss();
            
        });
        
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        println("bitmask1: \(contact.bodyA.categoryBitMask)")
        println("bitmask2: \(contact.bodyB.categoryBitMask)")
        
        println("name1: \(contact.bodyA.node!.name)")
        println("name2: \(contact.bodyB.node!.name)")
        
        var other:SKPhysicsBody = contact.bodyA.categoryBitMask == projectileCategory ? contact.bodyB : contact.bodyA
        var projectile:SKPhysicsBody = contact.bodyA.categoryBitMask == projectileCategory ? contact.bodyA : contact.bodyB
        
        if(other.node!.name == "kim" && projectile.node!.name == "projectile") {
            
            hitKim();
            
            numHits++;
            updateHits()
            var projectileNode = projectile.node! as! SKSpriteNode;
            projectileNode.removeAllActions();
            projectileNode.removeFromParent();
            
        }

    }
    
    func hitKim() {
        
        hitAnimation()
        
        
    }
    
    func addMiss() {
        misses++;
        
        if(misses >= 3) {
            endGame(false);
        }
        self.updateLabels();
        
    }

    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
