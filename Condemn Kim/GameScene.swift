//
//  GameScene.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 10/22/15.
//  Copyright (c) 2015 Brandon Lassiter. All rights reserved.
//

import SpriteKit
import AVFoundation
import UIKit
import Parse
import ParseFacebookUtilsV4
import FBSDKShareKit

class GameScene: SKScene, SKPhysicsContactDelegate, UIAlertViewDelegate, AdColonyAdDelegate {
    
    
    var movingSlider : Bool = false;
    var kimSprite : SKSpriteNode?;
    var kimCategory : UInt32 = 2;
    var projectileCategory : UInt32 = 4;
    let screenSize: CGRect = UIScreen.mainScreen().bounds;
    var hitsLeftLabel : SKLabelNode?;
    var storeButton : SKSpriteNode?;
    var muteButton : SKSpriteNode?;
    var divorceButton : SKSpriteNode?
    var missesButton : SKSpriteNode?
    var missesLabel : SKLabelNode?
    var divorceLabel : SKLabelNode?
    var inventoryButton : SKSpriteNode?
    var helpButton : SKSpriteNode?;
    var continueButton : SKSpriteNode?
    var gameOver : Bool = false;
    var misses = 0;
    var numHits = 0;
    var audioPlayer : AVAudioPlayer?
    var audioPlayerLaugh : AVAudioPlayer?
    var positionSlider : SKSpriteNode?
    var track : SKSpriteNode?;
    var fbButton : SKSpriteNode?;
    var statsButton : SKSpriteNode?;
    
    var divorceAlert : UIAlertView?;
    var infoAlert : UIAlertView?;
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor();
        view.backgroundColor = UIColor.blackColor();
        self.physicsBody = nil;
        self.physicsWorld.contactDelegate = self
        
