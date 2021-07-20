/// The values true and false are synonymous with auto and none, respectively.
enum Preload {
  /// Only vide metadata is preloaded
  metadata,

  /// All data is preloaded
  auto,

  /// No data, other than the bare minimum to render a video player on the page, is preloaded
  none
}
