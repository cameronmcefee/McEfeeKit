import SwiftUI

public func withAnimation<T>(reduceMotion: Bool, _ animation: Animation = .default, _ body: () -> T) -> T {
  // Nil rather than running body bare, so an enclosing animation can't leak
  // through to someone who asked for reduced motion.
  SwiftUI.withAnimation(reduceMotion ? nil : animation, body)
}
