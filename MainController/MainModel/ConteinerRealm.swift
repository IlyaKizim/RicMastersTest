
import Foundation
import RealmSwift

class RealmDoor: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var room: String
    @Persisted var favorites: Bool
    @Persisted var snapshot: String?
    @Persisted var isLocked: Bool
    @Persisted var addedStar: Bool
    
    convenience init(realmDoor: RealmDoor) {
            self.init()
            id = realmDoor.id
            name = realmDoor.name
            room = realmDoor.room
            favorites = realmDoor.favorites
            snapshot = realmDoor.snapshot
            isLocked = realmDoor.isLocked
            addedStar = realmDoor.addedStar
        }
}

class RealmCamera: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var snapshot: String?
    @Persisted var room: String
    @Persisted var favorites: Bool
    @Persisted var rec: Bool
    @Persisted var addedStar: Bool
    
    convenience init(realmDoor: RealmCamera) {
            self.init()
            id = realmDoor.id
            name = realmDoor.name
            room = realmDoor.room
            favorites = realmDoor.favorites
            snapshot = realmDoor.snapshot
            rec = realmDoor.rec
            addedStar = realmDoor.addedStar
        }
}


extension RealmDoor {
    func toDoor() -> Door {
        return Door(name: self.name, room: self.room, id: self.id, favorites: self.favorites, snapshot: self.snapshot, isLocked: self.isLocked, addedStar: self.addedStar)
    }
}

extension RealmCamera {
    func toDoor() -> Camera {
        return Camera(name: self.name, snapshot: self.snapshot, room: self.room, id: self.id, favorites: self.favorites, rec: self.rec, addedStar: self.addedStar)
    }
}
