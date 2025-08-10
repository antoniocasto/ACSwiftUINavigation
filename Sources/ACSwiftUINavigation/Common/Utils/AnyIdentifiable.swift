//
//  AnyIdentifiable.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import Foundation

/// A type-erased wrapper for any value conforming to the `Identifiable` protocol.
///
/// `AnyIdentifiable` allows storage and use of heterogeneous `Identifiable` types by erasing their concrete types,
/// while still exposing their identity and supporting value-based operations such as equality and hashing via their `id`.
///
/// This is particularly useful when you need to store or compare a collection of different `Identifiable` types,
/// but want to treat them uniformly by their identifier.
///
/// - Note: Equality and hashing are based solely on the underlying identifier (`id`) of the wrapped value.
///
/// Example:
/// ```swift
/// struct User: Identifiable {
///     let id: UUID
///     let name: String
/// }
///
/// let user1 = User(id: UUID(), name: "Alice")
/// let anyIdentifiable = AnyIdentifiable(user1)
/// ```
///
/// - SeeAlso: `Identifiable`
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
