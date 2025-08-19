//
//  AppRoute.swift
//  ACSwiftUINavigation
//
//  Created by Antonio Casto on 09/08/25.
//

import SwiftUI


public protocol AppRoute: Identifiable, Hashable, Sendable {
    associatedtype InputPayload: Sendable
    
    //MARK: - Properties
    
    var presentationStyle: PresentationStyle { get }
    
    //MARK: - Methods
    
    @ViewBuilder
    func buildView() -> any View
}
