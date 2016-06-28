//
//  ProductsModel.swift
//  Poil
//
//  Created by Ondrej Mekota on 18.06.16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import Foundation
import CoreData

class ProductsModel: NSObject {
    
    private static let docDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    
    private class func fileInDocumentsPath(fileName:String)-> NSURL?{
        
        return self.docDir?.URLByAppendingPathComponent(fileName)
    }
    
    private class func getProductNamesFromCSV() -> [String]{
        if let file = ProductsModel.fileInDocumentsPath("list.csv"){
            let productNames = ProductsListReader.retrieveNames(fromDocument: file)
            
            return productNames
        }
        return []
    }
    
    class func getProductList() ->[Product]{
        let names = getProductNamesFromCSV()
        var products:[Product] = []
        for index in Range(0..<names.count-1){
            products.append(Product(name: names[index], imagePath: getPicturePathForProduct(withId: index), palm: false))
        }
        return products
    }
    
    private class func getPicturePathForProduct(withId id:Int) -> NSData{
        
        let dir = "without/bez_"+String(id)+".jpg"
//        let dir = "without/bez_0.jpg"
        let imagePath = docDir?.URLByAppendingPathComponent(dir)
        let image = NSData(contentsOfFile: imagePath!.path!)
        return image!
    }
    
    struct Product {
        var name:String
        var imagePath:NSData
        var palm:Bool
       /*
        func newProduct(name:String, image:NSObjectFileImage, decription:String) ->Product {
            
        }*/
    }
}