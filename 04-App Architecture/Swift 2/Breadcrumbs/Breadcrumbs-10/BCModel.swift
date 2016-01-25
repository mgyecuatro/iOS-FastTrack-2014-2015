//
//  BCModel.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 25/01/2016.
//  Copyright © 2016 Plymouth University. All rights reserved.
//

import Foundation
import CoreLocation

let globalModel : BCModel = BCModel()

final class BCModel {
    
    private var arrayOfLocations = [CLLocation]()
    private let archivePath = pathToFileInDocumentsFolder("locations")
    private let archiveKey = "LocationArray"
    
    private let queue : dispatch_queue_t = dispatch_queue_create("uk.ac.plymouth.bc", DISPATCH_QUEUE_SERIAL)
    
    private init() {
        //Phase 1 init - nothing to do!

        //super.init()
        
        //Phase 2
        if let m = NSKeyedUnarchiver.unarchiveObjectWithFile(self.archivePath) as? [CLLocation] {
            arrayOfLocations = m
        }

    }
    
    // MARK: - Asynchronous API
    func addRecord(record: CLLocation, done : ()->()) {
        let r = CLLocation(latitude: record.coordinate.latitude, longitude: record.coordinate.longitude)
        dispatch_async(queue) {
            self.arrayOfLocations.append(r)
            dispatch_sync(dispatch_get_main_queue(), done)
        }
    }
    /// Add an array of records
    func addRecords(records : [CLLocation], done : ()->() ) {
        //Make a copy
        let myCopy = records.map() { CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude) } //Not lazy any more
        //Append on the queue
        dispatch_async(queue){
            for r in myCopy {
                self.arrayOfLocations.append(r)
            }
            //Call back on main thread (posted to main runloop)
            dispatch_sync(dispatch_get_main_queue(), done)
        }
    }
    /// Thread-safe read access
    func getArray(done done : (array : [CLLocation]) -> () ) {
        dispatch_async(queue){
            let copyOfArray = self.arrayOfLocations.map() {
                CLLocation(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude)
            }
            //Call back on main thread (posted to main runloop)
            dispatch_sync(dispatch_get_main_queue(), { done(array: copyOfArray) })
        }
    }
    
    /// Query if the array is empty
    func isEmpty(done done : (isEmpty : Bool) -> () ) {
        dispatch_async(queue) {
            let result = self.arrayOfLocations.count == 0 ? true : false
            dispatch_sync(dispatch_get_main_queue(), { done(isEmpty: result) })
        }
    }
}
