/// - share (dict): globally shared state for cross-document configuration.
///   Examples: toc visibility, sider toggle, theme settings.
#let share = state("share", (
  sider: false,
  toc: true,
))

/// Update a shared configuration value.
/// - key (str): the key to set
/// - val (any): the value to assign
/// -> none
#let update-share(key, val) = {
  share.update(prev => (..prev, (key): val))
}
