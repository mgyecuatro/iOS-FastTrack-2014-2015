//
//  BCModel.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 07/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation

//Simple singleton model
let globalModel : BCModel = BCModel()

final class BCModel {
   private let archivePath = pathToFileInDocumentsFolder("locations")
   private var arrayOfLocations = [CLLocation]()
   private let queue : dispatch_queue_t = dispatch_queue_create("uk.ac.plmouth.bc", DISPATCH_QUEUE_SERIAL)
   private let archiveKey = "LocationArray"
   private var _isEmpty : Bool = true
   
   // MARK: Life-cycle
   
   private init() {
      //Phase 1 has nothing to do
      
      //Call superclass if you subclass
//      super.init()
      
      //Phase 2 - super is now available
      if let m = NSKeyedUnarchiver.unarchiveObjectWithFile(self.archivePath) as? [CLLocation] {
         arrayOfLocations = m
      } else {
         arrayOfLocations = [CLLocation]()
      }
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
         NSKeyedArchiver.archiveRootObject(self.arrayOfLocations, toFile:self.archivePath)
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
      }
   }
   
   /// Erase all data (serialised on a background thread)
   func erase(done done : ()->() ) {
      dispatch_async(queue) {
         self.arrayOfLocations.removeAll()
         self._isEmpty = true
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
      }
   }
   
   /// Add a record (serialised on a background thread)
   func addRecord(record : CLLocation, done : ()->() ) {
      dispatch_async(queue){
         self.arrayOfLocations.append(record)
         self._isEmpty = false
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
      }
   }
   
   /// Add an array of records
   func addRecords(records : [CLLocation], done : ()->() ) {
      dispatch_async(queue){
         for r in records {
            self.arrayOfLocations.append(r)
         }
         self._isEmpty = false
         //Call back on main thread (posted to main runloop)
         dispatch_async(dispatch_get_main_queue(), done)
      }
   }
   
   /// Thread-safe read access
   func getArray(done done : (array : [CLLocation]) -> () ) {
      var copyOfArray : [CLLocation]!
      dispatch_async(queue){
         //Call back on main thread (posted to main runloop)
         copyOfArray = self.arrayOfLocations
         dispatch_async(dispatch_get_main_queue(), { done(array: copyOfArray) })
      }
   }
   
   /// Query if the container is empty
   func isEmpty(done done : (isEmpty : Bool) -> () ) {
      var result : Bool!
      dispatch_async(queue) {
         result = self._isEmpty
         dispatch_async(dispatch_get_main_queue(), { done(isEmpty: result) })
      }
   }
   
}
