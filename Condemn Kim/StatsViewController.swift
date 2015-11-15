//
//  StatsViewController.swift
//  Condemn Kim
//
//  Created by Brandon lassiter on 11/14/15.
//  Copyright © 2015 Brandon Lassiter. All rights reserved.
//

import UIKit
import Parse

class StatsViewController: UIViewController {

    @IBOutlet weak var gamesPlayed: UILabel!
    @IBOutlet weak var gamesWon: UILabel!
    @IBOutlet weak var gamesLost: UILabel!
    @IBOutlet weak var numberOfThrows: UILabel!
    @IBOutlet weak var numberOfHits: UILabel!
    @IBOutlet weak var numberOfMisses: UILabel!
    @IBOutlet weak var divorcesUsed: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        loadStats();
        
    }

    @IBAction func goBack(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

    func loadStats() {
        
        if(PFUser.currentUser() != nil) {
            
            let user = PFUser.currentUser();
            
            var a = user!.valueForKey("gamesPlayed")
            var b = user!.valueForKey("gamesWon")
            var c = user!.valueForKey("gamesLost")
            var d = user!.valueForKey("numberOfThrows")
            var e = user!.valueForKey("numberOfHits")
            var f = user!.valueForKey("numberOfMisses")
            var g = user!.valueForKey("divorcesUsed")
            
            gamesPlayed.text = "\(a!)";
            gamesWon.text = "\(b!)";
            gamesLost.text = "\(c!)";
            numberOfThrows.text = "\(d!)";
            numberOfHits.text = "\(e!)";
            numberOfMisses.text = "\(f!)";
            divorcesUsed.text = "\(g!)";
            
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
