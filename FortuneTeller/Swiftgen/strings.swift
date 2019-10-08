// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// title
  internal static let close = L10n.tr("Localizable", "Close")
  /// title
  internal static let dismiss = L10n.tr("Localizable", "Dismiss")
  /// warningLabel
  internal static let emptyField = L10n.tr("Localizable", "Empty field")
  /// placeholder
  internal static let enterYourAnswer = L10n.tr("Localizable", "Enter your answer")
  /// counterLabel
  internal static let lifetimeApplicationPredictions = L10n.tr("Localizable", "Lifetime application predictions:")
  /// title
  internal static let main = L10n.tr("Localizable", "Main")
  /// placeholder
  internal static let saveAnswer = L10n.tr("Localizable", "Save answer")
  /// questionLabel
  internal static let shakeDeviceToGetTheAnswer = L10n.tr("Localizable", "Shake device to get the answer")
  /// title
  internal static let sorry = L10n.tr("Localizable", "Sorry")
  /// message
  internal static let theAnswerAlreadyExists = L10n.tr("Localizable", "The answer already exists")
  /// title
  internal static let youSavedAnswer = L10n.tr("Localizable", "You saved answer")
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    // swiftlint:disable:next nslocalizedstring_key
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
