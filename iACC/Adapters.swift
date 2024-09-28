//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

struct FriendsCacheItemsServiceAdapter: ItemsService {
    var cache: FriendsCache
    var select: (Friend) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        cache.loadFriends { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items.map { item in
                        ItemViewModel(item) {
                            select(item)
                        }
                    }
                })
            }
        }
    }
}

struct FriendsAPIItemsServiceAdapter: ItemsService {
    var api: FriendsAPI
    var cache: FriendsCache
    var select: (Friend) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadFriends { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    cache.save(items)
                    return items.map { item in
                        ItemViewModel(item) {
                            select(item)
                        }
                    }
                })
            }
        }
    }
}

struct CardAPIItemsServiceAdapter: ItemsService {
    var api: CardAPI
    var select: (Card) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadCards { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items.map { item in
                        ItemViewModel(item) {
                            select(item)
                        }
                    }
                })
            }
        }
    }
}

struct SentTransfersAPIItemsServiceAdapter: ItemsService {
    var api: TransfersAPI
    var select: (Transfer) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadTransfers { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items
                        .filter { $0.isSender }
                        .map { item in
                        ItemViewModel(item, longDateStyle: true) {
                            select(item)
                        }
                    }
                })
            }
        }
    }
}

struct RecevedTransfersAPIItemsServiceAdapter: ItemsService {
    var api: TransfersAPI
    var select: (Transfer) -> Void
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        api.loadTransfers { result in
            DispatchQueue.mainAsyncIfNeeded {
                completion(result.map { items in
                    items
                        .filter { !$0.isSender }
                        .map { item in
                        ItemViewModel(item, longDateStyle: false) {
                            select(item)
                        }
                    }
                })
            }
        }
    }
}
