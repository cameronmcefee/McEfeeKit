import SwiftUI

public func withAnimation<T>(reduceMotion: Bool, _ animation: Animation = .default, _ body: () -> T) -> T {
  if reduceMotion {
    return body()
  } else {
    return SwiftUI.withAnimation(animation, body)
  }
}
