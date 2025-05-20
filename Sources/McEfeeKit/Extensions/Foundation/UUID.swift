import Foundation

public extension UUID {
  var stub: String {
    String(uuidString.prefix(4))
  }
}
