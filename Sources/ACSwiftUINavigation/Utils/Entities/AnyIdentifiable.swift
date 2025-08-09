//
//  AnyIdentifiable.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import Foundation

final class AnyIdentifiable: Identifiable {
    //MARK: - Initializer
    
    init<T: Identifiable>(_ value: T) {
        self.wrapped = value
    }
    
    //MARK: - Properties
    
    let id = UUID()
    let wrapped: any Identifiable
    
}
