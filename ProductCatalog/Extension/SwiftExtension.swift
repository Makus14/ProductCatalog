//
//  SwiftExtension.swift
//  ProductCatalog
//
//  Created by Mac on 15/06/2023.
//

import Foundation

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
