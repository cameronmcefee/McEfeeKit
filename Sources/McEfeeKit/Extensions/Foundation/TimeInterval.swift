import Foundation

public extension TimeInterval {
  private static let minute = 60.0
  private static let hour = minute * 60.0
  private static let day = hour * 24.0

  var minutes: Double {
    return self / Self.minute
  }

  var hours: Double {
    return self / Self.hour
  }
  
  var days: Double {
    return self / Self.day
  }

  init(minutes: Double) {
    self = minutes * Self.minute
  }

  init(hours: Double) {
    self = hours * Self.hour
  }
  
  init(days: Double) {
    self = days * Self.day
  }
}
