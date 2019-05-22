//
//  ViewController.swift
//  AQMSIOS
//
//  Created by Diego Moreno on 14/05/19.
//  Copyright © 2019 Diego Moreno. All rights reserved.
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
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var baseRef: DatabaseReference!
        baseRef = Database.database().reference()
        
        baseRef.child("Data").queryLimited(toLast: 1).observe(.value, with: { snapshot in
            let snapshotval = snapshot.value as? NSDictionary
            
            for (_, value) in snapshotval! {
//                print(key, value)
                let innerDict:NSDictionary = value as! NSDictionary
                self.setDataInTags(innerDict)
                self.setTvocQuality(innerDict.value(forKey: "tvoc") as! Double)
                self.setCo2Quality(innerDict.value(forKey: "co2") as! Double)
                self.setTempQuality(innerDict.value(forKey: "temperature") as! Double)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDataInTags(_ dict: NSDictionary){
        self.tvocdata.text = String(dict.value(forKey: "tvoc") as! Double)
        self.co2data.text = String(dict.value(forKey: "co2") as! Double)
        self.tempdata.text = String(dict.value(forKey: "temperature") as! Double)
        self.humdata.text = String(dict.value(forKey: "humidity") as! Double)
    }
    
    func setTvocQuality(_ data: Double){
        if data >= 500{
            self.indicatortvoc.image = UIImage(named: "Mild Quality.png")
        }else if data >= 1000{
            self.indicatortvoc.image = UIImage(named: "Bad Quality.png")
        }else {
            self.indicatortvoc.image = UIImage(named: "Good Quality.png")
        }
    }
    
    func setCo2Quality(_ data: Double){
        if data >= 1000{
            self.indicatorco2.image = UIImage(named: "Mild Quality.png")
        }else if data >= 5000{
            self.indicatorco2.image = UIImage(named: "Bad Quality.png")
        }else {
            self.indicatorco2.image = UIImage(named: "Good Quality.png")
        }
    }
    
    func setTempQuality(_ data: Double){
        if data >= 18{
            self.indicatortemp.image = UIImage(named: "Good Quality.png")
        }else if data >= 25{
            self.indicatortemp.image = UIImage(named: "Mild Quality.png")
        }else if data >= 32{
            self.indicatortemp.image = UIImage(named: "Hot.png")
        }else {
            self.indicatortemp.image = UIImage(named: "Cold.png")
        }
    }

}

