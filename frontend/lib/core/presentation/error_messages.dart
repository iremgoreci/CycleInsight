import '../../l10n/l10n.dart';
import '../errors/api_exception.dart';

/// Turns errors into localized, user-facing text.
///
/// The backend returns fixed English `detail` strings. They are matched
/// here (with status-code fallbacks) so raw English never reaches the UI
/// and the API contract stays unchanged.
class ErrorText {
  const ErrorText._();

  /// Known backend `detail` values → localized text.
  static String? _fromDetail(AppLocalizations l10n, String message) {
    if (message.contains('End date cannot be before start date')) {
      return l10n.errorEndBeforeStart;
    }
    return switch (message) {
      'Unable to reach the server' => l10n.errorNetwork,
      'Incorrect email or password' => l10n.errorInvalidCredentials,
      'Email already exists.' => l10n.errorEmailExists,
      'Could not validate credentials' => l10n.errorSessionExpired,
      'A cycle with this start date already exists.' =>
        l10n.errorCycleDuplicateStart,
      'A daily log already exists for this date.' => l10n.errorDailyLogExists,
      'Daily log not found' => l10n.errorDailyLogNotFound,
      'Cycle not found' => l10n.errorCycleNotFound,
      'Daily log symptom not found' ||
      'Symptom type not found' => l10n.errorNotFound,
      _ => null,
    };
  }

  /// Localized message for [error]. [fallback] is used for errors that
  /// carry no recognisable detail or status (defaults to a generic text).
  static String of(AppLocalizations l10n, Object error, {String? fallback}) {
    if (error is! ApiException) {
      return fallback ?? l10n.errorGeneric;
    }
    final known = _fromDetail(l10n, error.message);
    if (known != null) {
      return known;
    }
    final status = error.statusCode;
    if (status == null) {
      return fallback ?? l10n.errorGeneric;
    }
    if (status == 401) {
      return l10n.errorSessionExpired;
    }
    if (status == 404) {
      return l10n.errorNotFound;
    }
    if (status == 400 || status == 422) {
      return l10n.errorInvalidInput;
    }
    if (status >= 500) {
      return l10n.errorServer;
    }
    return fallback ?? l10n.errorGeneric;
  }
}
