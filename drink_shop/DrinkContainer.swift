
import UIKit

class DrinkContainer: UIView {
    
    let drinkImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "frappe"))
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(drinkImage)
        buildConstraint()
    }
    
    func buildConstraint() {
        drinkImage.translatesAutoresizingMaskIntoConstraints = false
        var left = drinkImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 75)
        var right = drinkImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -75)
        var top = drinkImage.topAnchor.constraint(equalTo: topAnchor, constant: 50)
        var bottom = drinkImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        let constraints:Array<NSLayoutConstraint> = [left, right, top, bottom]
        NSLayoutConstraint.activate(constraints)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

