// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable all

internal enum L10n {

  internal enum Alert {

    internal enum Button {
      /// OK
      internal static let ok = L10n.tr("Localizable", "Alert.Button.ok")
    }

    internal enum Title {
      /// Error
      internal static let error = L10n.tr("Localizable", "Alert.Title.error")
      /// Warning
      internal static let warning = L10n.tr("Localizable", "Alert.Title.warning")
    }
  }

  internal enum FilesManagerError {
    /// File already exists
    internal static let fileAlreadyExists = L10n.tr("Localizable", "FilesManagerError.fileAlreadyExists")
    /// File not found
    internal static let fileNotExist = L10n.tr("Localizable", "FilesManagerError.fileNotExist")
    /// Invalid directory
    internal static let invalidDirectory = L10n.tr("Localizable", "FilesManagerError.invalidDirectory")
    /// Reading failed: 
    internal static let readingFailed = L10n.tr("Localizable", "FilesManagerError.readingFailed")
    /// Writting failed: 
    internal static let writtingFailed = L10n.tr("Localizable", "FilesManagerError.writtingFailed")
  }

  internal enum FilterServiceError {
    /// Invalid components String
    internal static let invalidComponentString = L10n.tr("Localizable", "FilterServiceError.invalidComponentString")
    /// Invalid reular expression
    internal static let invalidRegex = L10n.tr("Localizable", "FilterServiceError.invalidRegex")
  }

  internal enum NetworkError {
    /// Invalid URL
    internal static let invalidURL = L10n.tr("Localizable", "NetworkError.invalidURL")
    /// Cant't load data from Network
    internal static let noData = L10n.tr("Localizable", "NetworkError.noData")
    /// Internet Error: 
    internal static let noNetwork = L10n.tr("Localizable", "NetworkError.noNetwork")
  }

  internal enum StringsFilter {
    /// Text filter
    internal static let title = L10n.tr("Localizable", "StringsFilter.title")

    internal enum Button {
      /// Apply
      internal static let apply = L10n.tr("Localizable", "StringsFilter.Button.apply")
      /// Cancel
      internal static let cancel = L10n.tr("Localizable", "StringsFilter.Button.cancel")
    }

    internal enum TextField {
      /// Enter filter text
      internal static let filter = L10n.tr("Localizable", "StringsFilter.TextField.filter")
      /// Enter URL
      internal static let url = L10n.tr("Localizable", "StringsFilter.TextField.url")
    }

    internal enum Warning {
      /// Please, enter URL address
      internal static let noUrL = L10n.tr("Localizable", "StringsFilter.Warning.noUrL")
    }
  }
}

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
// swiftlint:enable all