//
//  BCModel.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 07/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import UIKit
import CoreLocation

class BCModel: NSObject, NSCoding {
   private var arrayOfLocations : [CLLocation]
   private let archivePath = pathToFileInDocumentsFolder("locations")
   private let queue : dispatch_queue_t = dispatch_queue_create("uk.ac.plmouth.bc", DISPATCH_QUEUE_SERIAL)
   private let archiveKey = "LocationArray"
   
   init(withArray a : [CLLocation]) {
      arrayOfLocations = a
      super.init()
   }
   
   required convenience init?(coder aDecoder: NSCoder) {
      
      //Decode if possible
      guard let arr = aDecoder.decodeObjectForKey("LocationArray") as? [CLLocation] else {
         return nil
      }
      
      self.init(withArray: arr)
   }
   
   /// Encodes the data in one step
   func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(arrayOfLocations, forKey: "LocationArray")
   }
   
   /// Save the array to persistant storage (simple method)
   func save(done done : ()->() )
   {
      //Save on a background thread - note this is a serial queue, so multiple calls to save will be performed
      //in strict sequence (to avoid races)
      dispatch_async(queue) {
         //Persist data to file
         NSKeyedArchiver.archiveRootObject(self, toFile:self.archivePath)
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
      }
   }
   
   // Erase all data
   func erase() {
      arrayOfLocations.removeAll()
      save(done: { })
   }
   
}
