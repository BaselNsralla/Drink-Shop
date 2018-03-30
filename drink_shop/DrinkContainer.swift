
import UIKit

class DrinkContainer: UIView {
    
    let frappeImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "frappe"))
        return image
    }()
    let latteImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "latte"))
        return image
    }()
    
    var drinkImages = [UIImageView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        drinkImages.append(frappeImage)
        drinkImages.append(latteImage)
        addSubview(latteImage)
        addSubview(frappeImage)
        buildConstraint()
    }
    
    func buildConstraint() {
        var constraints = [NSLayoutConstraint]()
        for i in 0..<drinkImages.count {
            drinkImages[i].translatesAutoresizingMaskIntoConstraints = false
            let left = drinkImages[i].leftAnchor.constraint(equalTo: leftAnchor, constant: 80)
            let right = drinkImages[i].rightAnchor.constraint(equalTo: rightAnchor, constant: -80)
            let top = drinkImages[i].topAnchor.constraint(equalTo: topAnchor, constant: 65)
            let bottom = drinkImages[i].bottomAnchor.constraint(equalTo: bottomAnchor, constant: -65)
            constraints.append(contentsOf: [left, right, top, bottom])
        }
        NSLayoutConstraint.activate(constraints)
        //self.layer.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

