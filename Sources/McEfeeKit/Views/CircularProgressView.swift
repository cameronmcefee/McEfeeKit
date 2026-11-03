import SwiftUI

/// A circular progress indicator, spinning while `progress` is negative and
/// filling to it otherwise, which reads as a `ProgressView` to VoiceOver.
public struct CircularProgressView: View {
  private let progress: Double
  private let lineWidth: CGFloat
  private let tint: Color

  public init(
    progress: Double = -1,
    lineWidth: CGFloat = 8,
    tint: Color = .accentColor,
  ) {
    self.progress = progress
    self.lineWidth = lineWidth
    self.tint = tint
  }

  public var body: some View {
    ZStack {
      Circle()
        .inset(by: lineWidth / 2)
        .stroke(tint.opacity(0.2), lineWidth: lineWidth)
      ProgressArc(targetProgress: progress, lineWidth: lineWidth, tint: tint)
    }
    .aspectRatio(1, contentMode: .fit)
    .accessibilityRepresentation {
      ProgressView(value: progress < 0 ? nil : progress)
    }
  }
}

private struct ProgressArc: View {
  let targetProgress: Double
  let lineWidth: CGFloat
  let tint: Color

  private let cycleDuration: Double = 1.0
  // Near zero rather than zero, so the round caps still show a dot.
  private let minArcLength: Double = 0.001
  private let maxArcLength: Double = 0.25

  @State private var isIndeterminate = true
  @State private var displayedProgress: Double = 0
  @State private var displayedRotation: Double = -90
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  private var isTargetIndeterminate: Bool {
    targetProgress < 0
  }

  var body: some View {
    TimelineView(.animation(paused: !isIndeterminate)) { timeline in
      let phase = timeline.date.timeIntervalSinceReferenceDate
        .truncatingRemainder(dividingBy: cycleDuration) / cycleDuration
      let easedPulse = 0.5 - 0.5 * cos(phase * 2 * .pi)
      let indeterminateArcLength = minArcLength + (maxArcLength - minArcLength) * easedPulse
      // Partly linear, so the arc never comes to a stop.
      let easedRotation = 0.5 - 0.5 * cos(phase * .pi)
      let rotation = (0.8 * easedRotation + 0.2 * phase) * 360
      let arcLength = isIndeterminate ? indeterminateArcLength : max(minArcLength, displayedProgress)
      let indeterminateRotation = rotation - 90 - indeterminateArcLength * 180
      let arcRotation = isIndeterminate ? indeterminateRotation : displayedRotation

      Circle()
        .inset(by: lineWidth / 2)
        .trim(from: 0, to: arcLength)
        .stroke(tint, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
        .rotationEffect(.degrees(arcRotation))
        .onChange(of: isTargetIndeterminate) { _, newValue in
          if newValue {
            isIndeterminate = true
          }
        }
        .onChange(of: phase) { oldPhase, newPhase in
          // Only as a cycle wraps round, so the spin hands over to the
          // fill from where the arc is rather than jumping.
          if !isTargetIndeterminate, isIndeterminate, newPhase < oldPhase {
            displayedRotation = indeterminateRotation
            isIndeterminate = false
            withAnimation(reduceMotion: reduceMotion, .easeOut(duration: 0.3)) {
              displayedProgress = targetProgress
              displayedRotation = -90
            }
          }
        }
        .onChange(of: targetProgress) { _, newValue in
          if !isIndeterminate, newValue >= 0 {
            withAnimation(reduceMotion: reduceMotion, .easeOut(duration: 0.2)) {
              displayedProgress = newValue
            }
          }
        }
    }
  }
}

/// Shows its content only after a delay elapses. If removed from the
/// hierarchy before the delay completes, the content never appears.
/// This prevents brief spinner flashes during near-instant loads.
public struct DelayedSpinner<Content: View>: View {
  private let delay: Duration
  private let content: Content

  @State private var isVisible = false
  @Environment(\.accessibilityReduceMotion) private var reduceMotion

  public init(delay: Duration = .milliseconds(500), @ViewBuilder content: () -> Content) {
    self.delay = delay
    self.content = content()
  }

  public var body: some View {
    content
      .opacity(isVisible ? 1 : 0)
      .task {
        try? await Task.sleep(for: delay)
        guard !Task.isCancelled else { return }
        withAnimation(reduceMotion: reduceMotion, .easeIn(duration: 0.15)) {
          isVisible = true
        }
      }
  }
}

#Preview("Determinate") {
  VStack(spacing: 40) {
    CircularProgressView(progress: 0.3)
      .frame(width: 60, height: 60)
    CircularProgressView(progress: 0.65)
      .frame(width: 60, height: 60)
    CircularProgressView(progress: 0.9, tint: .green)
      .frame(width: 60, height: 60)
  }
  .padding()
}

#Preview("Indeterminate") {
  VStack(spacing: 40) {
    CircularProgressView()
      .frame(width: 60, height: 60)
    CircularProgressView(lineWidth: 3, tint: .white)
      .frame(width: 22, height: 22)
  }
  .padding()
}

#Preview("Transition") {
  struct TransitionDemo: View {
    @State private var progress: Double = -1

    var body: some View {
      VStack(spacing: 40) {
        CircularProgressView(progress: progress)
          .frame(width: 60, height: 60)
        Button(progress < 0 ? "Start Progress" : "Reset") {
          progress = progress < 0 ? 0.1 : -1
        }
      }
      .padding()
      .task(id: progress < 0) {
        while progress >= 0, progress < 1 {
          try? await Task.sleep(for: .milliseconds(500))
          progress += 0.15
        }
      }
    }
  }

  return TransitionDemo()
}
