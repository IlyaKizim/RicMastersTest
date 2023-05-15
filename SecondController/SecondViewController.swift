
import UIKit
import WebKit


class SecondViewController: UIViewController {
    
//MARK: -  @IBOutlets
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var webViews: WKWebView!
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var imageViewLock: UIImageView!
    @IBOutlet weak var labelLock: UILabel!
    var model: String?
    
//MARK: -  Lifecyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        configurateToolBar()
        configurLock()
        prepare()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        if let font = UIFont(name: Constants.font, size: 21) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        }
        navigationItem.title = Constants.titleNavigation
        navigationItem.setHidesBackButton(true, animated: true)
        conteinerView.layer.cornerRadius = 12
        conteinerView.layer.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    }
    
//MARK: -  setupUI
    
    private func configurateToolBar() {
        image.image = UIImage(systemName: Constants.shevron)
        image.tintColor = UIColor(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)
        let leftButton = UIButton(type: .system)
        leftButton.contentHorizontalAlignment = .center
        leftButton.tintColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)
        leftButton.setImage(UIImage(systemName: Constants.arrow), for: .normal)
        leftButton.addTarget(self, action: #selector(popToRoot), for: .touchUpInside)
        let centerButton = UIButton(type: .system)
        centerButton.setTitle(Constants.set, for: .normal)
        centerButton.setTitleColor(UIColor(red: 187/255, green: 187/255, blue: 187/255, alpha: 1), for: .normal)
        centerButton.titleLabel?.font = UIFont(name: Constants.font, size: 17)
        centerButton.contentHorizontalAlignment = .center
        centerButton.contentVerticalAlignment = .center
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
        let rightButton = UIButton(type: .system)
        rightButton.contentHorizontalAlignment = .center
        rightButton.setImage(UIImage(systemName: Constants.eye), for: .normal)
        rightButton.setTitleColor(UIColor(red: 3/255, green: 169/255, blue: 244/255, alpha: 1), for: .normal)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        let centerBarButtonItem = UIBarButtonItem(customView: centerButton)
        let leftBarItem = UIBarButtonItem(customView: leftButton)
        let rightBarItem = UIBarButtonItem(customView: rightButton)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [leftBarItem, flexibleSpace, centerBarButtonItem, flexibleSpace, rightBarItem]
    }
    
    func prepare(){
        if let model = model {
            configure(model: model)
        }
    }
    
    func configurLock() {
        conteinerView.backgroundColor = .white
        imageViewLock.tintColor = UIColor(red: 3/255, green: 169/255, blue: 244/255, alpha: 1)
        imageViewLock.image = UIImage(systemName: Constants.key)
        labelLock.text = Constants.openDoor
        labelLock.font = UIFont(name: Constants.font, size: 14)
        labelLock.tintColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        imageViewLock.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        labelLock.adjustsFontSizeToFitWidth = true
        let gestur = UITapGestureRecognizer()
        gestur.addTarget(self, action: #selector(tapKey))
        conteinerView.addGestureRecognizer(gestur)
    }
    
    func configure(model: String) {
        guard let url = URL(string: model) else {
            return
        }
        webViews.load(URLRequest(url: url))
        webViews.scrollView.isScrollEnabled = false
    }
    
    
    @objc private func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func centerButtonTapped() {
        print("centerButtonTapped")
    }
    
    @objc private func rightButtonTapped() {
        print("rightButtonTapped")
    }
    
    @objc private func tapKey() {
        print("tapKey")
    }
}
