//	
// Copyright © Essential Developer. All rights reserved.
//

import Foundation

protocol ItemsService {
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void)
}

extension ItemsService {
    func fallback(_ fallback: ItemsService) -> ItemsService {
        ItemServiceWithFallback(primery: self, fallback: fallback)
    }
    
    func retry(_ retryCount: UInt) -> ItemsService {
        var service: ItemsService = self
        for _ in 0 ..< retryCount {
            service = service.fallback(self)
        }
        return service
    }
}

struct ItemServiceWithFallback: ItemsService {
    var primery: ItemsService
    var fallback: ItemsService
    
    func loadItems(completion: @escaping (Result<[ItemViewModel], Error>) -> Void) {
        primery.loadItems { result in
            switch result {
            case .success:
                completion(result)
            case .failure:
                fallback.loadItems(completion: completion)
            }
        }
    }
}
