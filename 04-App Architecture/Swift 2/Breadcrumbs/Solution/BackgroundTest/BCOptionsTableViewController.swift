//
//  BCOptionsTableViewController.swift
//  Breadcrumbs
//
//  Created by Nicholas Outram on 02/12/2015.
//  Copyright © 2015 Plymouth University. All rights reserved.
//

import UIKit

protocol BCOptionsSheetDelegate : class {
    //Required methods
    func dismissWithUpdatedOptions(updatedOptions : BCOptions?)
}

class BCOptionsTableViewController: UITableViewController {
    @IBOutlet weak var backgroundUpdateSwitch: UISwitch!
    @IBOutlet weak var headingUPSwitch: UISwitch!
    @IBOutlet weak var headingUPLabel: UILabel!
    @IBOutlet weak var showTrafficSwitch: UISwitch!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var gpsPrecisionLabel: UILabel!
    @IBOutlet weak var gpsPrecisionSlider: UISlider!

    //Delegate property
    weak var delegate : BCOptionsSheetDelegate?

    //Local copy of all options with defaults
    var options : BCOptions = BCOptions() {
      didSet {
         print("OPTIONS COPY UPDATED in \(__FUNCTION__)")
         //updateUIWithState() //this would cause a crash when this property is set by the presenting controller
      }
    }

    //Functions to synchronise UI and state
    //Error prone, with no clever binding strategies here - just keeping things simple
    func updateUIWithState() {
      self.backgroundUpdateSwitch.on = self.options.backgroundUpdates
      //Only devices with heading support can switch on the heading UP support
      if self.options.headingAvailable {
         self.headingUPSwitch.on = self.options.headingUP
         self.headingUPSwitch.enabled = true
         self.headingUPLabel.alpha = 1.0
      } else {
         self.headingUPSwitch.on = false
         self.headingUPSwitch.enabled = false
         self.headingUPLabel.alpha = 0.2
      }
      self.showTrafficSwitch.on = self.options.showTraffic
      self.distanceSlider.value = Float(self.options.distanceBetweenMeasurements)
      self.distanceLabel.text = String(format: "%d", Int(self.options.distanceBetweenMeasurements))
      self.gpsPrecisionSlider.value = Float(self.options.gpsPrecision)
      self.gpsPrecisionLabel.text = String(format: "%d", Int(self.options.gpsPrecision))
    }

    func updateStateFromUI() {
      self.options.backgroundUpdates = self.backgroundUpdateSwitch.on
      self.options.headingUP = self.headingUPSwitch.on
      self.options.showTraffic = self.showTrafficSwitch.on
      self.options.distanceBetweenMeasurements = Double(self.distanceSlider.value)
      self.options.gpsPrecision = Double(self.gpsPrecisionSlider.value)
    }

    override func awakeFromNib() {
      print("\(__FILE__), \(__FUNCTION__)")
    }

    override func viewDidLoad() {
      print("\(__FILE__), \(__FUNCTION__)")
      super.viewDidLoad()

      guard let _ = self.delegate else {
         print("WARNING - DELEGATE NOTE SET FOR \(self)")
         return
      }
      
      //Initialise the UI
      updateUIWithState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //Triggered by a rotation event
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        //Forward the message
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        
        print("\(__FILE__), \(__FUNCTION__) : new traits \(newCollection)")
    }

    // MARK: Actions
    @IBAction func doBackgroundUpdateSwitch(sender: AnyObject) {
      updateStateFromUI()
    }

    @IBAction func doHeadingUpSwitch(sender: AnyObject) {
      updateStateFromUI()
    }

    @IBAction func doShowTrafficSwitch(sender: AnyObject) {
      updateStateFromUI()
    }

    @IBAction func doDistanceSliderChanged(sender: AnyObject) {
      updateStateFromUI()
      self.distanceLabel.text = String(format: "%d", Int(self.distanceSlider.value))
    }

    @IBAction func doGPSPrecisionSliderChanged(sender: AnyObject) {
      updateStateFromUI()
      self.gpsPrecisionLabel.text = String(format: "%d", Int(self.gpsPrecisionSlider.value))
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
      
      tableView.deselectRowAtIndexPath(indexPath, animated: true)
      
      if indexPath.section == 4 {
         if indexPath.row == 0 {
            print("Save tapped")
            self.delegate?.dismissWithUpdatedOptions(self.options)
         } else {
            print("Cancel tapped")
            self.delegate?.dismissWithUpdatedOptions(nil)
         }
      }
    }
    
    // MARK: Rotation
    // New Autorotation support.
    override func shouldAutorotate() -> Bool {
        return false
    }
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [.Portrait]
    }

}
