
import UIKit

class DrinkContainer: UIView {
    
    let frappeImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "frappe_straw"))
        //image.frame = CGRect(x: 0, y: 0, width: 150, height: 250)
        return image
    }()
    let latteImage : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "latte_straw"))
        //image.frame = CGRect(x: 0, y: 0, width: 150, height: 250)
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
            let right = drinkImages[i].rightAnchor.constraint(equalTo: rightAnchor, constant: -80)
            let left = drinkImages[i].leftAnchor.constraint(equalTo: leftAnchor, constant: 80)
            let top = drinkImages[i].topAnchor.constraint(equalTo: topAnchor, constant: 50)
            let bottom = drinkImages[i].bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            constraints.append(contentsOf: [top, bottom, left, right])
        }
        NSLayoutConstraint.activate(constraints)
        //self.layer.setNeedsLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

