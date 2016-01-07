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
   private var arrayOfLocations = [CLLocation]()
   let archivePath = pathForDocument("locations")
   
   required init?(coder aDecoder: NSCoder) {
      //Stage 2 initialisation
      super.init()
      
      //Decode if possible
      guard let arr = aDecoder.decodeObjectForKey("Locations") as? [CLLocation] else {
         return nil
      }
      arrayOfLocations = arr
   }
   
   /// Encodes the data in one step
   func encodeWithCoder(aCoder: NSCoder) {
      aCoder.encodeObject(arrayOfLocations, forKey: "Locations")
   }
   
   /// Add location to the array
   func save()
   {
      guard let path = archivePath else {
         return
      }
      
      //Save on a background thread
      let q : dispatch_queue_t  = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
      dispatch_async(q) {
         NSKeyedArchiver.archiveRootObject(self, toFile:path)
      }
         
   }
   
}
