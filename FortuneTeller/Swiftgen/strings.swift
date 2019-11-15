// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {
  /// type
  internal static let affirmative = L10n.tr("Localizable", "Affirmative")
  /// section title
  internal static let answerHistory = L10n.tr("Localizable", "Answer history")
  /// alert title
  internal static let answerHistoryIsMissing = L10n.tr("Localizable", "Answer history is missing")
  /// key
  internal static let attemts = L10n.tr("Localizable", "Attemts")
  /// title
  internal static let close = L10n.tr("Localizable", "Close")
  /// type
  internal static let contrary = L10n.tr("Localizable", "Contrary")
  /// cell text
  internal static let createCustomAnswer = L10n.tr("Localizable", "Create custom answer")
  /// key
  internal static let date = L10n.tr("Localizable", "date")
  /// title
  internal static let dismiss = L10n.tr("Localizable", "Dismiss")
  /// title
  internal static let done = L10n.tr("Localizable", "Done")
  /// title
  internal static let edit = L10n.tr("Localizable", "Edit")
  /// warningLabel
  internal static let emptyField = L10n.tr("Localizable", "Empty field")
  /// placeholder
  internal static let enterYourAnswer = L10n.tr("Localizable", "Enter your answer")
  /// counterLabel
  internal static let lifetimeApplicationPredictions = L10n.tr("Localizable", "Lifetime application predictions: ")
  /// title
  internal static let main = L10n.tr("Localizable", "Main")
  /// type
  internal static let neutral = L10n.tr("Localizable", "Neutral")
  /// label
  internal static let pickType = L10n.tr("Localizable", "Pick type")
  /// placeholder
  internal static let saveAnswer = L10n.tr("Localizable", "Save answer")
  /// HUDView titile
  internal static let saved = L10n.tr("Localizable", "Saved")
  /// section title
  internal static let savedAnswers = L10n.tr("Localizable", "Saved answers")
  /// xcdatamodel
  internal static let savedAnswerModel = L10n.tr("Localizable", "SavedAnswerModel")
  /// warning
  internal static let seemsLikeYouOfflineAddCustomAnswer = L10n.tr("Localizable", "Seems like you offline, add custom answer")
  /// title
  internal static let settings = L10n.tr("Localizable", "Settings")
  /// questionLabel
  internal static let shakeDeviceToGetTheAnswer = L10n.tr("Localizable", "Shake device to get the answer")
  /// title
  internal static let sorry = L10n.tr("Localizable", "Sorry")
  /// message
  internal static let theAnswerAlreadyExists = L10n.tr("Localizable", "The answer already exists")
  /// alert message
  internal static let thereIsNothingToEdit = L10n.tr("Localizable", "There is nothing to edit")
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