        setupGame()
        
    }
    
    func setupGame() {
        
        if(PFUser.currentUser() != nil) {
            let user = PFUser.currentUser();
            let gamesPlayed = user!.valueForKey("gamesPlayed") as! Int
            user!.setValue(gamesPlayed + 1, forKey: "gamesPlayed");
            user!.saveInBackground();
        }
        
        muted = NSUserDefaults.standardUserDefaults().boolForKey("muted");
        
        var error : NSError?;
        
        let url:NSURL? = NSBundle.mainBundle().URLForResource("behappy", withExtension: "wav")
        do {
            audioPlayer = try AVAudioPlayer(contentsOfURL: url!)
        } catch let error1 as NSError {
            error = error1
            audioPlayer = nil
        }
        
        if(audioPlayer != nil) {
            audioPlayer!.numberOfLoops = -1;
            if(!muted) {
                audioPlayer!.play();
            }
        } else {
            print("Error: \(error!.localizedDescription)")
        }
        
        let swipeUp = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        self.view!.addGestureRecognizer(swipeUp)
        
        kimSprite = SKSpriteNode(imageNamed:"kimnormal")

        kimSprite!.setScale(0.35);
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
        bgTop.setScale(0.45);
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
        hitsLeftLabel!.fontSize = 18;
        
        storeButton = SKSpriteNode(imageNamed: "storebutton");
        storeButton!.setScale(0.20);
        storeButton!.position = CGPointMake(self.size.width * 0.324, self.size.height - 34);
        storeButton!.zPosition = 1000;
        
        var muteImage : String?;
        
        if(muted) {
            muteImage = "muteon";
        } else {
            muteImage = "muteoff";
        }
        
        muteButton = SKSpriteNode(imageNamed: muteImage!);
        muteButton!.setScale(0.305);
        muteButton!.position = CGPointMake(self.size.width * 0.379, self.size.height - 34);
        muteButton!.zPosition = 1000;
        
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
        
        selectedThrowable = NSUserDefaults.standardUserDefaults().stringForKey("throwable");
        
        if(selectedThrowable == nil) {
            selectedThrowable = "marriagelicense";
        }
        
        positionSlider = SKSpriteNode(imageNamed: selectedThrowable!);
        positionSlider!.position = CGPointMake(self.size.width / 2, 120);
        positionSlider!.zPosition = 1100;
        positionSlider!.setScale(0.5);
        self.addChild(positionSlider!);
        
        track = SKSpriteNode(imageNamed: "track");
        track!.position = CGPointMake(self.size.width / 2, 120);
        track!.zPosition = 1000;
        track!.setScale(0.5);
        
        fbButton = SKSpriteNode(imageNamed: "facebookbutton");
        fbButton!.setScale(0.35)
        fbButton!.zPosition = 1000;
        fbButton!.position = CGPointMake(self.size.width * 0.63, self.size.height - 34);
        
        statsButton = SKSpriteNode(imageNamed: "statsicon");
        statsButton!.setScale(0.35)
        statsButton!.zPosition = 1000;
        statsButton!.position = CGPointMake(self.size.width * 0.58, self.size.height - 34);
        
        if(PFUser.currentUser() != nil) {
            self.addChild(statsButton!);
        }
        
        self.addChild(fbButton!);
        self.addChild(track!);
        
        self.addChild(helpButton!);
        self.addChild(inventoryButton!);
        self.addChild(divorceLabel!);
        self.addChild(missesLabel!);
        self.addChild(missesButton!);
        self.addChild(divorceButton!);
        self.addChild(storeButton!);
        self.addChild(muteButton!);
        self.addChild(hitsLeftLabel!);
        self.addChild(bgTop);
        self.addChild(kimSprite!);
        self.addChild(bgBottom);

        startDefaultAnimation();
        changeDirection();
        updateHits();
        updateLabels();
        
        loadDataFromParse()

        
    }
    
    var loggedIn : Bool = false;
    
    func _loginWithFacebook() {
        
        
        if(!loggedIn) {
        
            let permissionsArray = ["user_about_me", "user_relationships", "user_birthday", "user_location"];
        
            PFFacebookUtils.logInInBackgroundWithReadPermissions(permissionsArray) { (user, error) -> Void in
                print("Finished block");
                print("User: \(user)");
                print("Error: \(error)");
                
                if(user != nil) {
                    let alert = UIAlertView(title: "Logged In", message: "You successfully logged into Facebook! You're progress will now be saved in the cloud!", delegate: nil, cancelButtonTitle: "Ok");
                    alert.show();
                    
                    print("Logged in");
                    self._loadData();
                    self.loadDataFromParse();
                    
                    self.addChild(self.statsButton!);

                    
                } else {
                    let alert = UIAlertView(title: "Login Failed", message: "Sorry, it appears that something went wrong while trying to log into Facebook. Please try again.", delegate: nil, cancelButtonTitle: "Ok");
                    alert.show();
                    print("Failed Login");
                }
            }
            
        } else {
            let alert = UIAlertView(title: "Already Logged In", message: "You are already logged into Facebook!", delegate: nil, cancelButtonTitle: "Ok");
            alert.show();
            
        }
        
    
    }
    

    func _loadData() {
        
        let request : FBSDKGraphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields": "name, email"]);
        request.startWithCompletionHandler { (FBSDKGraphRequestConnection, result, NSError) -> Void in
            
            let currentUser = PFUser.currentUser();
            
            var dict = result as! Dictionary<String, String> ;
            
            print("Dict: \(dict)");
            currentUser!.setValue(dict["name"], forKey: "name");
            
            let parseLevel : Int? = currentUser!.valueForKey("level") as? Int;
            let localLevel : Int = NSUserDefaults.standardUserDefaults().integerForKey("level");
            
            if(parseLevel != nil && parseLevel > localLevel) {
                
                NSUserDefaults.standardUserDefaults().setInteger(parseLevel!, forKey: "level")
                
            } else {
                
                currentUser!.setValue(localLevel, forKey: "level");
                
            }
            
            let parseDivorces : Int? = currentUser!.valueForKey("divorces") as? Int;
            let localDivorces : Int = NSUserDefaults.standardUserDefaults().integerForKey("divorces");
            
            if(parseDivorces != nil && parseDivorces > localDivorces) {
                
                NSUserDefaults.standardUserDefaults().setInteger(parseDivorces!, forKey: "divorces")
                
            } else {
                
                currentUser!.setValue(localDivorces, forKey: "divorces");
                
            }
            
            currentUser!.setValue(0, forKey: "gamesPlayed");
            currentUser!.setValue(0, forKey: "gamesWon");
            currentUser!.setValue(0, forKey: "gamesLost");
            currentUser!.setValue(0, forKey: "numberOfThrows");
            currentUser!.setValue(0, forKey: "numberOfHits");
            currentUser!.setValue(0, forKey: "numberOfMisses");
            currentUser!.setValue(0, forKey: "divorcesUsed");
            
            currentUser!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if(success) {
                    NSUserDefaults.standardUserDefaults().setValue(true, forKey: "loggedin");
                }
            })
            
        }
        
    }
    
    func updateHits() {
        var level = NSUserDefaults.standardUserDefaults().integerForKey("level");
        
        if(level <= 0) {
            level = 1;
        }
        
        NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "level");
        var hitsLeft : Int = level - numHits;
        
        if(hitsLeft <= 0) {
            hitsLeft = 0;
            endGame(true);
        }
        
        hitsLeftLabel!.text = "Hits Left: \(hitsLeft)";
        
    }
    
    func loadDataFromParse() {
        
        let user = PFUser.currentUser();
        
        if(user != nil) {
            print("User: \(user)");
            fbButton!.texture = SKTexture(imageNamed: "leaderboard");
        }
        
    }
   
    func endGame(win: Bool) {
        
        if(win) {
            audioPlayer!.stop();
            var level = NSUserDefaults.standardUserDefaults().integerForKey("level");

            level++;
            NSUserDefaults.standardUserDefaults().setInteger(level, forKey: "level");
            let user = PFUser.currentUser();
            if(user != nil) {
                user!.setValue(level, forKey: "level");
                
                let gamesWon = user!.valueForKey("gamesWon") as! Int
                user!.setValue(gamesWon + 1, forKey: "gamesWon");
                
                user!.saveInBackground();
            }
            
            if let scene = WinScene.unarchiveFromFile("WinScene", type: 1) as? WinScene {
                // Configure the view.
                let skView = self.view! as SKView
                
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
                
                skView.presentScene(scene)
            }
            
        } else {
            
            
            var error2 : NSError?;
            
            let url2:NSURL? = NSBundle.mainBundle().URLForResource("witch2", withExtension: "mp3")
            do {
                audioPlayerLaugh = try AVAudioPlayer(contentsOfURL: url2!)
            } catch let error as NSError {
                error2 = error
                audioPlayerLaugh = nil
            }
            
            if(audioPlayerLaugh != nil) {
                audioPlayerLaugh!.numberOfLoops = -1;
                if(!muted) {
                    audioPlayerLaugh!.play();
                }
            } else {
                print("Error: \(error2!.localizedDescription)")
            }
            
            gameOver = true;
            
            kimSprite!.removeAllActions();
            kimSprite!.runAction(SKAction.rotateToAngle(0, duration: 0.25));
            
            let laughAnimation = SKAction.animateWithTextures([SKTexture(imageNamed: "kimlaugh1"), SKTexture(imageNamed: "kimlaugh2")], timePerFrame: 0.2);
            
            kimSprite!.runAction(SKAction.repeatActionForever(laughAnimation));
            
            continueButton = SKSpriteNode(imageNamed: "continuebutton");
            continueButton!.zPosition = 1200;
            continueButton!.position = CGPointMake(self.size.width / 2, 200);
            continueButton!.setScale(0.35);
            self.addChild(continueButton!);
            
            let loseText : SKSpriteNode = SKSpriteNode(imageNamed: "losetext");
            loseText.position = CGPointMake(self.size.width / 2, self.size.height / 2);
            loseText.setScale(0.5)
            loseText.zPosition = 2000;
            self.addChild(loseText);
            if(PFUser.currentUser() != nil) {

                let user = PFUser.currentUser();
                let gamesLost = user!.valueForKey("gamesLost") as! Int
                user!.setValue(gamesLost + 1, forKey: "gamesLost");
                user!.saveInBackground();
            }
        }
        
    }
    
    func updateLabels() {
        
        missesLabel!.text = (3 - misses > 0) ? "\(3 - misses)" : "0";
        
        let divorces = NSUserDefaults.standardUserDefaults().integerForKey("divorces");
        
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
            self.kimSprite!.removeAllActions();
            self.startDefaultAnimation();
            self.changeDirection();
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
        
        
        var speedModifier = 1 + Double(level!) / 100;
        
        if(speedModifier < 1) {
            speedModifier = 1;
        }
        
        
        let tempX = targetX;
        var diff : Float = 0;
        
        if(targetX < (Float(self.size.width) / 2)) {
            //go right
            
            let random = arc4random_uniform(UInt32(self.size.width / 2));
            let randomFloat : Float = Float(random);
            
            targetX = (Float(self.size.width) / 2) + randomFloat;
            
            
            diff = targetX - tempX;
            
        } else {
            // go left
            let random = arc4random_uniform(UInt32(self.size.width / 2));
            let randomFloat : Float = Float(random);
            
            targetX = (Float(self.size.width) / 2) - randomFloat;
            

            diff = tempX - targetX;
            
        }
        
        
        
        let targetPosition = CGPointMake(CGFloat(targetX), kimSprite!.position.y);
        
        
        
//        if(speedModifier > 0) {
//            speedScale = staticSpeedScale + (speedModifier);
//        }
        
        let temp1 : Float = Float((2 / speedScale) * speedModifier);
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
                if(!gameOver) {
                    throwObject()
                }
            default:
                break
            }
        }
    }
    
    var selectedThrowable : String?;
    
    func throwObject() {

        if(PFUser.currentUser() != nil) {

            let user = PFUser.currentUser();
            let numThrown = user!.valueForKey("numberOfThrows") as! Int
            user!.setValue(numThrown + 1, forKey: "numberOfThrows");
            user!.saveInBackground();
            
        }
        
        selectedThrowable = NSUserDefaults.standardUserDefaults().stringForKey("throwable");
        
        if(selectedThrowable == nil) {
            selectedThrowable = "marriagelicense";
        }
        
        if(!muted) {
            self.runAction(SKAction.playSoundFileNamed("bodyhit.mp3", waitForCompletion: false));
        }
        
        let projectile = SKSpriteNode(imageNamed: selectedThrowable!)
        projectile.setScale(0.35);
        projectile.zPosition = 501;
        
        let rotateAction = SKAction.rotateByAngle(5, duration: 0.25);
        projectile.runAction(SKAction.repeatActionForever(rotateAction));
        
        projectile.position = positionSlider!.position;
        
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
        
        print("bitmask1: \(contact.bodyA.categoryBitMask)")
        print("bitmask2: \(contact.bodyB.categoryBitMask)")
        
        print("name1: \(contact.bodyA.node!.name)")
        print("name2: \(contact.bodyB.node!.name)")
        
        let other:SKPhysicsBody = contact.bodyA.categoryBitMask == projectileCategory ? contact.bodyB : contact.bodyA
        let projectile:SKPhysicsBody = contact.bodyA.categoryBitMask == projectileCategory ? contact.bodyA : contact.bodyB
        
        if(other.node!.name == "kim" && projectile.node!.name == "projectile") {
            
            hitKim();
            
            numHits++;
            
            if(PFUser.currentUser() != nil) {

                let user = PFUser.currentUser();
                let numberOfHits = user!.valueForKey("numberOfHits") as! Int
                user!.setValue(numberOfHits + 1, forKey: "numberOfHits");
                user!.saveInBackground();
                
            }
            
            updateHits()
            let projectileNode = projectile.node! as! SKSpriteNode;
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
        
        if(PFUser.currentUser() != nil) {

            let user = PFUser.currentUser();
            let numMiss = user!.valueForKey("numberOfMisses") as! Int
            user!.setValue(numMiss + 1, forKey: "numberOfMisses");
            user!.saveInBackground();

        }
        
        self.updateLabels();
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.locationInNode(self)
            // Check if the location of the touch is within the button's bounds
            
            if(continueButton != nil) {
                
                if continueButton!.containsPoint(location) {

                    audioPlayer!.stop();
                    audioPlayerLaugh!.stop();
                    if let scene = GameScene.unarchiveFromFile("GameScene", type: 0) as? GameScene {
                        // Configure the view.
                        let skView = self.view! as SKView
                        
                        /* Sprite Kit applies additional optimizations to improve rendering performance */
                        skView.ignoresSiblingOrder = true
                        
                        /* Set the scale mode to scale to fit the window */
                        scene.scaleMode = .AspectFill
                        
                        skView.presentScene(scene)
                    }
                }
            
            }
            
            
            if(statsButton != nil && statsButton!.containsPoint(location)) {
                
                let currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
                
                let viewController = StatsViewController();
                
                currentViewController.presentViewController(viewController, animated: true, completion: nil)
                
            }
            
            if(muteButton != nil) {
                if(muteButton!.containsPoint(location)) {
                    toggleMute()
                }
            }
            
            if(fbButton != nil && fbButton!.containsPoint(location)) {
            
                loggedIn = NSUserDefaults.standardUserDefaults().boolForKey("loggedin");

                if(!loggedIn) {
                    _loginWithFacebook();
                } else {
                    
                    let currentViewController:UIViewController=UIApplication.sharedApplication().keyWindow!.rootViewController!
                    
                    let viewController = LeaderboardViewController();
                    
                    currentViewController.presentViewController(viewController, animated: true, completion: nil)
                    
                }
            }
            
            if(storeButton != nil) {
                if(storeButton!.containsPoint(location)) {
                    openStore();
                }
            }
            
            if(storeCloseButton != nil) {
            
                if(storeCloseButton!.containsPoint(location)) {
                    closeStore();
                }
                
            }
            
            if(helpButton!.containsPoint(location)) {
                
                infoAlert = UIAlertView(title: "Help", message: "What would you like to learn about?", delegate: nil, cancelButtonTitle: "Nothing", otherButtonTitles: "Misses", "Divorces");
                infoAlert!.delegate = self;
                infoAlert!.show();
                
            }
            
            if(divorceButton!.containsPoint(location)) {
                
                var numDivorces = NSUserDefaults.standardUserDefaults().integerForKey("divorces");

                if(numDivorces > 0 && !divorceUsed) {
                    
                    numDivorces--;
                    NSUserDefaults.standardUserDefaults().setInteger(numDivorces, forKey: "divorces");
                   
                    if(PFUser.currentUser() != nil) {

                        var currentUser = PFUser.currentUser();
                        currentUser!.setValue(numDivorces, forKey: "divorces");
                        
                        let divorcesUsed = currentUser!.valueForKey("divorcesUsed") as! Int
                        currentUser!.setValue(divorcesUsed + 1, forKey: "divorcesUsed");
                        currentUser!.saveInBackground();

                    }
                    
                    divorceUsed = true;
                    updateLabels()
                    
                } else {
                    
                    divorceAlert = UIAlertView(title: "No Divorces", message: "Sorry, it seems that you are out of divorces! Would you like to watch a short video to earn 3 Free divorces?", delegate: nil, cancelButtonTitle: "No", otherButtonTitles: "Yes");
                    divorceAlert!.delegate = self;
                    divorceAlert!.show();
                    
                }
                
            }
            
            if(positionSlider!.containsPoint(location)) {
                movingSlider = true;
            }
            
        }
        
    }
    
    var storeBg : SKSpriteNode?;
    var creditsLabel : SKLabelNode?;
    var credits : Int = 0;
    
    var flagButton : SKSpriteNode?
    var chairButton : SKSpriteNode?
    var divorceBuyButton : SKSpriteNode?
    var storeCloseButton : SKSpriteNode?
    
    var storeOpen : Bool = false;
    
    func openStore() {
        
        if(!storeOpen) {
            
            storeOpen = true;
            credits = NSUserDefaults.standardUserDefaults().integerForKey("credits");
            
            storeBg = SKSpriteNode(imageNamed: "storebackground");
            storeBg!.position = CGPointMake(self.frame.size.width / 2, self.size.height / 2);
            storeBg!.setScale(0.35)
            storeBg!.zPosition = 2500;
            
            creditsLabel = SKLabelNode(text: "\(credits)");
            creditsLabel!.position = CGPointMake(self.frame.size.width / 2 + 10, (self.frame.size.height / 2) + 85);
            creditsLabel!.fontSize = 16;
            creditsLabel!.fontName = "Helvetica-Bold";
            creditsLabel!.zPosition = 2501;
            
            flagButton = SKSpriteNode(imageNamed: "flag3background");
            flagButton!.position = CGPointMake(self.frame.size.width / 2, self.size.height / 2 + 30);
            flagButton!.setScale(0.35)
            flagButton!.zPosition = 2501;
            
            chairButton = SKSpriteNode(imageNamed: "chair1background");
            chairButton!.position = CGPointMake(self.frame.size.width / 2, self.size.height / 2 - 45);
            chairButton!.setScale(0.35)
            chairButton!.zPosition = 2501;
            
            divorceBuyButton = SKSpriteNode(imageNamed: "divorcebackground");
            divorceBuyButton!.position = CGPointMake(self.frame.size.width / 2, self.size.height / 2 - 120);
            divorceBuyButton!.setScale(0.35)
            divorceBuyButton!.zPosition = 2501;
            
            storeCloseButton = SKSpriteNode(imageNamed: "closebutton");
            storeCloseButton!.position = CGPointMake(self.frame.size.width / 2 + storeBg!.frame.size.width / 2 - 15, self.size.height / 2 + storeBg!.frame.size.height / 2 - 30);
            storeCloseButton!.setScale(0.35)
            storeCloseButton!.zPosition = 2501;
            
            self.addChild(storeCloseButton!)
            self.addChild(divorceBuyButton!)
            self.addChild(chairButton!)
            self.addChild(flagButton!)
            self.addChild(creditsLabel!)
            self.addChild(storeBg!)
            
        }
        
    }
    
    func closeStore() {
        
        if(storeOpen) {
            storeOpen = false;
            self.removeChildrenInArray([storeBg!, creditsLabel!, flagButton!, divorceBuyButton!, chairButton!, storeCloseButton!]);
        }
        
        
    }
    
    var muted : Bool = false;
    
    func toggleMute() {
        
        if(muted) {
         
            muted = false;
            muteButton!.texture = SKTexture(imageNamed: "muteoff");
            audioPlayer!.play()
            if(gameOver) {
                audioPlayerLaugh!.play()
            }
        } else {
            
            muted = true;
            muteButton!.texture = SKTexture(imageNamed: "muteon");
            audioPlayer!.pause()
            
            if(gameOver) {
                audioPlayerLaugh!.pause()
            }
        }
        
        
        NSUserDefaults.standardUserDefaults().setBool(muted, forKey: "muted")
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let location = touch.locationInNode(self)
            if(movingSlider) {

                if(location.x > (self.size.width / 2 - track!.size.width / 2) + positionSlider!.size.width / 2 && location.x < (self.size.width / 2 + track!.size.width / 2) - positionSlider!.size.width / 2) {
                    
                    positionSlider!.position = CGPointMake(location.x, positionSlider!.position.y);

                }
            }
            
        }

        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        movingSlider = false;
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        
        if(divorceAlert != nil && alertView == divorceAlert!) {
        
            if(buttonIndex == 1) {
                
                // show add
                self.performSelector(Selector("showAd"), withObject: nil, afterDelay: 0.5)
                
            }
            
        }
        
        if(infoAlert != nil && alertView == infoAlert) {
            
            if(buttonIndex == 1) {
                let alert = UIAlertView(title: "Misses", message: "You can miss Kim up to 3 times before you lose. The 'Misses Left' section at the bottom of the screens tells you how many more times you can miss before you lose", delegate: nil, cancelButtonTitle: "Ok");
                alert.show();
            }
            
            if(buttonIndex == 2) {
                let alert = UIAlertView(title: "Divorces", message: "Divorces cut Kim's speed in half. You can only use 1 per level. You can obtain more divorces by playing the game, or you can buy more in the store.", delegate: nil, cancelButtonTitle: "Ok");
                alert.show();
            }
            
        }

        
    }

    
    func showAd() {
        
         AdColony.playVideoAdForZone("vz1720a2178a634eb581", withDelegate: self);
        
    }

    func onAdColonyAdAttemptFinished(shown: Bool, inZone zoneID: String) {
        
        if(shown) {
            let divorces : Int = NSUserDefaults.standardUserDefaults().integerForKey("divorces");
            NSUserDefaults.standardUserDefaults().setInteger(divorces + 3, forKey: "divorces");
            
            if(PFUser.currentUser() != nil) {

                let user = PFUser.currentUser();
                user!.setValue(divorces + 3, forKey: "divorces");
                user!.saveInBackground();

            }
            
            updateLabels()
            
            let alert = UIAlertView(title: "Thank you!", message: "Thank you for watching the video. Here are 3 free divorces!", delegate: nil, cancelButtonTitle: "Ok")
            alert.show();
            
            
        } else {
            
            let alert = UIAlertView(title: "Oops", message: "It looks like something went wrong with the video. Please try again later.", delegate: nil, cancelButtonTitle: "Ok")
            alert.show();
            
        }
        
        toggleMute()
    }
    
    func onAdColonyAdStartedInZone(zoneID: String) {
        
        toggleMute()
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
