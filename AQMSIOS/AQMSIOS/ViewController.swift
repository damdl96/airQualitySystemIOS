//
//  ViewController.swift
//  AQMSIOS
//
//  Created by EhecatlSystems on 14/05/19.
//  Copyright © 2019 EhecatlSystems. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {
    
    @IBOutlet weak var tvocdata: UILabel!
    @IBOutlet weak var co2data: UILabel!
    @IBOutlet weak var tempdata: UILabel!
    @IBOutlet weak var humdata: UILabel!
    @IBOutlet weak var indicatortvoc: UIImageView!
    @IBOutlet weak var indicatorco2: UIImageView!
    @IBOutlet weak var indicatortemp: UIImageView!
    @IBOutlet weak var dabackground: UIImageView!
    
    
    
    override func viewDidLoad() {
        dabackground.layer.cornerRadius = 8.0
        super.viewDidLoad()
        
        var baseRef: DatabaseReference!
        baseRef = Database.database().reference()
        
        var i: Int = 0
        var hum:Double = 0
        var co2:Double = 0
        var heaIn:Double = 0
        var temp:Double = 0
        var tvoc:Double = 0
        
        
//        Ill leave the prints to console commented so if you want to check the data that the app is reciving

        
        //        baseRef.child("Data").observe(.value, with: { snapshot in
//            print(snapshot.value as Any)
//        })
        
        baseRef.child("Data").queryLimited(toLast: 1).observe(.value, with: { snapshot in
            let snapshotval = snapshot.value as? NSDictionary
            
            for (_, value) in snapshotval! {
//                print(key, value)
                let innerDict:NSDictionary = value as! NSDictionary
                for (_, v) in innerDict {
//                    print(k, v)
                    if i == 0{
                        hum = v as! Double
//                        print(hum)
                    }
                    if i == 1{
                        co2 = v as! Double
//                        print(co2)
                    }
                    if i == 2{
                        heaIn = v as! Double
//                        print(heaIn)
                    }
                    if i == 3{
                        temp = v as! Double
//                        print(temp)
                    }
                    if i == 5{
                        tvoc = v as! Double
//                        print(tvoc)
                    }
                    i = i+1
                }
                i = 0
            }
            
            self.tvocdata.text = String(tvoc)
            self.co2data.text = String(co2)
            self.tempdata.text = String(temp)
            self.humdata.text = String(hum)
            
            if tvoc >= 500{
                self.indicatortvoc.image = UIImage(named: "Mild Quality.png")
            }else if tvoc >= 1000{
                self.indicatortvoc.image = UIImage(named: "Bad Quality.png")
            }else {
                self.indicatortvoc.image = UIImage(named: "Good Quality.png")
            }
            
            if co2 >= 1000{
                self.indicatorco2.image = UIImage(named: "Mild Quality.png")
            }else if temp >= 5000{
                self.indicatorco2.image = UIImage(named: "Bad Quality.png")
            }else {
                self.indicatorco2.image = UIImage(named: "Good Quality.png")
            }
            
            if temp >= 18{
                self.indicatortemp.image = UIImage(named: "Good Quality.png")
            }else if temp >= 25{
                self.indicatortemp.image = UIImage(named: "Mild Quality.png")
            }else if temp >= 32{
                self.indicatortemp.image = UIImage(named: "Hot.png")
            }else {
                self.indicatortemp.image = UIImage(named: "Cold.png")
            }
            print("\n")
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

