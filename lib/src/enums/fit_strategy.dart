enum FitStrategy {
  /// The video will resize to fit within the parent container and maintain its aspect ratio. This will create a “letterboxing” effect.
  contain,

  /// The video will maintain its aspect ratio and resize to completely fill its parent container. Anything that doesn’t fit within the container will be cut off.
  cover,

  /// The video will stretch to fill the container.
  fill,

  /// The video won’t resize to fit its parent container.
  none
}
