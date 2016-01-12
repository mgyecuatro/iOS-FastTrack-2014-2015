//
//  BCModel.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 07/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit
import CoreLocation

let globalModel : BCModel = BCModel.modelFromArchive()

final class BCModel: NSObject, NSCoding {
   static let archivePath = pathToFileInDocumentsFolder("locations")
   private var arrayOfLocations = [CLLocation]()
   private let queue : dispatch_queue_t = dispatch_queue_create("uk.ac.plmouth.bc", DISPATCH_QUEUE_SERIAL)
   private let archiveKey = "LocationArray"
   
   // MARK: Life-cycle
   
//   override init() {
//      super.init()
//   }
   
   // Static function to return an initialised object - similar to a conveneince initialiser.
   private static func modelFromArchive() -> BCModel {
      
      guard let m = NSKeyedUnarchiver.unarchiveObjectWithFile(BCModel.archivePath) as? BCModel else {
         return BCModel()
      }
      return m
   }
   
   // MARK: NSCoding
   required convenience init?(coder aDecoder: NSCoder) {
      //Nothing to do in phase 1
      
      //Pass accross to the designated initialiser
      self.init()
      
      //Decode if possible
      guard let arr = aDecoder.decodeObjectForKey(archiveKey) as? [CLLocation] else {
         return nil
      }
      arrayOfLocations = arr
   }

   // Encodes the data in one step
   func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(arrayOfLocations, forKey: archiveKey)
   }
   
   // MARK: Public API
   
   // All these methods are serialsed on a background thread. KEY POINT: None can preempt the other.
   // For example, if save is called multiple times, each save operation will complete before the next is allowed to start.
   //
   // Furthermore, if an addRecord is called, but there is a save in front, this could take a significant time.
   // As everthing is queued on a separate thread, there is no risk of blocking the main thread.
   // Each method invokes a closure on the main thread when completed
   
   /// Save the array to persistant storage (simple method) serialised on a background thread
   func save(done done : ()->() )
   {
      //Save on a background thread - note this is a serial queue, so multiple calls to save will be performed
      //in strict sequence (to avoid races)
      dispatch_async(queue) {
         //Persist data to file
         NSKeyedArchiver.archiveRootObject(self, toFile:BCModel.archivePath)
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
      }
   }
   
   /// Erase all data (serialised on a background thread)
   func erase(done done : ()->() ) {
      dispatch_async(queue) {
         self.arrayOfLocations.removeAll()
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
         
      }
   }
   
   /// Add a record (serialised on a background thread)
   func addRecord(record : CLLocation, done : ()->() ) {
      dispatch_async(queue){
         self.arrayOfLocations.append(record)
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
      }
   }
   
}
