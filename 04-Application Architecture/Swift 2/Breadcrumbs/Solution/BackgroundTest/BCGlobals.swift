//
//  BCGlobals.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 04/12/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import Foundation
let globalDocumentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).first

func pathForDocument(filename : String) -> String? {
   guard let gPath = globalDocumentsPath else {
      return nil
   }
   
   return NSString(string: gPath).stringByAppendingPathComponent(filename) as String
}
//let globalPath = globalDocumentsPath?.stringByAppendingString("/Options")
