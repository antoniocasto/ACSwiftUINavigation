# ACSwiftUINavigation - SwiftUI Modular Navigation (iOS 17+)

This repository is a **personal exercise** packaged as a Swift Package Manager (SPM) library.  
It represents a **custom evolution** of the navigation architecture introduced by Felipe Espinoza in his [MovieCatalog](https://github.com/fespinoza/Youtube-SampleProjects/tree/movie-catalog-routing/00-routing-and-deep-links/MovieCatalog) project.  

The main goal is to explore, adapt, and extend the original concepts into a **scalable, modular, and testable SwiftUI navigation system for iOS 17+**, capable of handling:

- **Push navigation** with `NavigationStack`
- **Sheet** and **FullScreen** presentations
- **Tab navigation** (including programmatic tab selection)
- **Deep Links** and **Universal Links** (Planned)
- **Modular routing**, where feature modules can register their own destinations (for modular apps)

---

## Why This Library?

The default SwiftUI navigation has several limitations:
- Tight coupling between origin and destination views.
- Difficulties in managing push, sheet, and full screen uniformly.
- Complexities in implementing deep links and universal links (Planned).
- A single global `Destination` enum is not extensible across modules.

This library addresses those issues by providing:
- **Decoupled views**: origin and destination communicate through a central router.
- **A unified entry point for all navigation**.
- **Easier deep link and universal link support (Planned)**.
- **Extensibility**: each module can declare and register its own destinations.
- **Programmatic navigation** by interacting directly with NavigationRouter.

---

## Architecture Overview

- **NavigationRouter**  
  Manages navigation state (`push`, `sheet`, `fullscreen`, selected tab).  
  Supports parent/child hierarchies for tabs and modal containers.

- **AppRoute**  
  Defines a presentable screen (push, sheet, fullscreen, tab via **PresentationStyle**).  

- **NavigationContainer**  
  A wrapper around `NavigationStack` that applies `navigationDestination`, `sheet`, and `fullScreenCover` modifiers.  
  It also injects the `Router` into the SwiftUI environment.

- **NavigationButton**  
  A lightweight alternative to `NavigationLink` for programmatic navigation with destinations.
  
- **NavigationTab**  
  A custom version of the .tabItem(). Encapsulates how an id is applied via a tag modifier.

- **Deep Linking (Planned)**  
  Incoming URLs are parsed and mapped to destinations.  
  This will evolve into a **DeepLinkRegistry**, allowing each app or module to register its own parsers independently.

---

## TODO / Work in Progress

- [ ] Add more usage examples in the demo app (e.g. programmatic tab selection).  
- [ ] Expand usage samples for `push`, `sheet`, and `fullscreen` navigation in real-world contexts.  
- [ ] Add cross-module navigation examples.  
- [ ] Implement a **DeepLinkRegistry** for modular deep link registration.  
- [ ] Add **unit tests**.  

---

## DeepLinkRegistry (Planned)

The `DeepLinkRegistry` will allow apps and modules to register deep link parsers separately, removing the need for a single central definition.
