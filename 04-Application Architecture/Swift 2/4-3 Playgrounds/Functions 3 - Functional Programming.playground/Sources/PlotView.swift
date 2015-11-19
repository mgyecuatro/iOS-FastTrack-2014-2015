import AppKit
public typealias Point2D = (x: Double, y: Double)  //2D point in a Tuple


// Custom View for Plotting 2D Points
public class PlotView : NSView {
    
    var points : [String : Point2D] = [String : Point2D]()
    
    override public func drawRect(dirtyRect: NSRect) {

        super.drawRect(dirtyRect)
        
        //Move the origin to the center of the bounds box
        let W2 = self.bounds.width * 0.5
        let H2 = self.bounds.height * 0.5
        let xc = self.bounds.origin.x + W2
        let yc = self.bounds.origin.y + H2
      
      
        //The next line does not work with inline image preview in Playgrounds (does work with the liveView)
        //self.translateOriginToPoint(CGPointMake(xc, yc))
      
        //The following two functions perform a translation from (0,0) origin to (W2,H2)
        func PVPointMake(x : CGFloat, _ y : CGFloat) -> CGPoint {
           return CGPointMake(x + W2, y + H2)
        }
        func PVRectMake(x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
           let r = CGRectMake(x + W2, y + H2, width, height)
           return r
        }
      
        //The remaining code assumes an origin of (0,0)
        NSColor.whiteColor().set()
        NSBezierPath.fillRect(self.bounds)
        
        //Now draw major axis
        NSBezierPath.setDefaultLineWidth(2.0)
        NSColor.blackColor().setStroke()
        
        let vLine =  NSBezierPath()

        vLine.moveToPoint(PVPointMake(-W2, 0))
        vLine.lineToPoint(PVPointMake(W2, 0.0))
        vLine.stroke()
        vLine.fill()
        
        vLine.moveToPoint(PVPointMake(0, -H2))
        vLine.lineToPoint(PVPointMake(0, H2))
        vLine.stroke()
        vLine.fill()
        
        //
        // Plot points
        //
        func circlePathAtPoint(x : Double, _ y : Double) -> NSBezierPath {
            let p = PVRectMake(CGFloat(x-5.0), CGFloat(y-5.0), 10.0, 10.0)
            let c = NSBezierPath(ovalInRect: p)
            return c
        }

        //Plot each point
        for (label, p) in points {
            let circle = circlePathAtPoint(p.x, p.y)
            //Set line and fill color
            NSColor.blueColor().setStroke()
            NSColor.yellowColor().setFill()
            //Draw
            circle.stroke()
            circle.fill()
            //Label
            let s : NSString = label
            s.drawAtPoint(PVPointMake(CGFloat(p.x+10.0), CGFloat(p.y)), withAttributes: nil)
        }
      
    }
    
    //Constructor
    public init(frame frameRect: NSRect, points: [String : Point2D]) {
        super.init(frame: frameRect)
        self.points = points
    }
    //Required convenience method
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}