
import UIKit

class DrinkView: UIView {
    
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
    
    let card : UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "folded_card"))
        image.frame = CGRect(x: 0, y: 0, width: 85, height: 75)
        return image
    }()
    
    let switchImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "swipe"))
    let orderImage: UIImageView = UIImageView(image: #imageLiteral(resourceName: "money"))
    
    let orderButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = Colors.pink
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = CGSize.zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowPath = UIBezierPath(rect: btn.bounds).cgPath
        btn.layer.cornerRadius = 65/2
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let switchButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = Colors.pink
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 1
        btn.layer.shadowOffset = CGSize.zero
        btn.layer.shadowRadius = 10
        btn.layer.shadowPath = UIBezierPath(rect: btn.bounds).cgPath
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.layer.cornerRadius = 65/2
        return btn
    }()
    
    var delegate: DrinkViewDelegate!
    var drinkImages = [UIImageView]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(latteImage)
        addSubview(frappeImage)
        addSubview(card)
        addSubview(orderButton)
        addSubview(switchButton)
        drinkImages.append(frappeImage)
        drinkImages.append(latteImage)
        switchButton.addSubview(switchImage)
        orderButton.addSubview(orderImage)
        buildButtonsImageConstraints()
        buildDrinksConstraints()
        buildButtonsConstraints()
        setupButtons()
    }
    
    func setupButtons(){
        orderButton.addTarget(self, action: #selector(buttonPressed(target:)), for: .touchDown)
        switchButton.addTarget(self, action: #selector(buttonPressed(target:)), for: .touchDown)
        orderButton.addTarget(self, action: #selector(orderReleased(_:)), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchReleased(_:)), for: .touchUpInside)
        switchButton.addTarget(self, action: #selector(switchReleased(_:)), for: .touchUpOutside)
        orderButton.addTarget(self, action: #selector(orderReleased(_:)), for: .touchUpOutside)
    }
    
    
    func buildButtonsImageConstraints() {
        switchImage.translatesAutoresizingMaskIntoConstraints = false
        orderImage.translatesAutoresizingMaskIntoConstraints = false
        
        switchImage.topAnchor.constraint(equalTo: switchButton.topAnchor, constant: 10).isActive = true
        orderImage.topAnchor.constraint(equalTo: orderButton.topAnchor, constant: 10).isActive = true
        
        switchImage.bottomAnchor.constraint(equalTo: switchButton.bottomAnchor, constant: -10).isActive = true
        orderImage.bottomAnchor.constraint(equalTo: orderButton.bottomAnchor, constant: -10).isActive = true
        
        switchImage.leftAnchor.constraint(equalTo: switchButton.leftAnchor, constant: 10).isActive = true
        orderImage.leftAnchor.constraint(equalTo: orderButton.leftAnchor, constant: 10).isActive = true
        
        switchImage.rightAnchor.constraint(equalTo: switchButton.rightAnchor, constant: -10).isActive = true
        orderImage.rightAnchor.constraint(equalTo: orderButton.rightAnchor, constant: -10).isActive = true
    }
    
    func buildDrinksConstraints() {
        var constraints = [NSLayoutConstraint]()
        for i in 0..<drinkImages.count {
            drinkImages[i].translatesAutoresizingMaskIntoConstraints = false
            let right = drinkImages[i].rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
            let left = drinkImages[i].leftAnchor.constraint(equalTo: leftAnchor, constant: 70)
            let top = drinkImages[i].topAnchor.constraint(equalTo: topAnchor, constant: 50)
            let bottom = drinkImages[i].bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
            constraints.append(contentsOf: [top, bottom, left, right])
        }
        NSLayoutConstraint.activate(constraints)
        card.layer.zPosition = 5
    }
    
    func buildButtonsConstraints() {
        orderButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        orderButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        orderButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        orderButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
        
        switchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        switchButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        switchButton.widthAnchor.constraint(equalToConstant: 65).isActive = true
        switchButton.heightAnchor.constraint(equalToConstant: 65).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed(target : AnyObject?) {
        let btn = target as! UIButton
        UIView.animate(withDuration: 0.2, animations: {
            btn.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
        })
    }
    
    @objc func orderReleased(_: AnyObject?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.orderButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        delegate.orderDrink()
    }
    
    @objc func switchReleased(_: AnyObject?) {
        UIView.animate(withDuration: 0.2, animations: {
            self.switchButton.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
        delegate.switchDrink()
    }
    
}


