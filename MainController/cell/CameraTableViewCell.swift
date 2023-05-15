
import UIKit
import WebKit


//MARK: - Protocol

protocol CameraTableViewCellDelegate: AnyObject {
    func didTapCell(at indexPath: IndexPath)
    func didTapForStarCamera(at indexPath: IndexPath)
    func didTapForStarDoor(at indexPath: IndexPath)
}

final class CameraTableViewCell: UITableViewCell {
    
//MARK: - IBOutlets
    
    @IBOutlet weak var conteinerView: UIView!
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var imageRec: UIImageView!
    @IBOutlet weak var imageLock: UIImageView!
    @IBOutlet weak var imageStar: UIImageView!
    
//MARK: - Properties
    
    weak var delegate: CameraTableViewCellDelegate?
    
    
//MARK: - LayoutSubviews
    
    override func layoutSubviews() {
        super.layoutSubviews()
        conteinerView.layer.cornerRadius = 10
        conteinerView.layer.masksToBounds = true
    }
    
//MARK: - setupCell
    
    func configure(model: Camera) {
        if model.addedStar ?? false {
            imageStar.image = UIImage(named: Constants.star)
        } else {
            imageStar.image = .none
        }
        label.text = model.name
        label.font = UIFont(name: Constants.font, size: 17)
        imageRec.image = UIImage(named: Constants.rec)
        imageLock.isHidden = true
        if model.rec ?? true {
            imageRec.isHidden = true
        } else {
            imageRec.isHidden = false
        }
        guard let url = URL(string: model.snapshot ?? "") else {
            return}
        webView.load(URLRequest(url: url))
        webView.scrollView.isScrollEnabled = false
        contentView.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        conteinerView.backgroundColor = .white
    }
    
    func configuration(model: Door) {
        if model.addedStar ?? false {
            imageStar.image = UIImage(named: Constants.star)
        } else {
            imageStar.image = .none
        }
        if model.isLocked ?? false {
            imageLock.image = UIImage(named: Constants.unlock)
        } else {
            imageLock.image = UIImage(named: Constants.lock)
        }
        label.text = model.name
        imageLock.isHidden = false
        imageRec.isHidden = true
        guard let url = URL(string: model.snapshot ?? "") else {
            return}
        webView.load(URLRequest(url: url))
    }
    
    func addStar() {
        imageStar.image = UIImage(named: Constants.star)
    }
        
    func removeStar() {
        imageStar.image = .none
    }
    
    func lock() {
        imageLock.image = UIImage(named: Constants.lock)
    }
    
    func unlock() {
        imageLock.image = UIImage(named: Constants.unlock)
    }
}
