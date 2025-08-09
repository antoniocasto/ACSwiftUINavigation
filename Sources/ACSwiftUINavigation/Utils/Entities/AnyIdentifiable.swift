//
//  AnyIdentifiable.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import Foundation

public final class AnyIdentifiable: Identifiable {
    //MARK: - Initializer
    
    public init<T: Identifiable>(_ value: T) {
        self.wrapped = value
    }
    
    //MARK: - Properties
    
    public let id = UUID()
    public let wrapped: any Identifiable
}
