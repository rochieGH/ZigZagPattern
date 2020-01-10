//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport
class MyViewController : UIViewController {
    
    var changeButton : UIButton!
    var pauseButton : UIButton!
    var resumeButton : UIButton!
    var counter = 0
    var reDraw = true
    let step = 20
    let x = 0
    let y = 40
    let width = 375
    let height = 667
    let path = UIBezierPath()
    let patternLayer = CAShapeLayer()
    let patternView = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
    
    override func loadView() {
        changeButton = UIButton(type: .system)
        changeButton.setTitle("Change Pattern", for: .normal)
        changeButton.tintColor = .yellow
        changeButton.addTarget(self, action: #selector(updateView), for: .touchUpInside)
        
        pauseButton = UIButton(type: .system)
        pauseButton.setTitle("Pause Animation", for: .normal)
        pauseButton.tintColor = .yellow
        pauseButton.addTarget(self, action: #selector(pauseAnimation), for: .touchUpInside)
        
        
        resumeButton = UIButton(type: .system)
        resumeButton.setTitle("Resume Animation", for: .normal)
        resumeButton.tintColor = .yellow
        resumeButton.isEnabled = false
        resumeButton.addTarget(self, action: #selector(resumeAnimation), for: .touchUpInside)
        
        
        // create the whole path in one go
       // using the makePath func
        for yvalue in stride(from: y, through: height, by: step) {
            for xvalue in stride(from: x, through: width, by: step) {
                path.append(makePath(x: xvalue,y: yvalue, width: step, height: step))
            }
        }
        path.close()
        
        // Create shape patternLayer and add the path to it
        patternLayer.path = path.cgPath
        
        // Set up the appearance of the shape patternLayer
        patternLayer.strokeEnd = 0
        patternLayer.lineWidth = 5
        patternLayer.lineCap = CAShapeLayerLineCap.round
        patternLayer.strokeColor = UIColor.red.cgColor
        patternLayer.fillColor = UIColor.clear.cgColor
        
        // Set up the background colour of pattern
        patternView.backgroundColor = .black
        
        // Add buttons to the patternView
        patternView.addSubview(changeButton)
        patternView.addSubview(pauseButton)
        patternView.addSubview(resumeButton)
        // Add the patternLayer to patternView
        patternView.layer.addSublayer(patternLayer)
        // Place the button
        
        changeButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        resumeButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            changeButton.topAnchor.constraint(equalTo: patternView.topAnchor, constant: 10),
            changeButton.leadingAnchor.constraint(equalTo: patternView.leadingAnchor, constant: 10),
            pauseButton.topAnchor.constraint(equalTo: patternView.topAnchor, constant: 10),
            pauseButton.leadingAnchor.constraint(equalTo: patternView.centerXAnchor, constant:-40),
            resumeButton.topAnchor.constraint(equalTo: patternView.topAnchor, constant: 10),
            resumeButton.leadingAnchor.constraint(equalTo: patternView.trailingAnchor, constant: -70)
        ])
        
        // Create the animation for the shape view
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 20 // seconds
        animation.autoreverses = false
        animation.repeatCount = .infinity
        
        // And finally add the animation to the shape!
        patternLayer.add(animation, forKey: "line")
       
        // assign the patternView to the MyViewController view
        self.view = patternView
    }
    
    func makePath(x:Int, y:Int, width:Int, height:Int) -> UIBezierPath {
        let leftToRight:Bool = Bool.random()
        
        let path = UIBezierPath()
        
        if(leftToRight) {
            path.move(to: CGPoint(x: x, y: y))
            path.addLine(to: CGPoint(x: x + width, y: y + height))
        } else {
            path.move(to: CGPoint(x: x + width, y: y))
            path.addLine(to: CGPoint(x: x, y: y + height))
        }
        return path
    }
    
    @objc func updateView() {
        patternLayer.sublayers?.removeAll()
        path.removeAllPoints()
        counter += 1
        reDraw.toggle()
       
        // create the whole path in one go
        // using the makePath func
        for yvalue in stride(from: y, through: height, by: step) {
            for xvalue in stride(from: x, through: width, by: step) {
                path.append(makePath(x: xvalue,y: yvalue, width: step, height: step))
            }
        }
        path.close()
        
        patternLayer.path = path.cgPath
        // Create the animation for the shape view
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 20 // seconds
        animation.autoreverses = false
        animation.repeatCount = .infinity
        
        // And finally add the linear animation to the shape!
        patternLayer.add(animation, forKey: "line")
        self.view = patternView
    }
    
    @objc func pauseAnimation() {
        let pausedTime = patternLayer.convertTime(CACurrentMediaTime(), from: nil)
        patternLayer.speed = 0
        patternLayer.timeOffset = pausedTime
        changeButton.isEnabled = false
        resumeButton.isEnabled = true
    }

    @objc func resumeAnimation() {
        let pausedTime = patternLayer.timeOffset
        patternLayer.speed = 1
        patternLayer.timeOffset = 0
        patternLayer.beginTime = 0
        let timeSincePause = patternLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        patternLayer.beginTime = timeSincePause
        changeButton.isEnabled = true
        resumeButton.isEnabled = false
    }
    
}
PlaygroundPage.current.liveView = MyViewController()
