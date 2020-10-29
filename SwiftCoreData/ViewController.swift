//
//  ViewController.swift
//  SwiftCoreData
//
//  Created by Bill Martensson on 2020-10-29.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

    @IBOutlet weak var shopTextfield: UITextField!
    @IBOutlet weak var shopTableview: UITableView!
    
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context : NSManagedObjectContext!
    
    var shoppingItems = [ShopItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        context = appDelegate.persistentContainer.viewContext
        
        shopTableview.dataSource = self
        shopTableview.delegate = self
        
        /*
        var thingToBuy = ShopItem(context: context)
        thingToBuy.title = "Äpple"
        thingToBuy.amount = 50
        thingToBuy.isBought = true
        
        do {
            try context.save()
        } catch {
            
        }
        */
        
        /*
        let getShop : NSFetchRequest<ShopItem> = ShopItem.fetchRequest()
        
        let sorting = NSSortDescriptor(key: "title", ascending: false)
        
        getShop.sortDescriptors = [sorting]
        
        getShop.predicate = NSPredicate(format: "isBought == false")
        
        do {
            let shopStuff = try context.fetch(getShop)
            
            for shopthing in shopStuff
            {
                print(shopthing.title)
            }
            
        } catch {
            
        }
        */
        
        loadShopping()
    }

    func loadShopping()
    {
        let getShop : NSFetchRequest<ShopItem> = ShopItem.fetchRequest()
        
        let sorting = NSSortDescriptor(key: "isBought", ascending: true)
        
        getShop.sortDescriptors = [sorting]
        
        do {
            shoppingItems = try context.fetch(getShop)
            shopTableview.reloadData()
        } catch {
            
        }
    }
    
    @IBAction func addShop(_ sender: Any) {
        
        var thingToBuy = ShopItem(context: context)
        thingToBuy.title = shopTextfield.text
        thingToBuy.amount = 1
        thingToBuy.isBought = false
        
        do {
            try context.save()
            loadShopping()
        } catch {
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currentShopItem = shoppingItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "shopcell")
        
        if(currentShopItem.isBought == true)
        {
            cell?.backgroundColor = UIColor.green
        } else {
            cell?.backgroundColor = UIColor.white
        }
        
        cell?.textLabel?.text = "\(currentShopItem.title!) \(currentShopItem.amount) st"
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentShopItem = shoppingItems[indexPath.row]
        
        if(currentShopItem.isBought == true)
        {
            currentShopItem.isBought = false
        } else {
            currentShopItem.isBought = true
        }
        
        do {
            try context.save()
            loadShopping()
        } catch {
            
        }
        
    }
}

