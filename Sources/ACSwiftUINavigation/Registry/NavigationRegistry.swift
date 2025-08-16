//
//  NavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation

public final actor NavigationRegistry {
    //MARK: - Properties
    
    private var registry: [ObjectIdentifier: any RoutableModuleFactory] = [:]
    
    //MARK: - Methods
    
    public func register(factory: any RoutableModuleFactory, for type: RoutableModuleFactory.Type) {
        registry[ObjectIdentifier(type)] = factory
    }
    
    public func resolve(factoryType type: RoutableModuleFactory.Type) -> (any RoutableModuleFactory)? {
        registry[ObjectIdentifier(type)]
    }
}
