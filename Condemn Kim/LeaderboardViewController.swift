//
//  LeaderboardViewController.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 11/14/15.
//  Copyright © 2015 Brandon Lassiter. All rights reserved.
//

import UIKit
import Parse

class LeaderboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var items: [PFObject] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.registerNib(UINib(nibName: "LeaderboardCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "cell")
        self.tableView.registerNib(UINib(nibName: "LeaderboardHeaderCell", bundle: NSBundle.mainBundle()), forHeaderFooterViewReuseIdentifier: "HeaderCell");
        
        getLeaderboard()
        
    }

    
    func getLeaderboard() {
    
        print("Getting leaderboard");
        let query = PFUser.query();
        
        query!.addDescendingOrder("level");
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if(error == nil) {
                
                print("Object Count: \(objects!.count)")
                print("Objects: \(objects!)")
                self.items = objects!;
                self.tableView.reloadData();
                
            }
            
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1;
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return items.count;
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:LeaderboardCell = self.tableView.dequeueReusableCellWithIdentifier("cell")! as! LeaderboardCell
        
        let user : PFObject = self.items[indexPath.row];
        cell.nameLabel.text = user.valueForKey("name") as? String;
        
        let level = user.valueForKey("level");
        cell.scoreLabel.text = "\(level!)"
        cell.positionLabel.text = "\(indexPath.row + 1)";
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let cell = self.tableView.dequeueReusableHeaderFooterViewWithIdentifier("HeaderCell");
        cell!.backgroundColor = UIColor.blackColor();
        
        return cell;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
}
