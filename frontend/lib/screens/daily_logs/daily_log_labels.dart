import 'package:flutter/widgets.dart';

import '../../l10n/l10n.dart';

/// Localized labels for the daily-log levels. Level values (and their
/// ranges) match the API: bleeding/pain/sleep/stress 0–5, mood 1–5.
class DailyLogLabels {
  const DailyLogLabels(this._l10n);

  factory DailyLogLabels.of(BuildContext context) =>
      DailyLogLabels(AppLocalizations.of(context));

  final AppLocalizations _l10n;

  Map<int, String> get bleeding => {
    0: _l10n.bleedingLevel0,
    1: _l10n.bleedingLevel1,
    2: _l10n.bleedingLevel2,
    3: _l10n.bleedingLevel3,
    4: _l10n.bleedingLevel4,
    5: _l10n.bleedingLevel5,
  };

  Map<int, String> get mood => {
    1: _l10n.moodLevel1,
    2: _l10n.moodLevel2,
    3: _l10n.moodLevel3,
    4: _l10n.moodLevel4,
    5: _l10n.moodLevel5,
  };

  Map<int, String> get pain => {
    0: _l10n.painLevel0,
    1: _l10n.painLevel1,
    2: _l10n.painLevel2,
    3: _l10n.painLevel3,
    4: _l10n.painLevel4,
    5: _l10n.painLevel5,
  };

  Map<int, String> get sleep => {
    0: _l10n.sleepLevel0,
    1: _l10n.sleepLevel1,
    2: _l10n.sleepLevel2,
    3: _l10n.sleepLevel3,
    4: _l10n.sleepLevel4,
    5: _l10n.sleepLevel5,
  };

  Map<int, String> get stress => {
    0: _l10n.stressLevel0,
    1: _l10n.stressLevel1,
    2: _l10n.stressLevel2,
    3: _l10n.stressLevel3,
    4: _l10n.stressLevel4,
    5: _l10n.stressLevel5,
  };
}
