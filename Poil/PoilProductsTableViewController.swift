//
//  PoilProductsTableViewController.swift
//  Poil
//
//  Created by Ondrej Mekota on 18.06.16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import UIKit
import CoreData

class PoilProductsTableViewController: UITableViewController {

    let searchController = UISearchController(searchResultsController: nil)
    
    var managedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var allProducts = [Product]()
    var searchedProducts = [Product]()
    
    func searchProducts(forFraze fraze: String, scope: String = "All"){
        searchedProducts = allProducts.filter { product in
            return (product.name?.lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale()).containsString(fraze.lowercaseString.stringByFoldingWithOptions(.DiacriticInsensitiveSearch, locale: NSLocale.currentLocale())))!
        }
        tableView.reloadData()
    }
    
    override func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //inicializace CoreData z CSV
        
//        for i in allProducts{
//           print("jmeno: \(i.name!), \(i.imagePath!)\n")
//        }
        tableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        print(ProductsModel.docDir)
        
        allProducts = Product.getProducts(true, fromContext: managedObjectContext!)!
     
        self.tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memory problem")
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    /*
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
*/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != ""{
            return  searchedProducts.count
        }
        return allProducts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let product = (searchController.active && searchController.searchBar.text != "") ? searchedProducts[indexPath.row] : allProducts[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as? PoilProductTableViewCell {
            cell.product = product
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //print("\(indexPath.row)\n")
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let sender = sender as? PoilProductTableViewCell {
            if let destinationViewController = segue.destinationViewController as? FullScreenImageViewController{
                destinationViewController.product = sender.product
                //destinationViewController.hidesBottomBarWhenPushed = true
            }
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}
extension PoilProductsTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController){
        searchProducts(forFraze: searchController.searchBar.text!)
    }
}
extension NSLayoutConstraint {
    override public var description:String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)"
    }
}
