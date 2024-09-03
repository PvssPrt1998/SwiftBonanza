
import Foundation
import CoreData


extension GenreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GenreData> {
        return NSFetchRequest<GenreData>(entityName: "GenreData")
    }

    @NSManaged public var name: String
    @NSManaged public var id: Int32

}

extension GenreData : Identifiable {

}
