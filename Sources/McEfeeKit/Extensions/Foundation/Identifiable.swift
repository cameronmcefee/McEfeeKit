// Search an array of identifiable objects by their id.

public extension Array where Element: Identifiable {
  func contains(id: Element.ID) -> Bool {
    return contains { $0.id == id }
  }
}
