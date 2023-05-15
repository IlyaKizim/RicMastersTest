
import Foundation
import RealmSwift

enum DataType {
    case camera
    case doors
}

final class MainModel {
    
    //MARK: - Properties
    
    var getApi: GetApi
    var currentDataType: DataType = .camera
    weak var mainViewControllerDelegate: MainViewControllerDelegate?
    lazy var camera: [Camera] = []
    lazy var doors: [Door] = []
    
    let realm = try! Realm()
    
    //MARK: - Initialisation
    
    init(getApi: GetApi) {
        self.getApi = getApi
    }
    
    //MARK: - ChangesFromSegmentControll
    
    func changeCurrentData(bool: Bool) {
        if bool {
            currentDataType = .camera
            checkCamera()
        } else {
            currentDataType = .doors
            checkDoors()
        }
        mainViewControllerDelegate?.updateData()
    }
    
    //MARK: - API
    
    func getData() {
        switch currentDataType {
        case .camera:
            getApi.getCamera {[weak self] (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.camera = data.data.cameras
                        for index in 0..<(self?.camera.count)! {
                            self?.camera[index].addedStar = false
                        }
                        self?.saveCameraData(data.data.cameras)
                        self?.mainViewControllerDelegate?.updateData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        case .doors:
            getApi.getDoors {[weak self] (result) in
                switch result {
                case .success(let data):
                    DispatchQueue.main.async {
                        self?.doors = data
                        for index in 0..<(self?.doors.count)! {
                            self?.doors[index].addedStar = false
                            self?.doors[index].isLocked = false
                        }
                        self?.saveDoorData(data)
                        self?.mainViewControllerDelegate?.updateData()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - RealmSetup
    
    func saveDoorData(_ doors: [Door]) {
        do {
            try realm.write {
                realm.delete(realm.objects(RealmDoor.self))
                
                for door in doors {
                    let realmDoor = RealmDoor()
                    realmDoor.id = door.id ?? 0
                    realmDoor.name = door.name ?? ""
                    realmDoor.room = door.room ?? ""
                    realmDoor.favorites = door.favorites ?? false
                    realmDoor.snapshot = door.snapshot
                    realmDoor.isLocked = door.isLocked ?? false
                    realmDoor.addedStar = door.addedStar ?? false
                    realm.add(realmDoor)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func saveCameraData(_ cameras: [Camera]) {
        do {
            try realm.write {
                realm.delete(realm.objects(RealmCamera.self))
                
                for camera in cameras {
                    let realmCamera = RealmCamera()
                    realmCamera.id = camera.id ?? 0
                    realmCamera.name = camera.name ?? ""
                    realmCamera.room = camera.room ?? ""
                    realmCamera.favorites = camera.favorites ?? false
                    realmCamera.snapshot = camera.snapshot
                    realmCamera.rec = camera.rec ?? false
                    realmCamera.addedStar = camera.addedStar ?? false
                    realm.add(realmCamera)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func checkCamera() {
        if realm.objects(RealmCamera.self).isEmpty {
            getData()
        } else {
            let cameraObjects = realm.objects(RealmCamera.self)
            let camerasFromRealm = cameraObjects.map { cameraRealm -> Camera in
                return Camera(name: cameraRealm.name,
                              snapshot: cameraRealm.snapshot,
                              room: cameraRealm.room,
                              id: cameraRealm.id,
                              favorites: cameraRealm.favorites,
                              rec: cameraRealm.rec,
                              addedStar: cameraRealm.addedStar)
            }
            self.camera = Array(camerasFromRealm)
        }
    }
    
    func checkDoors() {
        if realm.objects(RealmDoor.self).isEmpty {
            getData()
        } else {
            let doorsObjects = realm.objects(RealmDoor.self)
            let doorsFromRealm = doorsObjects.map { doorRealm -> Door in
                return Door(name: doorRealm.name,
                            room: doorRealm.room,
                            id: doorRealm.id,
                            favorites: doorRealm.favorites,
                            snapshot: doorRealm.snapshot,
                            isLocked: doorRealm.isLocked,
                            addedStar: doorRealm.addedStar)
            }
            self.doors = Array(doorsFromRealm)
        }
    }
}

