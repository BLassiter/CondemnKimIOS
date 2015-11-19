//
//  StoreViewController.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 11/19/15.
//  Copyright © 2015 Brandon Lassiter. All rights reserved.
//

import UIKit
import Parse

class StoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SupersonicOWDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var items : NSMutableArray = [];
    
    var presentingScene : GameScene?;
    
    @IBOutlet weak var creditsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Supersonic.sharedInstance().setOWDelegate(self);
        SUSupersonicAdsConfiguration.getConfiguration().useClientSideCallbacks = NSNumber(int: 1);
        
        Supersonic.sharedInstance().initOWWithAppKey("41c6ad85", withUserId: (PFUser.currentUser() != nil) ? PFUser.currentUser()?.objectId : "CondemnKimUserID");
        
        
        // Do any additional setup after loading the view.
        items = NSMutableArray();
        
        let paper = StoreItem(image: UIImage(named: "licensebackground.png")!, cost: 0, _filename: "marriagelicense");
        items.addObject(paper);
        
        let tomato = StoreItem(image: UIImage(named: "tomatobackground.png")!, cost: 100, _filename: "tomato.png");
        items.addObject(tomato);
        
        let rock = StoreItem(image: UIImage(named: "rockbackground.png")!, cost: 100, _filename: "rock.png");
        items.addObject(rock);
        
        let chair1 = StoreItem(image: UIImage(named: "chair1background.png")!, cost: 100, _filename: "chair1.png");
        items.addObject(chair1);
        
        let chair2 = StoreItem(image: UIImage(named: "chair2background.png")!, cost: 100, _filename: "chair2.png");
        items.addObject(chair2);
        
        let shoe1 = StoreItem(image: UIImage(named: "shoe1background.png")!, cost: 100, _filename: "shoe1.png");
        items.addObject(shoe1);
        
        let shoe2 = StoreItem(image: UIImage(named: "shoe2background.png")!, cost: 100, _filename: "shoe2.png");
        items.addObject(shoe2);
        
        let shoe3 = StoreItem(image: UIImage(named: "shoe3background.png")!, cost: 100, _filename: "shoe3.png");
        items.addObject(shoe3);
        
        let flag1 = StoreItem(image: UIImage(named: "flag1background.png")!, cost: 100, _filename: "flag1.png");
        items.addObject(flag1);
        
        let flag2 = StoreItem(image: UIImage(named: "flag2background.png")!, cost: 100, _filename: "flag2.png");
        items.addObject(flag2);
        
        let flag3 = StoreItem(image: UIImage(named: "flag3background.png")!, cost: 100, _filename: "flag3.png");
        items.addObject(flag3);
        
        self.tableView.registerNib(UINib(nibName: "StoreCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell");
        
        var numCredits : Int? = NSUserDefaults.standardUserDefaults().valueForKey("credits") as? Int;
        
        if(numCredits == nil) {
            numCredits = 0;
            NSUserDefaults.standardUserDefaults().setValue(numCredits, forKey: "credits");
        }
        
        creditsLabel.text = "\(numCredits!)";
        
        var purchasedItems = NSUserDefaults.standardUserDefaults().dictionaryForKey("purchased");
        
        if(purchasedItems == nil) {
            purchasedItems = Dictionary<String, AnyObject>();
            purchasedItems!["marriagelicense"] = 1;
            NSUserDefaults.standardUserDefaults().setValue(purchasedItems, forKey: "purchased");
        }
        
        self.tableView.reloadData();
        
    }
    
    func supersonicOWDidReceiveCredit(creditInfo: [NSObject : AnyObject]!) -> Bool {
        
        
        var curCredits = NSUserDefaults.standardUserDefaults().integerForKey("credits");
        
        for (key, value) in creditInfo {
            
            if(key == "credits") {
                
                let newCredits = (value as! NSString).integerValue;
                curCredits += newCredits;
            }
        }
        
        
        NSUserDefaults.standardUserDefaults().setValue(curCredits, forKey: "credits");
        
        updateCreditsLabel();
        
        return true;
        
    }
    
    func updateCreditsLabel() {
        creditsLabel.text = "\(NSUserDefaults.standardUserDefaults().integerForKey("credits"))";
        
        if(PFUser.currentUser() != nil) {
            let user = PFUser.currentUser();
            user!.setValue(NSUserDefaults.standardUserDefaults().integerForKey("credits"), forKey: "credits");
            user!.saveInBackground();
        }
        
    }
    
    func supersonicOWAdClosed() {
        
    }
    
    func supersonicOWFailGettingCreditWithError(error: NSError!) {
        print("Error: \(error)");
    }
    
    func supersonicOWInitFailedWithError(error: NSError!) {
        print("Error: \(error)");
    }
    
    func supersonicOWInitSuccess() {
        
    }
    
    func supersonicOWShowFailedWithError(error: NSError!) {
        print("Error: \(error)");
    }
    
    func supersonicOWShowSuccess() {
        
    }
    

    @IBAction func addCredits(sender: AnyObject) {
        
        print("Get more credits!");
        Supersonic.sharedInstance().showOW();
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil);
        
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell : StoreCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! StoreCell;
        
        let item = items[indexPath.row] as! StoreItem;
        cell.backgroundImage.image = item.backgroundImage!;
        cell.cost = item.cost;
        
        var purchasedItems = NSUserDefaults.standardUserDefaults().dictionaryForKey("purchased");
        
        print("purchased: \(purchasedItems)");
        var alreadyPurchased = false;
        
        let filename : String = item.filename;
        
        if(purchasedItems == nil) {
            purchasedItems = Dictionary<String, AnyObject>();
            purchasedItems!["license"] = 1;
        }
        
        print("Items: \(purchasedItems)");
        for(key, value) in purchasedItems! {
            
            print("\(key) : \(value)");
            
            if(key == filename) {
                alreadyPurchased = true;
            }
            
        }
        
        if(alreadyPurchased) {
            
            if(NSUserDefaults.standardUserDefaults().stringForKey("throwable") == filename) {
                cell.buyButton.setImage(UIImage(named: "selected.png"), forState: UIControlState.Normal);
            } else {
                cell.buyButton.setImage(UIImage(named: "select.png"), forState: UIControlState.Normal);
            }
            
        } else {
            cell.buyButton.setImage(UIImage(named: "buybutton100.png"), forState: UIControlState.Normal);
        }
        
        cell.buyButton.tag = indexPath.row;
        cell.buyButton.addTarget(self, action: "buttonClicked:", forControlEvents: .TouchUpInside)
        
        return cell;
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100;
    }
    
    func buttonClicked(sender: AnyObject?) {
        
        let itemPurchased : StoreItem = items[sender!.tag] as! StoreItem;
        
        var purchasedItems = NSUserDefaults.standardUserDefaults().dictionaryForKey("purchased");
        
        var alreadyPurchased = false;
        
        let filename : String = itemPurchased.filename;
        
        if(purchasedItems == nil) {
            purchasedItems = Dictionary<String, AnyObject>();
        }
        
        for(key, value) in purchasedItems! {
            
            print("\(key) : \(value)");
            
            if(key == filename) {
                alreadyPurchased = true;
            }
            
        }
        
        if(alreadyPurchased) {
            NSUserDefaults.standardUserDefaults().setValue(filename, forKey: "throwable");
        } else {
            
            var numCredits = NSUserDefaults.standardUserDefaults().integerForKey("credits");
            
            if(numCredits - itemPurchased.cost < 0) {
               
                let alert = UIAlertView(title: "Not Enough Credits", message: "You do not have enough credits to purchase this item. You can earn more credits by tapping the plus icon at the top of the page.", delegate: nil, cancelButtonTitle: "Ok");
                alert.show();
                
            } else {
                
                numCredits -= itemPurchased.cost;
                NSUserDefaults.standardUserDefaults().setValue(filename, forKey: "throwable");
                NSUserDefaults.standardUserDefaults().setValue(numCredits, forKey: "credits");
                purchasedItems![itemPurchased.filename] = true;
                
                NSUserDefaults.standardUserDefaults().setValue(purchasedItems, forKey: "purchased");
                updateCreditsLabel()
                self.tableView.reloadData();
            }
            
        }
        
        presentingScene!.changeThrowable();
        
        self.tableView.reloadData();
        
        
    }

}
