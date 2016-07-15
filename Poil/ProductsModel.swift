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
    
    static let docDir = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
    
    class func fileInDocumentsPath(fileName:String)-> NSURL?{
        return self.docDir?.URLByAppendingPathComponent(fileName)
    }
    
    class func fileInBundle(fileName:String)-> NSURL?{
        let filePath = NSBundle.mainBundle().URLForResource(fileName, withExtension: "csv")
        return filePath
    }
    private class func getProductNamesFromCSV(fileName: String) -> [String]{
       // if let file = ProductsModel.fileInDocumentsPath(fileName){
        if let file = ProductsModel.fileInBundle(fileName){
            let productNames = ProductsListReader.retrieveNames(fromDocument: file)
            
            return productNames
        }
        return []
    }
    
    class func getProductList() ->[Product]{
//        let namesWithoutPalmOil = getProductNamesFromCSV("list_no_palm.csv")
//        let namesWithPalmOil = getProductNamesFromCSV("list_palm.csv")
        let namesWithoutPalmOil = getProductNamesFromCSV("list_no_palm")
        let namesWithPalmOil = getProductNamesFromCSV("list_palm")
        
        var products:[Product] = []
    
        //bez palmového oleje
        for index in Range(0..<namesWithoutPalmOil.count){
            //products.append(Product(name: namesWithoutPalmOil[index], imagePath: getPicturePathForProduct(withId: index, withPalmOil: false), palm: false))
            //let neco = Product(name: namesWithoutPalmOil[index], imagePath: getPictureForProductFromBundle(withId: index, withPalmOil: false), palm: false)
            products.append(Product(name: namesWithoutPalmOil[index], imagePath: getPictureForProductFromBundle(withId: index, withPalmOil: false), palm: false))
            //print(neco.imagePath)
        }
        
        //s palmovým olejem
        for index in Range(0..<namesWithPalmOil.count){
           // products.append(Product(name: namesWithPalmOil[index], imagePath: getPicturePathForProduct(withId: index, withPalmOil: true), palm: true))
            products.append(Product(name: namesWithPalmOil[index], imagePath: getPictureForProductFromBundle(withId: index, withPalmOil: true), palm: true))
        }
        
        return products
    }
    /*
    private class func getPicturePathForProduct(withId id:Int, withPalmOil palm: Bool) -> NSData{
        let dir = palm ? "images/s_"+String(id)+".jpg" : "images/bez_"+String(id)+".jpg"
        let imagePath = docDir?.URLByAppendingPathComponent(dir)
        
        let image = NSData(contentsOfFile: imagePath!.path!)
        return image!
    }
    */
    private class func getPictureForProductFromBundle(withId id:Int, withPalmOil palm: Bool) -> NSData{
        let name = palm ? "s_"+String(id) : "bez_"+String(id)
        let imageName = NSBundle.mainBundle().pathForResource(name, ofType: "jpg", inDirectory: "Data/images")
        if imageName != nil {
            if let file = NSData(contentsOfFile: imageName!){
                return file
            }
            else{
            print("nelze vytvo5it file\n\(imageName)")
            }
        }
        else{
            print("nelze naj9t image\n\(imageName)")
        }
        return NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("no_image", ofType: "png", inDirectory: "Data/images")!)!
    }
    /*
    private class func copyMissingImageToDocs(){
        let docsDir =  NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true).first
        let destPath4 = (docsDir! as NSString).stringByAppendingPathComponent("/no_image.png")
        if let path = NSBundle.mainBundle().pathForResource("no_image", ofType:"png") {
            _ = try? NSFileManager.defaultManager().copyItemAtPath(path, toPath: destPath4)
        }
        
    }
    */
    struct Product {
        var name:String
        var imagePath:NSData
        var palm:Bool
    }
}