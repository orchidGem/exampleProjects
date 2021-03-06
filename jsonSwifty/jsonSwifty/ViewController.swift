
//
//  TableViewController.swift
//  jsonSwifty
//
//  Created by Laura Evans on 11/23/16.
//  Copyright © 2016 Laura Evans. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableViewController: UITableViewController {
    
    var names = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //parseJSONWithSwiftyJSON()
        parseJSONTheNotSoFunWay()
    }

    //MARK: Methods
    
    // parse data with Swifty JSON :)
    func parseJSONWithSwiftyJSON() {
        
        // get file and apply it to a path
        let path = Bundle.main.path(forResource: "jsonFile", ofType: "json")
        
        //Grab json data and apply to to NSData
        let jsonData = NSData(contentsOfFile: path!)
        
        // Make json more readable (comes from swifty json)
        let readableJSON = JSON(data: jsonData as! Data)
        
        let name = readableJSON["People"]["Person1"]["Name"]
        print(name)
        
        let numPeople = readableJSON["People"].count
        
        for i in 1...numPeople {
            let person = "Person\(i)"
            let name = readableJSON["People"][person]["Name"].stringValue
            print(name)
            names.append(name)
        }
        self.tableView.reloadData()
        print(names)
    }
    
    // parse data without Swifty JSON :(
    func parseJSONTheNotSoFunWay() {
        
        // get file and apply it to a path
        let path = Bundle.main.path(forResource: "jsonFile", ofType: "json")
        
        //Grab json data and apply to to NSData
        let jsonData = NSData(contentsOfFile: path!)
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData! as Data, options: .allowFragments)
            if let json = jsonObject as? [String: AnyObject] {
                
                print("Printing JSON")
                print(json)
                
                guard let people = json["People"] as? [String: AnyObject] else {
                    print("could not parse people")
                    return
                }
                
                print("Printing Number of People")
                print(people.count)
                
                for i in 1...people.count {
                    
                    guard let person = people["Person\(i)"] as? [String: AnyObject] else {
                        print("could not parse person")
                        return
                    }
                    
                    names.append(person["Name"] as! String)
                    self.tableView.reloadData()
                    print(names)
                    
                }
                
            }
        } catch {
            // Handle Error
        }
    }

    
    
    
    //MARK: Tableview methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = names[indexPath.row]
        return cell!
    }

}

