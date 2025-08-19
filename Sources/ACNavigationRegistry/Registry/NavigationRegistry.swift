//
//  NavigationRegistry.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 16/08/25.
//

import Foundation
import ACSwiftUINavigation


public protocol NavigationRegistry: AnyObject {
    func register<R: AppRoute>(builder: @Sendable @escaping (R.InputPayload) -> R, for routeType: R.Type) async
    
    func resolve<R: AppRoute>(routeType: R.Type, inputPayload: R.InputPayload) async -> R?
    
    func deleteEntry<R: AppRoute>(routeType: R.Type) async
    
    func clear() async
}
