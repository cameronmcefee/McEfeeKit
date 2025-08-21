import Foundation

public extension UUID {
  var stub: String {
    String(uuidString.suffix(4))
  }
}
