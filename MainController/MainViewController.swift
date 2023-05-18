
import UIKit
import RealmSwift

// MARK: - Protocol

protocol MainViewControllerDelegate: AnyObject {
    func updateData()
}

final class MainViewController: UIViewController {
    
//MARK: - @IBOutlets
    
    @IBOutlet weak var segmentControll: CustomSegmentControll!
    @IBOutlet weak var tableView: UITableView!
    
//MARK: - Properties
    
    private lazy var mainModel = MainModel(getApi: APICaller())
    private lazy var refreshControl = UIRefreshControl()
    let realm = try! Realm()
    
//MARK: - Lifecyrcle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        mainModel.checkCamera()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
//MARK: - setup UI
    
    private func setup() {
        configureDelegate()
        configureSegmentControl()
        configureTableView()
        configureRefreshControl()
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        if let font = UIFont(name: Constants.font, size: 21) {
            navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        }
    }
    
    private func configureDelegate() {
        tableView.delegate = self
        tableView.dataSource = self
        mainModel.mainViewControllerDelegate = self
    }
    
    private func configureSegmentControl() {
        segmentControll.addBottomBorderWithColor(color: #colorLiteral(red: 0.874414444, green: 0.8745647073, blue: 0.8744048476, alpha: 1), height: 3.0)
        segmentControll.frame = CGRect(x: self.segmentControll.frame.minX, y: self.segmentControll.frame.minY, width: self.segmentControll.frame.width, height: 50)
        segmentControll.hightlightSelectSegment()
        let font = UIFont(name: Constants.font, size: 17) ?? UIFont.systemFont(ofSize: 17)
        let attributes = [NSAttributedString.Key.font: font]
        segmentControll.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func configureTableView() {
        tableView.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
        tableView.separatorStyle = .none
    }
    
    private func configureRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    private func showAllerController(indexPath: IndexPath) {
        let realm = try! Realm()
        
        let alertController = UIAlertController(title: Constants.title, message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = Constants.placeholder
        }
        alertController.addAction(UIAlertAction(title: Constants.save, style: .default) { [weak self, weak alertController] _ in
            guard let newName = alertController?.textFields?.first?.text else { return }
            
            self?.mainModel.doors[indexPath.row].name = newName
            
            if let door = self?.mainModel.doors[indexPath.row],
               let realmDoor = realm.object(ofType: RealmDoor.self, forPrimaryKey: door.id) {
                try! realm.write {
                    realmDoor.name = newName
                }
            }
            let realmDoors = realm.objects(RealmDoor.self)
            let doors = realmDoors.map { $0.toDoor() }
            self?.mainModel.doors = Array(doors)
            
            self?.tableView.reloadData()
        })
        alertController.addAction(UIAlertAction(title: Constants.titleCancel, style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func refresh(send: UIRefreshControl) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
//MARK: - @IBAction
    
    @IBAction func segmentControllDidChange(_ sender: Any) {
        
        segmentControll.underLinePosition()
        switch segmentControll.selectedSegmentIndex {
        case 0:
            mainModel.changeCurrentData(bool: true)
        case 1:
            mainModel.changeCurrentData(bool: false)
        default:
            break
        }
        tableView.reloadData()
    }
}

//MARK: - UITableViewDelegate

extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
    -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) as? CameraTableViewCell else { return UISwipeActionsConfiguration()}
        switch mainModel.currentDataType {
        case .camera:
            let editingStar = UIContextualAction(style: .destructive, title: nil) { (_, _, completionHandler) in
                completionHandler(true)
                let model = self.mainModel.camera[indexPath.row]
                
                if model.addedStar == false {
                    cell.addStar()
                } else {
                    cell.removeStar()
                }
                cell.delegate?.didTapForStarCamera(at: indexPath)
            }
            editingStar.image = UIImage(named: Constants.editingStar)?.withRenderingMode(.alwaysOriginal).resize(toWidth: 36)
            editingStar.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
            let configuration = UISwipeActionsConfiguration(actions: [editingStar])
            return configuration
        case .doors:
            let editingStar = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
                completionHandler(true)
                let model = self.mainModel.doors[indexPath.row]
                
                if model.addedStar == false {
                    cell.addStar()
                } else {
                    cell.removeStar()
                }
                cell.delegate?.didTapForStarDoor(at: indexPath)
            }
            editingStar.image = UIImage(named: Constants.editingStar)?.withRenderingMode(.alwaysOriginal).resize(toWidth: 36)
            editingStar.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
            
            let configureRename = UIContextualAction(style: .normal, title: nil) { (_, _, completionHandler) in
                completionHandler(true)
                self.showAllerController(indexPath: indexPath)
            }
            configureRename.image = UIImage(named: Constants.rename)?.withRenderingMode(.alwaysOriginal).resize(toWidth: 36)
            configureRename.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
            let configuration = UISwipeActionsConfiguration(actions: [editingStar, configureRename])
            return configuration
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch mainModel.currentDataType {
        case .camera:
            let headerView = UIView()
            headerView.backgroundColor = #colorLiteral(red: 0.9646012187, green: 0.9647662044, blue: 0.9645908475, alpha: 1)
            let label = UILabel()
            label.frame = CGRect(x: 20, y: 0, width: tableView.frame.width, height: 31)
            label.text = Constants.header
            label.font = UIFont(name: Constants.fontTitle, size: 21)
            label.textColor = .black
            headerView.addSubview(label)
            return headerView
        case .doors:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch mainModel.currentDataType {
        case .camera:
            return 31
        case .doors:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mainModel.currentDataType {
        case .camera:
            print("")
        case .doors:
            let cell = tableView.cellForRow(at: indexPath) as? CameraTableViewCell
            let model = mainModel.doors[indexPath.row]
            if model.isLocked == false {
                cell?.unlock()
            } else {
                cell?.lock()
            }
            cell?.delegate?.didTapCell(at: indexPath)
            if indexPath.row == 3 {
                pushVc(model: model.snapshot ?? "")
            }
        }
    }
    
    func pushVc(model: String) {
        let storyBoard = UIStoryboard(name: Constants.main, bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: Constants.secondViewController) as! SecondViewController
        vc.model = model
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - UITableViewDataSource

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mainModel.currentDataType {
        case .camera:
            return mainModel.camera.count
        case .doors:
            return mainModel.doors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.identifire, for: indexPath) as? CameraTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        switch mainModel.currentDataType {
        case .camera:
            let model = mainModel.camera[indexPath.row]
            cell.configure(model: model)
            return cell
        case .doors:
            let model = mainModel.doors[indexPath.row]
            cell.configuration(model: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch mainModel.currentDataType {
        case .camera:
            return 279
        case .doors:
            let model = mainModel.doors[indexPath.row]
            return model.snapshot != nil ? 279 : 92
        }
    }
}

//MARK: - Extension delegates

extension MainViewController: MainViewControllerDelegate {
    
    func updateData() {
        tableView.reloadData()
    }
}

extension MainViewController: CameraTableViewCellDelegate {
    
    func didTapCell(at indexPath: IndexPath) {
        mainModel.doors[indexPath.row].isLocked?.toggle()
        let door = mainModel.doors[indexPath.row]
        let realmDoor = realm.object(ofType: RealmDoor.self, forPrimaryKey: door.id)
        try! realm.write {
            realmDoor?.isLocked = door.isLocked ?? false
        }
        let realmDoors = realm.objects(RealmDoor.self)
        let doors = realmDoors.map { $0.toDoor() }
        mainModel.doors = Array(doors)
    }
    
    func didTapForStarCamera(at indexPath: IndexPath) {
        mainModel.camera[indexPath.row].addedStar?.toggle()
        let camera = mainModel.camera[indexPath.row]
        if let realmCamera = realm.object(ofType: RealmCamera.self, forPrimaryKey: camera.id) {
            try! realm.write {
                realmCamera.addedStar = camera.addedStar ?? false
            }
        }
        tableView.reloadData()
    }
    
    func didTapForStarDoor(at indexPath: IndexPath) {
        mainModel.doors[indexPath.row].addedStar?.toggle()
        let door = mainModel.doors[indexPath.row]
        if let realmDoors = realm.object(ofType: RealmDoor.self, forPrimaryKey: door.id) {
            try! realm.write {
                realmDoors.addedStar = door.addedStar ?? false
            }
        }
        tableView.reloadData()
    }
    
    //Delete all items from Realm
    
    func removeItemFromRealm() {
//        let configuration = Realm.Configuration()
//        try! FileManager.default.removeItem(at: configuration.fileURL!)
//        let realm = try! Realm(configuration: configuration)
    }
}


