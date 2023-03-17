//
//  TickerSlider.swift
//  projet_meteo_ios_marelk
//
//  Created by user on 16/02/2023.
//  Copyright © 2023 user. All rights reserved.
//

import Foundation
import UIKit

protocol TickerSliderDelegate: NSObject {
    func sliderChanged(_ newValue: Int, sender: Any)
}
extension TickerSliderDelegate {
    // make this delegate func optional
    func sliderChanged(_ newValue: Int, sender: Any) {}
}

class TickerSlider: UISlider {
    
    
    var delegate: TickerSliderDelegate?
    
    var stepCount = 6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    func commonInit() -> Void {
        // clear min and max track images
        //  because we'll be drawing our own
        setMinimumTrackImage(UIImage(), for: [])
        setMaximumTrackImage(UIImage(), for: [])
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // get the track rect
        let trackR: CGRect = self.trackRect(forBounds: bounds)
        
        // get the thumb rect at min and max values
        let minThumbR: CGRect = self.thumbRect(forBounds: bounds, trackRect: trackR, value: minimumValue)
        let maxThumbR: CGRect = self.thumbRect(forBounds: bounds, trackRect: trackR, value: maximumValue)
        
        // usable width is center of thumb to center of thumb at min and max values
        let usableWidth: CGFloat = maxThumbR.midX - minThumbR.midX
        
        // Tick Height (or use desired explicit height)
        let tickHeight: CGFloat = bounds.height
        
        // "gap" between tick marks
        let stepWidth: CGFloat = usableWidth / CGFloat(stepCount)
        
        // a reusable path
        var pth: UIBezierPath!
        
        // a reusable point
        var pt: CGPoint!
                
        // new path
        pth = UIBezierPath()
        
        // left end of our track rect
        pt = CGPoint(x: minThumbR.midX, y: bounds.height * 0.5)
        
        // top of vertical tick lines
        pt.y = (bounds.height - tickHeight) * 0.5
        
        // we have to draw stepCount + 1 lines
        //  so use
        //      0...stepCount
        //  not
        //      0..<stepCount
        for _ in 0...stepCount {
            pth.move(to: pt)
            pth.addLine(to: CGPoint(x: pt.x, y: pt.y + tickHeight))
            pt.x += stepWidth
        }
        UIColor.lightGray.setStroke()
        pth.stroke()
        
        // new path
        pth = UIBezierPath()
        
        // left end of our track lines
        pt = CGPoint(x: minThumbR.midX, y: bounds.height * 0.5)
        
        // move to left end
        pth.move(to: pt)
        
        // draw the "right-side" of the track first
        //  it will be the full width of "our track"
        pth.addLine(to: CGPoint(x: pt.x + usableWidth, y: pt.y))
        pth.lineWidth = 3
        UIColor.lightGray.setStroke()
        pth.stroke()
        
        // new path
        pth = UIBezierPath()
        
        // move to left end
        pth.move(to: pt)
        
        // draw the "left-side" of the track on top of the "right-side"
        //  at percentage width
        let rng: Float = maximumValue - minimumValue
        let val: Float = value - minimumValue
        let pct: Float = val / rng
        pth.addLine(to: CGPoint(x: pt.x + (usableWidth * CGFloat(pct)), y: pt.y))
        pth.lineWidth = 3
        UIColor.systemBlue.setStroke()
        pth.stroke()

    }
    
    override func setValue(_ value: Float, animated: Bool) {
        // don't allow value outside range of min and max values
        let newVal: Float = min(max(minimumValue, value), maximumValue)
        super.setValue(newVal, animated: animated)
        
        // we need to trigger draw() when the value changes
        setNeedsDisplay()
        let steps: Float = Float(stepCount)
        let rng: Float = maximumValue - minimumValue
        // get the percentage along the track
        let pct: Float = newVal / rng
        // use that pct to get the rounded step position
        let pos: Float = round(steps * pct)
        // tell the delegate which Tick the thumb snapped to
        delegate?.sliderChanged(Int(pos), sender: self)
    }
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        
        let steps: Float = Float(stepCount)
        let rng: Float = maximumValue - minimumValue
        // get the percentage along the track
        let pct: Float = value / rng
        // use that pct to get the rounded step position
        let pos: Float = round(steps * pct)
        // use that pos to calculate the new percentage
        let newPct: Float = (pos / steps)
        let newVal: Float = minimumValue + (rng * newPct)
        self.value = newVal
    }
    override var bounds: CGRect {
        willSet {
            // we need to trigger draw() when the bounds changes
            setNeedsDisplay()
        }
    }
    
}
