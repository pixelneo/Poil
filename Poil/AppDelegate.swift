//
//  AppDelegate.swift
//  Poil
//
//  Created by Ondrej Mekota on 18.06.16.
//  Copyright © 2016 Ondrej Mekota. All rights reserved.
//

import UIKit
import Foundation
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
       
        return true
    }
    func applicationDidFinishLaunching(application: UIApplication) {
        // copyImagesAndListOfProductsToDocuments()
        if isFirstLaunch(){
            print("neco")
            loadCSV()
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.ondrejmekota.Poil" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Poil", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    func isFirstLaunch() -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let _ = defaults.stringForKey("launched"){
            return false
        }
        else{
            defaults.setBool(true, forKey: "launched")
            return true
        }
    }
    
    func loadCSV(){
        let products = ProductsModel.getProductList()
        
        //TODO: vyřešit aby main queue nečekala
        managedObjectContext.performBlockAndWait(){
            Product.addNewProducts(products, inContext: self.managedObjectContext)
            _ = try? self.managedObjectContext.save()
        }
       
    }
    
    //isn't used, data is loaded to core data straight from bundle
    func copyImagesAndListOfProductsToDocuments(){
        let fileMgr = NSFileManager.defaultManager()
        let docDir = fileMgr.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first
        if !fileMgr.fileExistsAtPath(docDir!.URLByAppendingPathComponent("list_palm.csv").path!) {
            _ = try? fileMgr.createDirectoryAtURL((docDir!.URLByAppendingPathComponent("images")), withIntermediateDirectories: false, attributes: nil)
            let imagesDir = docDir!.URLByAppendingPathComponent("images")
            let imagesNames = NSBundle.mainBundle().pathsForResourcesOfType("jpg", inDirectory: "Data/images")
            let csvListsNames = NSBundle.mainBundle().pathsForResourcesOfType("csv", inDirectory: "Data")
            for image in imagesNames{
                let imageName = NSURL(fileURLWithPath: image).lastPathComponent
                do {
                    try fileMgr.copyItemAtURL(NSURL(fileURLWithPath: image), toURL: imagesDir.URLByAppendingPathComponent(imageName!))
                }catch let error{
                    print(error)
                }
            }
            
            for list in csvListsNames {
                let fileName = NSURL(fileURLWithPath: list).lastPathComponent
                do {
                    try fileMgr.copyItemAtURL(NSURL(fileURLWithPath: list), toURL: docDir!.URLByAppendingPathComponent(fileName!))
                }catch let error{
                    print(error)
                }
            }
        }
    }
    
    
    //supposes that all data are stored in dtb, not external storage (large images)... therefore doesn't work :-{
    func copyDatabaseToDocuments(){
        let dirPaths =  NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)
        let docsDir = dirPaths[0]
        let destPath1 = (docsDir as NSString).stringByAppendingPathComponent("/SingleViewCoreData.sqlite")
        let destPath2 = (docsDir as NSString).stringByAppendingPathComponent("/SingleViewCoreData.sqlite-shm")
        let destPath3 = (docsDir as NSString).stringByAppendingPathComponent("/SingleViewCoreData.sqlite-wal")
        let destPath4 = (docsDir as NSString).stringByAppendingPathComponent("/no_image.png")

        let fileMgr = NSFileManager.defaultManager()
        
        if let path = NSBundle.mainBundle().pathForResource("SingleViewCoreData", ofType:"sqlite") {
            _ = try? fileMgr.copyItemAtPath(path, toPath: destPath1)
        }
        if let path = NSBundle.mainBundle().pathForResource("SingleViewCoreData", ofType:"sqlite-shm") {
            _ = try? fileMgr.copyItemAtPath(path, toPath: destPath2)
        }
        if let path = NSBundle.mainBundle().pathForResource("SingleViewCoreData", ofType:"sqlite-wal") {
            _ = try? fileMgr.copyItemAtPath(path, toPath: destPath3)
        }
        if let path = NSBundle.mainBundle().pathForResource("no_image", ofType:"png") {
            _ = try? fileMgr.copyItemAtPath(path, toPath: destPath4)
        }
       
    }
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        //self.copyDatabaseToDocuments()
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

