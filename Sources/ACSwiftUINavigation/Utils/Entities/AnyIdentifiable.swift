//
//  AnyIdentifiable.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import Foundation

public struct AnyIdentifiable: Identifiable, Equatable, Hashable {
    //MARK: - Initializer
    
    public init<T: Identifiable>(_ value: T) {
        self.id = AnyHashable(value.id)
        self.wrapped = value
    }
    
    //MARK: - Properties
    
    public let id: AnyHashable
    public let wrapped: any Identifiable
    
    //MARK: - Methods
    
    public static func == (lhs: AnyIdentifiable, rhs: AnyIdentifiable) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
