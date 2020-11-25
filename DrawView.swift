//
//  DrawView.swift
//  Exercise1
//
//  Created by 廖胤瑞 on 2020/11/24.
//

import UIKit

extension UIView {

    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}

class DrawView: UIView, UIGestureRecognizerDelegate{
    var currentLines = [NSValue:Line]()
    var finishedLines = [Line]()
    var strokeColor = UIColor.black
    var chageColor: Bool = false
    let imageStore = ImageStore()
    var selectedLineIndex: Int?{
        didSet {
            if selectedLineIndex == nil && chageColor == false{
                let menu = UIMenuController.shared
                menu.setMenuVisible(false, animated: true)
            }
        }
    }
    //when exit this view
    override func removeFromSuperview() {
        imageStore.setImage(self.asImage(), forKey: shared.info.trackQuestion.itemKey )
        shared.info.backFromDraw = true
    }

    var moveRecognizer: UIPanGestureRecognizer!
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let doubleTapRecognizer = UITapGestureRecognizer(target: self,
                                                         action: #selector(DrawView.doubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.delaysTouchesBegan = true
        addGestureRecognizer(doubleTapRecognizer)
        
        let tapRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(DrawView.tap(_:)))
        tapRecognizer.delaysTouchesBegan = true
        tapRecognizer.require(toFail: doubleTapRecognizer)
        addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                               action: #selector(DrawView.longPress(_:)))
        addGestureRecognizer(longPressRecognizer)
        
        moveRecognizer = UIPanGestureRecognizer(target: self,
                                                action: #selector(DrawView.moveLine(_:)))
        moveRecognizer.delegate = self
        moveRecognizer.cancelsTouchesInView = false
        addGestureRecognizer(moveRecognizer)
    }
    
    //only pan gesture recognizer has a delegate, so just simply return true
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith
                            otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func moveLine(_ gestureRecognizer: UIPanGestureRecognizer) {
        print("Recognized a pan")
        // If a line is selected...
        if let index = selectedLineIndex {
            // When the pan recognizer changes its position...
            if gestureRecognizer.state == .changed {
                // How far has the pan moved?
                let translation = gestureRecognizer.translation(in: self)
                // Add the translation to the current beginning and end points of the line
                // Make sure there are no copy and paste typos!
                finishedLines[index].begin.x += translation.x
                finishedLines[index].begin.y += translation.y
                finishedLines[index].end.x += translation.x
                finishedLines[index].end.y += translation.y
                gestureRecognizer.setTranslation(CGPoint.zero, in: self)
                // Redraw the screen
                setNeedsDisplay()
            }
        } else {
            // If no line is selected, do not do anything
            return
        }
    }
    
