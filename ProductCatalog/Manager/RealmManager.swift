//
//  RealmManager.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import Foundation
import RealmSwift

class RealmManager<T> where T: Object {
    private let realm = try! Realm()
    
    func write(object: T) {
        
        try? realm.write {
            realm.add(object)
        }
        
    }
    
    func update(realmBlock: @escaping (Realm) -> Void) {
        realmBlock(self.realm)
    }
    
    func delete(object: T) {
        
        try? realm.write {
            realm.delete(object)
        
        }
    }
    
    func read() -> [T] {
        return Array(realm.objects(T.self))
    }
}
