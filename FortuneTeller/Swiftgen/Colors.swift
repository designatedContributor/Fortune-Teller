// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

#if os(OSX)
  import AppKit.NSColor
  internal typealias Color = NSColor
#elseif os(iOS) || os(tvOS) || os(watchOS)
  import UIKit.UIColor
  internal typealias Color = UIColor
#endif

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Colors

// swiftlint:disable identifier_name line_length type_body_length
internal struct ColorName {
  internal let rgbaValue: UInt32
  internal var color: Color { return Color(named: self) }

  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#78fe7e"></span>
  /// Alpha: 100% <br/> (0x78fe7eff)
  internal static let affirmative = ColorName(rgbaValue: 0x78fe7eff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#0ea200"></span>
  /// Alpha: 100% <br/> (0x0ea200ff)
  internal static let affirmativeText = ColorName(rgbaValue: 0x0ea200ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#003367"></span>
  /// Alpha: 100% <br/> (0x003367ff)
  internal static let background = ColorName(rgbaValue: 0x003367ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#000000"></span>
  /// Alpha: 100% <br/> (0x000000ff)
  internal static let black = ColorName(rgbaValue: 0x000000ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffcccb"></span>
  /// Alpha: 100% <br/> (0xffcccbff)
  internal static let contrary = ColorName(rgbaValue: 0xffcccbff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2bedbb"></span>
  /// Alpha: 100% <br/> (0x2bedbbff)
  internal static let cyan = ColorName(rgbaValue: 0x2bedbbff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#efeff4"></span>
  /// Alpha: 100% <br/> (0xefeff4ff)
  internal static let groupTableView = ColorName(rgbaValue: 0xefeff4ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#71e1ff"></span>
  /// Alpha: 100% <br/> (0x71e1ffff)
  internal static let neutral = ColorName(rgbaValue: 0x71e1ffff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#2780ff"></span>
  /// Alpha: 100% <br/> (0x2780ffff)
  internal static let neutralText = ColorName(rgbaValue: 0x2780ffff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ff0000"></span>
  /// Alpha: 100% <br/> (0xff0000ff)
  internal static let red = ColorName(rgbaValue: 0xff0000ff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#1c549e"></span>
  /// Alpha: 100% <br/> (0x1c549eff)
  internal static let tabbar = ColorName(rgbaValue: 0x1c549eff)
  /// <span style="display:block;width:3em;height:2em;border:1px solid black;background:#ffffff"></span>
  /// Alpha: 100% <br/> (0xffffffff)
  internal static let white = ColorName(rgbaValue: 0xffffffff)
}
// swiftlint:enable identifier_name line_length type_body_length

// MARK: - Implementation Details

// swiftlint:disable operator_usage_whitespace
internal extension Color {
  convenience init(rgbaValue: UInt32) {
    let red   = CGFloat((rgbaValue >> 24) & 0xff) / 255.0
    let green = CGFloat((rgbaValue >> 16) & 0xff) / 255.0
    let blue  = CGFloat((rgbaValue >>  8) & 0xff) / 255.0
    let alpha = CGFloat((rgbaValue      ) & 0xff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
}
// swiftlint:enable operator_usage_whitespace

internal extension Color {
  convenience init(named color: ColorName) {
    self.init(rgbaValue: color.rgbaValue)
  }
}
