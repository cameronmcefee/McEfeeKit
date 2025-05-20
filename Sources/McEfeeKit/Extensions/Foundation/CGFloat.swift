import Foundation

// These should all have equivalents on Double

public extension CGFloat {
  static let extraSmall: CGFloat = 2
  static let small: CGFloat = 4
  static let regular: CGFloat = 8
  static let medium: CGFloat = 16
  static let large: CGFloat = 32
  static let extraLarge: CGFloat = 64

  static func aspectRatio(width: CGFloat, height: CGFloat) -> CGFloat {
    guard height != 0 else { return 1 }
    return width / height
  }
  
  static func aspectRatio(size: CGSize) -> CGFloat {
    aspectRatio(width: size.width, height: size.height)
  }
  
  init?(_ string: String?) {
    guard let string, let value = Double(string) else {
      return nil
    }
    self = value
  }
}
