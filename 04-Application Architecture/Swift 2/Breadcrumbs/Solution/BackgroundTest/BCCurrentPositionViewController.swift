//
//  ViewController.swift
//  BackgroundTest
//
//  Created by Nicholas Outram on 30/11/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class BCCurrentPositionViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, BCOptionsSheetDelegate {

   // **********************
   // MARK: Enumerated types
   // **********************
   
   /// The application state - "where we are in a known sequence"
   enum AppState {
      case WaitingForViewDidLoad
      case RequestingAuth
      case LiveMapNoLogging
      case LiveMapLogging
      
      init() {
         self = .WaitingForViewDidLoad
      }
      
      /// Returns a dictionary with a string description of a state
      func dict() -> [AppState : String] {
         let dict : [AppState : String] = [
            .WaitingForViewDidLoad : "Wating for ViewDidLoad",
            .RequestingAuth        : "Requesting Authorisation",
            .LiveMapNoLogging      : "Live Map with no location logging",
            .LiveMapLogging        : "Live Map with location Logging"
         ]
         return dict
      }
   }
   
   /// The type of input (and its value) applied to the state machine
   enum AppStateInputSource {
      case None
      case Start
      case AuthorisationStatus(Bool)
      case UserWantsToStart(Bool)
   }
   
   // *************
   // MARK: Outlets
   // *************
   
   @IBOutlet weak var startButton: UIBarButtonItem!
   @IBOutlet weak var stopButton: UIBarButtonItem!
   @IBOutlet weak var optionsButton: UIBarButtonItem!
   @IBOutlet weak var mapView: MKMapView!

   // ****************
   // MARK: Properties
   // ****************
   
   /// Appliction state. Important to manage the possible sequence of events that can occur in an app life cycle
   /// - warning: Should only be set via the `updateStateWithInput()` method
   private var state : AppState     = AppState() {
      willSet {
         //Useful logging info
         if let strOldState = state.dict()[state], strNewState = state.dict()[newValue] where strOldState != strNewState {
            print("Changing from state \(strOldState) to state \"\(strNewState)\"")
         }
      }
      didSet {
         //If the state changes, so the output changes immediately
         self.updateOutputWithState()
      }
   }
   
   ///Default set of options (backed by user defaults)
   private var options : BCOptions = BCOptions() {
      didSet {
         //Persist the options to user defaults
         options.updateDefaults()
      }
   }

   ///This property is "lazy". Only runs once, when the property is first referenced
   lazy var locationManager : CLLocationManager = {
      [unowned self] in
      print("Instantiating and initialising the location manager \"lazily\"")
      print("This will only run once")
      let loc = CLLocationManager()
      
      //Set up location manager with defaults
      loc.desiredAccuracy = kCLLocationAccuracyBest
      loc.distanceFilter = kCLDistanceFilterNone
      loc.delegate = self
      
      //Optimisation of battery
      loc.pausesLocationUpdatesAutomatically = true
      loc.activityType = CLActivityType.Fitness
      loc.allowsBackgroundLocationUpdates = false
      
      return loc
   }()               //Note the parenthesis
   
   //Internal flag for deferred updates
   var deferringUpdates : Bool = false
   
   //Array of GPS locations
   var arrayOfLocations = [CLLocation]()
   
   // ************************
   // MARK: Class Initialisers
   // ************************
   
   override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
      print("\(__FILE__), \(__FUNCTION__)")
      super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
   }
   required init?(coder aDecoder: NSCoder) {
      print("\(__FILE__), \(__FUNCTION__)")
      super.init(coder: aDecoder)
   }
   
   // MARK: Bringing the controller up
   override func awakeFromNib() {
      print("\(__FILE__), \(__FUNCTION__)")
   }
   
   // *******************************************
   // MARK: UIViewController specific lifecycle
   // *******************************************
   
   override func viewDidLoad() {
      print("\(__FILE__), \(__FUNCTION__)")
      super.viewDidLoad()
      
      // Do any additional setup after loading the view, typically from a nib.
      
      //Set initial app state - this kicks off everything else
      self.updateStateWithInput(.Start)
   }
   
   override func viewWillAppear(animated: Bool) {
      print("\(__FILE__), \(__FUNCTION__)")
   }
   override func viewDidAppear(animated: Bool) {
      print("\(__FILE__), \(__FUNCTION__)")
   }
   
   // MARK: Tearing the controller down
   override func viewWillDisappear(animated: Bool) {
      print("\(__FILE__), \(__FUNCTION__)")
   }
   override func viewDidDisappear(animated: Bool) {
      print("\(__FILE__), \(__FUNCTION__)")
   }
   deinit {
      print("\(__FILE__), \(__FUNCTION__)")
   }
   
   // ************************
   // MARK: Events and Actions
   // ************************
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
      print("\(__FILE__), \(__FUNCTION__)")
   }
   
   func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
      print("Authorisation changed to \(status.rawValue)")
      if status == CLAuthorizationStatus.AuthorizedAlways {
         print("Authorisation granted")
         self.updateStateWithInput(.AuthorisationStatus(true))
      } else {
         self.updateStateWithInput(.AuthorisationStatus(false))
      }
   }
   
   @IBAction func doStart(sender: AnyObject) {
      self.updateStateWithInput(.UserWantsToStart(true))
   }

   @IBAction func doStop(sender: AnyObject) {
      self.updateStateWithInput(.UserWantsToStart(false))
   }
   
   //Called before a segue performs navigation
   override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      print("\(__FILE__), \(__FUNCTION__)")
      
      //Pass data forwards to the *presented* view controller
      if segue.identifier == "ModalOptions" {
         if let dstVC = segue.destinationViewController as? BCOptionsTableViewController {
            dstVC.delegate = self
            dstVC.options = self.options  //Pass a COPY
         }
      }
   }
   
   // ****************************
   // MARK: BCOptionsSheetDelegate
   // ****************************
   
   func dismissWithUpdatedOptions(updatedOptions: BCOptions?) {
      print("\(__FILE__), \(__FUNCTION__)")
      //If saved, updatedOptions will have a wrapped copy
      if let op = updatedOptions {
         self.options = op             //Make copy

         //Update the application UI and Location manager
         updateOutputWithState()
      }
      
      //Using a trailing closure syntax, dismiss the presented and run completion handler
      self.dismissViewControllerAnimated(true) {
         print("Presented animation has now completed")
      }
   }
   
   
   // *******************************
   // MARK: CLLocationManagerDelegate
   // *******************************

   func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
      print("Location manager failed \(error)")
   }
   
   func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.last else { return }
      
      print("\(locations.count) Location(s) Updated: \(location)")

      //Store in array
      for loc in locations {
         self.arrayOfLocations.append(loc)
      }
      
      //Update overlay of the journey
      var arrayOfCoords : [CLLocationCoordinate2D] = arrayOfLocations.map{$0.coordinate}  //Array of coordinates
      let line = MKPolyline(coordinates: &arrayOfCoords, count: arrayOfCoords.count)
      self.mapView.removeOverlays(self.mapView.overlays) //Remove previous line
      self.mapView.addOverlay(line)                      //Add updated
      
      /// Power saving option
      if (!self.deferringUpdates) {
         manager.allowDeferredLocationUpdatesUntilTraveled(self.options.distanceBetweenMeasurements*100.0, timeout: CLTimeIntervalMax)
         self.deferringUpdates = true
      }
      
   }
   
   func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
      print("Finished deferring updates")
      self.deferringUpdates = false
   }
  
   // ***********************
   // MARK: MKMapViewDelegate
   // ***********************
   
   // Moving the map will reset the user tracking mode. I reset it back
   func mapView(mapView: MKMapView, didChangeUserTrackingMode mode: MKUserTrackingMode, animated: Bool) {
      mapView.userTrackingMode = self.options.userTrackingMode
   }
   
   // For drawing the bread-crumbs
   func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
      let path = MKPolylineRenderer(overlay: overlay)
      path.strokeColor = UIColor.purpleColor()
      path.lineWidth = 2.0
      path.lineDashPattern = [10, 4]
      return path
   }
   
   // **************************
   // MARK: Finite State Machine
   // **************************
   
   //UPDATE STATE
   func updateStateWithInput(ip : AppStateInputSource)
   {
      var nextState = self.state
      
      switch (self.state) {
      case .WaitingForViewDidLoad:
         
         //Check inputs type
         if case .Start = ip  {
            nextState = .RequestingAuth
         }
         
      case .RequestingAuth:
         //Ensure user has given permission  to access location

         //Check inputs type and associated value
         if case .AuthorisationStatus(let val) = ip where val == true {
            nextState = .LiveMapNoLogging
         }
         
      case .LiveMapNoLogging:
         // Authorisation is given
         
         //Check for user cancelling permission
         if case .AuthorisationStatus(let val) = ip where val == false {
            nextState = .RequestingAuth
         }
         //Check for start button
         else if case .UserWantsToStart(let val) = ip where val == true {
            nextState = .LiveMapLogging
         }
      
      case .LiveMapLogging:
         
         if case .AuthorisationStatus(let val) = ip where val == false {
            nextState = .RequestingAuth
         }
         else if case .UserWantsToStart(let val) = ip where val == false {
            nextState = .LiveMapNoLogging
         }
         
      } //end switch
      
      //State Transition (will trigger updates in the output)
      self.state = nextState
   }
   
   //UPDATE (MOORE) OUTPUTS
   func updateOutputWithState() {
      switch (self.state) {
      case .WaitingForViewDidLoad:
         break
         
      case .RequestingAuth:
         
         //Request authorisation from the user to log location in the background
         self.locationManager.requestAlwaysAuthorization()
         
         //Set UI into default state until authorised
         
         //Buttons
         startButton.enabled = false
         stopButton.enabled = false
         optionsButton.enabled = false
         
         //Map defaults (pedantic)
         mapView.delegate = nil
         mapView.showsUserLocation = false
         
         //Location manger (pedantic)
         locationManager.stopUpdatingLocation()
         locationManager.allowsBackgroundLocationUpdates = false
         
      case .LiveMapNoLogging:
         // We now have permission to use location
         
         //Buttons for logging
         startButton.enabled = true
         stopButton.enabled = false
         optionsButton.enabled = true
         
         //Live Map
         mapView.showsUserLocation = true
         mapView.userTrackingMode = self.options.userTrackingMode
         mapView.showsTraffic = self.options.showTraffic
         mapView.delegate = self
         
         //Set Location manger state
         locationManager.desiredAccuracy = self.options.gpsPrecision
         locationManager.distanceFilter = self.options.distanceBetweenMeasurements
         locationManager.allowsBackgroundLocationUpdates = false
         locationManager.stopUpdatingLocation()
         
         
      case .LiveMapLogging:
         //Buttons
         startButton.enabled = false
         stopButton.enabled = true
         optionsButton.enabled = true
         
         //Map
         mapView.showsUserLocation = true
         mapView.userTrackingMode = self.options.userTrackingMode
         mapView.showsTraffic = self.options.showTraffic
         mapView.delegate = self
         
         //Location manger
         locationManager.desiredAccuracy = self.options.gpsPrecision
         locationManager.distanceFilter = self.options.distanceBetweenMeasurements
         locationManager.allowsBackgroundLocationUpdates = self.options.backgroundUpdates
         locationManager.startUpdatingLocation()
         
         if CLLocationManager.headingAvailable() {
            print("Update heading",separator: "********")
            locationManager.startUpdatingHeading()
         } else {
            print("HEADING NOT AVAILABLE",separator: "********")
         }
         

      } //end switch
   }
   
}

