//
//  Product.swift
//  Poil
//
//  Created by Ondrej Mekota on 24/06/16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import Foundation
import CoreData


class Product: NSManagedObject {
    
    class func addNewProducts(products: [ProductsModel.Product], inContext context: NSManagedObjectContext){
        for p in products{
            let existing = NSFetchRequest(entityName: "Product")
            existing.predicate = NSPredicate(format: "name = %@", p.name)
            let existingProduct = (try? context.executeFetchRequest(existing))?.first as? Product
            if existingProduct == nil {
                if let newProduct = NSEntityDescription.insertNewObjectForEntityForName("Product", inManagedObjectContext: context) as? Product{
                    newProduct.name = p.name
                    newProduct.palm = p.palm
                    newProduct.imagePath = p.imagePath
                
                }
            }
        }
    }
    class func getProducts(all:Bool, withPalmOil palmoil:Bool = false, fromContext context:NSManagedObjectContext) -> [Product]? {
        let request = NSFetchRequest(entityName: "Product")
        if !all {
            request.predicate = NSPredicate(format: "palm = %@", palmoil)
        }
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]

        if let results = try? (context.executeFetchRequest(request)) as? [Product]{
            return results
        }
        return nil
    }
//    class func getPicture(forProduct product:Product){
//        let docDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
//        return docDir?.URLByAppendingPathComponent(product.imagePath!)
//    }
    
}
