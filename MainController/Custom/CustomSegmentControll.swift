
import UIKit

//MARK: - CustomSegmentControll

final class CustomSegmentControll: UISegmentedControl {}

//MARK: - Extension UIImage

extension UIImage {
    class func getGegRect(color: CGColor, andSize size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        context?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return rectangleImage
        
    }
}

//MARK: - Extension UISegmentedControll

extension UISegmentedControl {
    
    func removeBorder() {
        let background = UIImage.getGegRect(color: #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1), andSize: self.bounds.size)
        self.setBackgroundImage(background, for: .normal, barMetrics: .default)
        self.setBackgroundImage(background, for: .selected, barMetrics: .default)
        self.setBackgroundImage(background, for: .highlighted, barMetrics: .default)
        
        let deviderLine = UIImage.getGegRect(color: #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1), andSize: CGSize(width: 1, height: 5))
        self.setDividerImage(deviderLine, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        
    }
    //tab hightlight when select
    
    func hightlightSelectSegment() {
        removeBorder()
        let lineWidht: CGFloat = self.bounds.size.width / CGFloat(self.numberOfSegments)
        let lineHeight: CGFloat = 2.0
        let lineXPosition = CGFloat(selectedSegmentIndex * Int(lineWidht))
        let lineYPosition = self.bounds.size.height - 9
        let underLineFrame = CGRect(x: lineXPosition, y: lineYPosition, width: lineWidht, height: lineHeight)
        let underLine = UIView(frame: underLineFrame)
        underLine.backgroundColor = #colorLiteral(red: 0.01481811702, green: 0.6612076163, blue: 0.9563835263, alpha: 1)
        underLine.tag = 1
        self.addSubview(underLine)
    }
    
    //set the position of bottom underLine
    
    func underLinePosition() {
        guard let underLine = self.viewWithTag(1) else {return}
        let xPosition = (self.bounds.width / CGFloat(self.numberOfSegments)) * CGFloat(selectedSegmentIndex)
        //spring animation when change tab
        UIView.animate(withDuration: 0.5, delay: 0.0,usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: .curveEaseInOut) {
            underLine.frame.origin.x = xPosition
        }
    }
    
    func addBottomBorderWithColor(color: UIColor, height: CGFloat) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - height, width: self.frame.size.width, height: height)
        bottomLine.backgroundColor = color.cgColor
        self.layer.addSublayer(bottomLine)
    }
}
