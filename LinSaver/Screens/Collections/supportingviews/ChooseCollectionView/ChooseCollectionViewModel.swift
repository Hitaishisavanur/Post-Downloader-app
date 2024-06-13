

import Foundation

class ChooseCollectionViewModel: ObservableObject {
    
    
    @Published var collections: [MediaCollection] = []
    private var dataController = DataController.shared
    

    
    func fetchCollections() {
        collections = dataController.fetchCollections()
    }
    
    func moveToCollection(mediaItemId: UUID, collectionId: UUID){
        dataController.addMediaToCollection(mediaId: mediaItemId, collectionId: collectionId)
    }
    
}
