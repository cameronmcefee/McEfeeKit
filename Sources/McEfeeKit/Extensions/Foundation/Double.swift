import Foundation

// These are all directly copied from CGFloat

public extension Double {
  static let extraSmall: Double = CGFloat.extraSmall
  static let small: Double = CGFloat.small
  static let regular: Double = CGFloat.regular
  static let medium: Double = CGFloat.medium
  static let large: Double = CGFloat.large
  static let extraLarge: Double = CGFloat.extraLarge

  static func aspectRatio(width: CGFloat, height: CGFloat) -> CGFloat {
    CGFloat.aspectRatio(width: width, height: height)
  }

  static func aspectRatio(size: CGSize) -> Double {
    CGFloat.aspectRatio(size: size)
  }

  init?(_ string: String?) {
    guard let string, let value = CGFloat(string) else {
      return nil
    }
    self = value
  }
}
