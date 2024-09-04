import Foundation
import CoreData


extension AlbumData {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumData> {
        return NSFetchRequest<AlbumData>(entityName: "AlbumData")
    }

    @NSManaged public var title: String
    @NSManaged public var wavesIdArray: [Int32]
    @NSManaged public var image: Data?
}

extension AlbumData : Identifiable {

}
