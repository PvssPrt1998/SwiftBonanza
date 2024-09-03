import Foundation
import CoreData


extension WaveData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WaveData> {
        return NSFetchRequest<WaveData>(entityName: "WaveData")
    }

    @NSManaged public var imageUrl: String
    @NSManaged public var title: String
    @NSManaged public var url: String
    @NSManaged public var id: Int32
    @NSManaged public var genreIdArray: [Int32]
    @NSManaged public var isFavourite: Bool
}

extension WaveData : Identifiable {

}
