import Foundation

final class LocalStorage {
    private let modelName = "RadioDataModel"
    lazy var coreDataStack = CoreDataStack(modelName: modelName)
    
    func saveContext() {
        coreDataStack.saveContext()
    }
    
    func genreRequestId() {
        
    }
    
    func createOrEditGenre(id: Int, name: String) -> GenreData? {
        var genreResult: GenreData?
        do {
            let genres = try coreDataStack.managedContext.fetch(GenreData.fetchRequest())
            let genre = genres.first(where: {$0.id == Int32(id)})
            if let genre = genre {
                genre.id = Int32(id)
                genre.name = name
                
                genreResult = genre
            } else {
                let genre = GenreData(context: coreDataStack.managedContext)
                genre.id = Int32(id)
                genre.name = name
                genreResult = genre
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return genreResult
    }
    
    func fetchGenres() throws -> [GenreData] {
        try coreDataStack.managedContext.fetch(GenreData.fetchRequest())
    }
    
    func createWaveDataObject(station: StationShort) {
        let waveData = WaveData(context: coreDataStack.managedContext)
        waveData.id = Int32(station.id)
        waveData.imageUrl = station.imageUrl
        waveData.title = station.title
        waveData.url = station.url
        waveData.genreIdArray = station.genreIdArray.map({ value in Int32(value)})
        waveData.isFavourite = station.isFavourite
        //coreDataStack.saveContext()
    }
    
    func editWaveDataObject(station: StationShort) {
        do {
            let waves = try coreDataStack.managedContext.fetch(WaveData.fetchRequest())
            let wave = waves.first(where: {$0.id == Int32(station.id)})
            if let wave = wave {
                wave.id = Int32(station.id)
                wave.imageUrl = station.imageUrl
                wave.title = station.title
                wave.url = station.url
                wave.genreIdArray = station.genreIdArray.map({ value in Int32(value)})
                wave.isFavourite = station.isFavourite
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func createOrEditWaveDataObject(id: Int, imageUrl: String, title: String, url: String, genreIds: [Int32]) -> WaveData? {
        var waveResult: WaveData?
        do {
            let waves = try coreDataStack.managedContext.fetch(WaveData.fetchRequest())
            let wave = waves.first(where: {$0.id == Int32(id)})
            if let wave = wave {
                print("Id founded: \(wave.id), id saving: \(id)")
                wave.id = Int32(id)
                wave.imageUrl = imageUrl
                wave.title = title
                wave.url = url
                wave.genreIdArray = genreIds
                
                waveResult = wave
            } else {
                let waveData = WaveData(context: coreDataStack.managedContext)
                waveData.id = Int32(id)
                waveData.imageUrl = imageUrl
                waveData.title = title
                waveData.url = url
                waveData.genreIdArray = genreIds
                
                waveResult = waveData
            }
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
        return waveResult
    }
    
    func fetchWaves() throws -> Dictionary<Int,StationShort> {
        var stations: Dictionary<Int, StationShort> = [:]
        let waves = try coreDataStack.managedContext.fetch(WaveData.fetchRequest())
        waves.forEach { wave in
            stations.updateValue(StationShort(imageUrl: wave.imageUrl, title: wave.title, url: wave.url, id: Int(wave.id),
                                              genreIdArray: wave.genreIdArray.map({ value in Int(value) }),
                                              isFavourite: wave.isFavourite), forKey: Int(wave.id))
        }
        return stations
    }
    
    func save(album: Album) {
        do {
            let albums = try coreDataStack.managedContext.fetch(AlbumData.fetchRequest())
            if let albumData = albums.first(where: {$0.title == album.title}) {
                //edit
                albumData.title = album.title
                albumData.image = album.image
                albumData.wavesIdArray = album.wavesIdArray.map({ id in Int32(id) })
            } else {
                //create
                let albumData = AlbumData(context: coreDataStack.managedContext)
                albumData.title = album.title
                albumData.image = album.image
                albumData.wavesIdArray = album.wavesIdArray.map({ id in Int32(id) })
            }
            coreDataStack.saveContext()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    func fetchAlbums() throws -> [Album] {
        var albumsArray: Array<Album> = []
        let albumsData = try coreDataStack.managedContext.fetch(AlbumData.fetchRequest())
        albumsData.forEach { albumData in
            var idSet: Set<Int> = []
            albumData.wavesIdArray.forEach { id in
                idSet.insert(Int(id))
            }
            albumsArray.append(Album(image: albumData.image, title: albumData.title, wavesIdArray: idSet))
        }
        return albumsArray
    }
}
