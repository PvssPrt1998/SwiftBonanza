import Foundation

struct Album: Hashable {
    var image: Data?
    var title: String
    var wavesIdArray: Set<Int>
}