    @objc func longPress(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a long press")
        if gestureRecognizer.state == .began {
            let point = gestureRecognizer.location(in: self)
            selectedLineIndex = indexOfLine(at: point)
            if selectedLineIndex != nil {
                currentLines.removeAll()
            }
        } else if gestureRecognizer.state == .ended {
            selectedLineIndex = nil
        }
        else if(selectedLineIndex == nil){
            let point = gestureRecognizer.location(in: self)
            chageColor = true
            // Grab the menu controller
            let menu = UIMenuController.shared
            
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            // Create a new "Delete" UIMenuItem
            
            let YellowItem = UIMenuItem(title: "Yellow",
                                        action: #selector(DrawView.setYellow(_:)))
            let OrangeItem = UIMenuItem(title: "Orange",
                                        action: #selector(DrawView.setOrange(_:)))
            let GreyItem = UIMenuItem(title: "Grey",
                                      action: #selector(DrawView.setGray(_:)))
            let PurpleItem = UIMenuItem(title: "Purple",
                                        action: #selector(DrawView.setPurple(_:)))
            menu.menuItems = [YellowItem, OrangeItem, GreyItem, PurpleItem]
            // Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
            
        }
        setNeedsDisplay()
    }
    
    @objc func tap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a tap")
        let point = gestureRecognizer.location(in: self)
        selectedLineIndex = indexOfLine(at: point)
        // Grab the menu controller
        let menu = UIMenuController.shared
        if selectedLineIndex != nil {
            // Make DrawView the target of menu item action messages
            becomeFirstResponder()
            // Create a new "Delete" UIMenuItem
            let deleteItem = UIMenuItem(title: "Delete",
                                        action: #selector(DrawView.deleteLine(_:)))
            let YellowItem = UIMenuItem(title: "Yellow",
                                        action: #selector(DrawView.yellow(_:)))
            let OrangeItem = UIMenuItem(title: "Orange",
                                        action: #selector(DrawView.orange(_:)))
            let GreyItem = UIMenuItem(title: "Grey",
                                      action: #selector(DrawView.gray(_:)))
            let PurpleItem = UIMenuItem(title: "Purple",
                                        action: #selector(DrawView.purple(_:)))
            menu.menuItems = [deleteItem, YellowItem, OrangeItem, GreyItem, PurpleItem]
            // Tell the menu where it should come from and show it
            let targetRect = CGRect(x: point.x, y: point.y, width: 2, height: 2)
            menu.setTargetRect(targetRect, in: self)
            menu.setMenuVisible(true, animated: true)
        } else {
            // Hide the menu if no line is selected
            menu.setMenuVisible(false, animated: true)
        }
        setNeedsDisplay()
    }
    
    @objc func doubleTap(_ gestureRecognizer: UIGestureRecognizer) {
        print("Recognized a double tap")
        selectedLineIndex = nil
        currentLines.removeAll()
        finishedLines.removeAll()
        setNeedsDisplay()
    }
    
    @IBInspectable var finishedLineColor: UIColor = UIColor.black {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var currentLineColor: UIColor = UIColor.red {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable var lineThickness: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    func stroke(_ line: Line) {
        let path = UIBezierPath()
        path.lineWidth = lineThickness
        path.lineCapStyle = .round
        path.move(to: line.begin)
        path.addLine(to: line.end)
        path.stroke()
    }
    override func draw(_ rect: CGRect) {
        
        for line in finishedLines {
            line.color.setStroke()
            stroke(line)
        }
        for (_, line) in currentLines {
            line.color.setStroke()
            stroke(line)
        }
        if let index = selectedLineIndex {
            let selectedLine = finishedLines[index]
            UIColor.green.setStroke()
            stroke(selectedLine)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        for touch in touches {
            let location = touch.location(in: self)
            let newLine = Line(begin: location, end: location)
            newLine.color = strokeColor
            let key = NSValue(nonretainedObject: touch)
            currentLines[key] = newLine
        }
        setNeedsDisplay()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            currentLines[key]?.end = touch.location(in: self)
        }
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        for touch in touches {
            let key = NSValue(nonretainedObject: touch)
            if var line = currentLines[key] {
                line.end = touch.location(in: self)
                finishedLines.append(line)
                currentLines.removeValue(forKey: key)
            }
        }
        setNeedsDisplay()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Log statement to see the order of events
        print(#function)
        currentLines.removeAll()
        setNeedsDisplay()
    }
    
    func indexOfLine(at point: CGPoint) -> Int? {
        // Find a line close to point
        for (index, line) in finishedLines.enumerated() {
            let begin = line.begin
            let end = line.end
            // Check a few points on the line
            for t in stride(from: CGFloat(0), to: 1.0, by: 0.05) {
                let x = begin.x + ((end.x - begin.x) * t)
                let y = begin.y + ((end.y - begin.y) * t)
                // If the tapped point is within 20 points, let's return this line
                if hypot(x - point.x, y - point.y) < 20.0 {
                    return index
                }
            }
        }
        // If nothing is close enough to the tapped point, then we did not select a line
        return nil
    }
    
    @objc func deleteLine(_ sender: UIMenuController) {
        // Remove the selected line from the list of finishedLines
        
        let alert = UIAlertController(title: "Alert",message:"Are you sure you want to delete this line?",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { (action:UIAlertAction!) in
            if let index = self.selectedLineIndex {
                self.finishedLines.remove(at: index)
                self.selectedLineIndex = nil
                // Redraw everything
                self.setNeedsDisplay()
            }
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { (action:UIAlertAction!) in
            return
        })
        self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    @objc func orange(_ sender: UIMenuController) {
        
        if let index = selectedLineIndex {
            let selectedLine = finishedLines[index]
            selectedLine.color = UIColor.orange
            selectedLineIndex = nil
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func yellow(_ sender: UIMenuController) {
        
        if let index = selectedLineIndex {
            let selectedLine = finishedLines[index]
            selectedLine.color = UIColor.yellow
            selectedLineIndex = nil
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func gray(_ sender: UIMenuController) {
        
        if let index = selectedLineIndex {
            let selectedLine = finishedLines[index]
            selectedLine.color = UIColor.gray
            selectedLineIndex = nil
            // Redraw everything
            setNeedsDisplay()
        }
    }
    @objc func purple(_ sender: UIMenuController) {
        
        if let index = selectedLineIndex {
            let selectedLine = finishedLines[index]
            selectedLine.color = UIColor.purple
            selectedLineIndex = nil
            // Redraw everything
            setNeedsDisplay()
        }
    }
    
    @objc func setPurple(_ sender: UIMenuController) {
        strokeColor = UIColor.purple
        setNeedsDisplay()
        
    }
    @objc func setOrange(_ sender: UIMenuController) {
        strokeColor = UIColor.orange
        setNeedsDisplay()
    }
    @objc func setYellow(_ sender: UIMenuController) {
        strokeColor = UIColor.yellow
        setNeedsDisplay()
    }
    @objc func setGray(_ sender: UIMenuController) {
        strokeColor = UIColor.gray
        setNeedsDisplay()
    }
}
