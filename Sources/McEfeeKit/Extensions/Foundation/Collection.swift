public extension Collection where Indices.Iterator.Element == Index {
  subscript(safe index: Index) -> Iterator.Element? {
    return (startIndex <= index && index < endIndex) ? self[index] : nil
  }

  func sorted<Value: Comparable>(
    by keyPath: KeyPath<Element, Value>,
    _ comparator: (Value, Value) -> Bool = (<)
  ) -> [Element] {
    return sorted {
      comparator($0[keyPath: keyPath], $1[keyPath: keyPath])
    }
  }
}
