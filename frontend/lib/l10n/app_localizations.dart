import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('tr')];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'CycleInsight'**
  String get appTitle;

  /// No description provided for @commonTryAgain.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar dene'**
  String get commonTryAgain;

  /// No description provided for @commonRetry.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden dene'**
  String get commonRetry;

  /// No description provided for @commonCancel.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get commonEdit;

  /// No description provided for @commonMore.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get commonMore;

  /// No description provided for @commonSaveChanges.
  ///
  /// In tr, this message translates to:
  /// **'Değişiklikleri kaydet'**
  String get commonSaveChanges;

  /// No description provided for @commonChange.
  ///
  /// In tr, this message translates to:
  /// **'Değiştir'**
  String get commonChange;

  /// No description provided for @commonNotEnoughData.
  ///
  /// In tr, this message translates to:
  /// **'Yeterli veri yok'**
  String get commonNotEnoughData;

  /// No description provided for @commonEstimated.
  ///
  /// In tr, this message translates to:
  /// **'tahmini'**
  String get commonEstimated;

  /// No description provided for @commonToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get commonToday;

  /// No description provided for @commonYesterday.
  ///
  /// In tr, this message translates to:
  /// **'Dün'**
  String get commonYesterday;

  /// No description provided for @commonTomorrow.
  ///
  /// In tr, this message translates to:
  /// **'Yarın'**
  String get commonTomorrow;

  /// No description provided for @relativeInDays.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 gün sonra} other{{count} gün sonra}}'**
  String relativeInDays(int count);

  /// No description provided for @relativeDaysAgo.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 gün önce} other{{count} gün önce}}'**
  String relativeDaysAgo(int count);

  /// No description provided for @daysCount.
  ///
  /// In tr, this message translates to:
  /// **'{count, plural, =1{1 gün} other{{count} gün}}'**
  String daysCount(int count);

  /// No description provided for @unitDays.
  ///
  /// In tr, this message translates to:
  /// **'gün'**
  String get unitDays;

  /// No description provided for @unitOutOfFive.
  ///
  /// In tr, this message translates to:
  /// **'/ 5'**
  String get unitOutOfFive;

  /// No description provided for @semanticValue.
  ///
  /// In tr, this message translates to:
  /// **'{label}: {value}'**
  String semanticValue(String label, String value);

  /// No description provided for @errorGeneric.
  ///
  /// In tr, this message translates to:
  /// **'Bir sorun oluştu. Lütfen tekrar deneyin.'**
  String get errorGeneric;

  /// No description provided for @errorLoadTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yüklenemedi'**
  String get errorLoadTitle;

  /// No description provided for @errorNetwork.
  ///
  /// In tr, this message translates to:
  /// **'Sunucuya ulaşılamıyor. Bağlantınızı kontrol edip tekrar deneyin.'**
  String get errorNetwork;

  /// No description provided for @errorServer.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu bu isteği tamamlayamadı. Lütfen tekrar deneyin.'**
  String get errorServer;

  /// No description provided for @errorSessionExpired.
  ///
  /// In tr, this message translates to:
  /// **'Oturumunuzun süresi doldu. Lütfen yeniden giriş yapın.'**
  String get errorSessionExpired;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi veya şifre hatalı.'**
  String get errorInvalidCredentials;

  /// No description provided for @errorEmailExists.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta adresiyle kayıtlı bir hesap zaten var.'**
  String get errorEmailExists;

  /// No description provided for @errorInvalidInput.
  ///
  /// In tr, this message translates to:
  /// **'Girilen bilgilerden bazıları geçersiz. Lütfen kontrol edin.'**
  String get errorInvalidInput;

  /// No description provided for @errorCycleDuplicateStart.
  ///
  /// In tr, this message translates to:
  /// **'Bu başlangıç tarihine sahip bir döngü zaten kayıtlı.'**
  String get errorCycleDuplicateStart;

  /// No description provided for @errorEndBeforeStart.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş tarihi başlangıç tarihinden önce olamaz.'**
  String get errorEndBeforeStart;

  /// No description provided for @errorDailyLogExists.
  ///
  /// In tr, this message translates to:
  /// **'Bu tarih için zaten bir günlük kayıt var.'**
  String get errorDailyLogExists;

  /// No description provided for @errorDailyLogNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu günlük kayıt artık mevcut değil.'**
  String get errorDailyLogNotFound;

  /// No description provided for @errorCycleNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu döngü artık mevcut değil.'**
  String get errorCycleNotFound;

  /// No description provided for @errorNotFound.
  ///
  /// In tr, this message translates to:
  /// **'İstenen kayıt bulunamadı.'**
  String get errorNotFound;

  /// No description provided for @navToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün'**
  String get navToday;

  /// No description provided for @navJournal.
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get navJournal;

  /// No description provided for @navInsights.
  ///
  /// In tr, this message translates to:
  /// **'Analizler'**
  String get navInsights;

  /// No description provided for @fieldEmail.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get fieldEmail;

  /// No description provided for @fieldPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get fieldPassword;

  /// No description provided for @fieldFirstName.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get fieldFirstName;

  /// No description provided for @fieldLastName.
  ///
  /// In tr, this message translates to:
  /// **'Soyad'**
  String get fieldLastName;

  /// No description provided for @fieldDateOfBirth.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi'**
  String get fieldDateOfBirth;

  /// No description provided for @passwordShow.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi göster'**
  String get passwordShow;

  /// No description provided for @passwordHide.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi gizle'**
  String get passwordHide;

  /// No description provided for @validationEmailRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresinizi girin'**
  String get validationEmailRequired;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifrenizi girin'**
  String get validationPasswordRequired;

  /// No description provided for @validationNewPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bir şifre belirleyin'**
  String get validationNewPasswordRequired;

  /// No description provided for @validationFirstNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Adınızı girin'**
  String get validationFirstNameRequired;

  /// No description provided for @validationLastNameRequired.
  ///
  /// In tr, this message translates to:
  /// **'Soyadınızı girin'**
  String get validationLastNameRequired;

  /// No description provided for @validationDateOfBirthRequired.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihinizi seçin'**
  String get validationDateOfBirthRequired;

  /// No description provided for @loginTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar hoş geldiniz'**
  String get loginTitle;

  /// No description provided for @loginLede.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlarınıza kaldığınız yerden devam etmek için giriş yapın.'**
  String get loginLede;

  /// No description provided for @loginSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yap'**
  String get loginSubmit;

  /// No description provided for @loginFailed.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapılamadı'**
  String get loginFailed;

  /// No description provided for @loginNewPrompt.
  ///
  /// In tr, this message translates to:
  /// **'CycleInsight\'ta yeni misiniz?'**
  String get loginNewPrompt;

  /// No description provided for @loginCreateAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap oluşturun'**
  String get loginCreateAccount;

  /// No description provided for @registerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabınızı oluşturun'**
  String get registerTitle;

  /// No description provided for @registerLede.
  ///
  /// In tr, this message translates to:
  /// **'Döngü kayıtlarınız yalnızca kendi hesabınıza bağlı kalır.'**
  String get registerLede;

  /// No description provided for @registerSectionAbout.
  ///
  /// In tr, this message translates to:
  /// **'Hakkınızda'**
  String get registerSectionAbout;

  /// No description provided for @registerSectionAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get registerSectionAccount;

  /// No description provided for @registerDobHelp.
  ///
  /// In tr, this message translates to:
  /// **'Döngü düzenliliğini yaşınıza göre değerlendirmek için kullanılır.'**
  String get registerDobHelp;

  /// No description provided for @registerDobNotSet.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi, seçilmedi'**
  String get registerDobNotSet;

  /// No description provided for @registerDobSemantic.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi, {date}'**
  String registerDobSemantic(String date);

  /// No description provided for @registerSubmit.
  ///
  /// In tr, this message translates to:
  /// **'Hesap oluştur'**
  String get registerSubmit;

  /// No description provided for @registerFailed.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt tamamlanamadı'**
  String get registerFailed;

  /// No description provided for @registerHaveAccount.
  ///
  /// In tr, this message translates to:
  /// **'Zaten hesabınız var mı?'**
  String get registerHaveAccount;

  /// No description provided for @registerSignIn.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapın'**
  String get registerSignIn;

  /// No description provided for @profileAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get profileAccount;

  /// No description provided for @profileBorn.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi: {date}'**
  String profileBorn(String date);

  /// No description provided for @profileYourRecords.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlarınız'**
  String get profileYourRecords;

  /// No description provided for @profileCycleHistory.
  ///
  /// In tr, this message translates to:
  /// **'Döngü geçmişi'**
  String get profileCycleHistory;

  /// No description provided for @profileCycleHistorySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı adet dönemlerini görüntüleyin ve yönetin'**
  String get profileCycleHistorySubtitle;

  /// No description provided for @profileLogHistory.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt geçmişi'**
  String get profileLogHistory;

  /// No description provided for @profileLogHistorySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Önceki kayıtlarınızı inceleyin'**
  String get profileLogHistorySubtitle;

  /// No description provided for @profileLearn.
  ///
  /// In tr, this message translates to:
  /// **'Döngünüzü tanıyın'**
  String get profileLearn;

  /// No description provided for @profileLearnSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Dört faz, açıklamalarıyla'**
  String get profileLearnSubtitle;

  /// No description provided for @profileSignOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yap'**
  String get profileSignOut;

  /// No description provided for @phaseMenstrual.
  ///
  /// In tr, this message translates to:
  /// **'Menstrüel'**
  String get phaseMenstrual;

  /// No description provided for @phaseFollicular.
  ///
  /// In tr, this message translates to:
  /// **'Foliküler'**
  String get phaseFollicular;

  /// No description provided for @phaseOvulatory.
  ///
  /// In tr, this message translates to:
  /// **'Ovülasyon'**
  String get phaseOvulatory;

  /// No description provided for @phaseLuteal.
  ///
  /// In tr, this message translates to:
  /// **'Luteal'**
  String get phaseLuteal;

  /// No description provided for @phaseMenstrualName.
  ///
  /// In tr, this message translates to:
  /// **'Menstrüel faz'**
  String get phaseMenstrualName;

  /// No description provided for @phaseFollicularName.
  ///
  /// In tr, this message translates to:
  /// **'Foliküler faz'**
  String get phaseFollicularName;

  /// No description provided for @phaseOvulatoryName.
  ///
  /// In tr, this message translates to:
  /// **'Ovülasyon fazı'**
  String get phaseOvulatoryName;

  /// No description provided for @phaseLutealName.
  ///
  /// In tr, this message translates to:
  /// **'Luteal faz'**
  String get phaseLutealName;

  /// No description provided for @phaseMenstrualShort.
  ///
  /// In tr, this message translates to:
  /// **'Mens.'**
  String get phaseMenstrualShort;

  /// No description provided for @phaseFollicularShort.
  ///
  /// In tr, this message translates to:
  /// **'Fol.'**
  String get phaseFollicularShort;

  /// No description provided for @phaseOvulatoryShort.
  ///
  /// In tr, this message translates to:
  /// **'Ovül.'**
  String get phaseOvulatoryShort;

  /// No description provided for @phaseLutealShort.
  ///
  /// In tr, this message translates to:
  /// **'Lut.'**
  String get phaseLutealShort;

  /// No description provided for @metricBleeding.
  ///
  /// In tr, this message translates to:
  /// **'Kanama'**
  String get metricBleeding;

  /// No description provided for @metricMood.
  ///
  /// In tr, this message translates to:
  /// **'Ruh hali'**
  String get metricMood;

  /// No description provided for @metricPain.
  ///
  /// In tr, this message translates to:
  /// **'Ağrı'**
  String get metricPain;

  /// No description provided for @metricSleep.
  ///
  /// In tr, this message translates to:
  /// **'Uyku'**
  String get metricSleep;

  /// No description provided for @metricSleepQuality.
  ///
  /// In tr, this message translates to:
  /// **'Uyku kalitesi'**
  String get metricSleepQuality;

  /// No description provided for @metricStress.
  ///
  /// In tr, this message translates to:
  /// **'Stres'**
  String get metricStress;

  /// No description provided for @bleedingLevel0.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get bleedingLevel0;

  /// No description provided for @bleedingLevel1.
  ///
  /// In tr, this message translates to:
  /// **'Çok hafif'**
  String get bleedingLevel1;

  /// No description provided for @bleedingLevel2.
  ///
  /// In tr, this message translates to:
  /// **'Hafif'**
  String get bleedingLevel2;

  /// No description provided for @bleedingLevel3.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get bleedingLevel3;

  /// No description provided for @bleedingLevel4.
  ///
  /// In tr, this message translates to:
  /// **'Şiddetli'**
  String get bleedingLevel4;

  /// No description provided for @bleedingLevel5.
  ///
  /// In tr, this message translates to:
  /// **'Çok şiddetli'**
  String get bleedingLevel5;

  /// No description provided for @moodLevel1.
  ///
  /// In tr, this message translates to:
  /// **'Çok kötü'**
  String get moodLevel1;

  /// No description provided for @moodLevel2.
  ///
  /// In tr, this message translates to:
  /// **'Kötü'**
  String get moodLevel2;

  /// No description provided for @moodLevel3.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get moodLevel3;

  /// No description provided for @moodLevel4.
  ///
  /// In tr, this message translates to:
  /// **'İyi'**
  String get moodLevel4;

  /// No description provided for @moodLevel5.
  ///
  /// In tr, this message translates to:
  /// **'Çok iyi'**
  String get moodLevel5;

  /// No description provided for @painLevel0.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get painLevel0;

  /// No description provided for @painLevel1.
  ///
  /// In tr, this message translates to:
  /// **'Çok düşük'**
  String get painLevel1;

  /// No description provided for @painLevel2.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get painLevel2;

  /// No description provided for @painLevel3.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get painLevel3;

  /// No description provided for @painLevel4.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get painLevel4;

  /// No description provided for @painLevel5.
  ///
  /// In tr, this message translates to:
  /// **'Çok yüksek'**
  String get painLevel5;

  /// No description provided for @sleepLevel0.
  ///
  /// In tr, this message translates to:
  /// **'Uyumadım'**
  String get sleepLevel0;

  /// No description provided for @sleepLevel1.
  ///
  /// In tr, this message translates to:
  /// **'Çok kötü'**
  String get sleepLevel1;

  /// No description provided for @sleepLevel2.
  ///
  /// In tr, this message translates to:
  /// **'Kötü'**
  String get sleepLevel2;

  /// No description provided for @sleepLevel3.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get sleepLevel3;

  /// No description provided for @sleepLevel4.
  ///
  /// In tr, this message translates to:
  /// **'İyi'**
  String get sleepLevel4;

  /// No description provided for @sleepLevel5.
  ///
  /// In tr, this message translates to:
  /// **'Çok iyi'**
  String get sleepLevel5;

  /// No description provided for @stressLevel0.
  ///
  /// In tr, this message translates to:
  /// **'Yok'**
  String get stressLevel0;

  /// No description provided for @stressLevel1.
  ///
  /// In tr, this message translates to:
  /// **'Çok düşük'**
  String get stressLevel1;

  /// No description provided for @stressLevel2.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get stressLevel2;

  /// No description provided for @stressLevel3.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get stressLevel3;

  /// No description provided for @stressLevel4.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get stressLevel4;

  /// No description provided for @stressLevel5.
  ///
  /// In tr, this message translates to:
  /// **'Çok yüksek'**
  String get stressLevel5;

  /// No description provided for @greetingMorning.
  ///
  /// In tr, this message translates to:
  /// **'Günaydın'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In tr, this message translates to:
  /// **'İyi günler'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In tr, this message translates to:
  /// **'İyi akşamlar'**
  String get greetingEvening;

  /// No description provided for @greetingWithName.
  ///
  /// In tr, this message translates to:
  /// **'{greeting}, {name}'**
  String greetingWithName(String greeting, String name);

  /// No description provided for @homeReadingCycle.
  ///
  /// In tr, this message translates to:
  /// **'Döngünüz hazırlanıyor…'**
  String get homeReadingCycle;

  /// No description provided for @homeOverviewUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Döngü özeti yüklenemedi'**
  String get homeOverviewUnavailable;

  /// No description provided for @homeCycleDay.
  ///
  /// In tr, this message translates to:
  /// **'Döngü günü'**
  String get homeCycleDay;

  /// No description provided for @homeOfAboutDays.
  ///
  /// In tr, this message translates to:
  /// **'~{days} günlük döngü'**
  String homeOfAboutDays(int days);

  /// No description provided for @homeNoCycleYet.
  ///
  /// In tr, this message translates to:
  /// **'Henüz döngü yok'**
  String get homeNoCycleYet;

  /// No description provided for @homePhaseNotEstimated.
  ///
  /// In tr, this message translates to:
  /// **'Faz tahmin edilmedi'**
  String get homePhaseNotEstimated;

  /// No description provided for @homeDialNoCycle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıtlı döngü yok'**
  String get homeDialNoCycle;

  /// No description provided for @homeDialDay.
  ///
  /// In tr, this message translates to:
  /// **'Döngünün {day}. günü'**
  String homeDialDay(int day);

  /// No description provided for @homeDialOfAbout.
  ///
  /// In tr, this message translates to:
  /// **'yaklaşık {days} günlük döngü'**
  String homeDialOfAbout(int days);

  /// No description provided for @homeAddFirstPeriodPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün döngünüzdeki yerini görmek için son adet döneminizin ilk gününü kaydedin.'**
  String get homeAddFirstPeriodPrompt;

  /// No description provided for @homeAddPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Adet dönemi ekle'**
  String get homeAddPeriod;

  /// No description provided for @homeNeedSecondPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Döngü uzunluğunuzu ve fazlarınızı tahmin etmek için bir adet başlangıç tarihi daha ekleyin.'**
  String get homeNeedSecondPeriod;

  /// No description provided for @homePastEstimate.
  ///
  /// In tr, this message translates to:
  /// **'{day}. gün, tahmini döngü uzunluğunuzu {over, plural, =1{1 gün} other{{over} gün}} geçti. Adetiniz başladıysa kaydedin.'**
  String homePastEstimate(int day, int over);

  /// No description provided for @homeAddEndDate.
  ///
  /// In tr, this message translates to:
  /// **'Kadranda menstrüel fazı göstermek için son adet döneminize bitiş tarihi ekleyin.'**
  String get homeAddEndDate;

  /// No description provided for @homeRecordPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Adet dönemi kaydet'**
  String get homeRecordPeriod;

  /// No description provided for @homeOpenCycleHistory.
  ///
  /// In tr, this message translates to:
  /// **'Döngü geçmişini aç'**
  String get homeOpenCycleHistory;

  /// No description provided for @homeComingUp.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşanlar'**
  String get homeComingUp;

  /// No description provided for @homeComingUpSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngülerinize dayalı tahminler'**
  String get homeComingUpSubtitle;

  /// No description provided for @homeNextPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki adet'**
  String get homeNextPeriod;

  /// No description provided for @homeOvulation.
  ///
  /// In tr, this message translates to:
  /// **'Ovülasyon'**
  String get homeOvulation;

  /// No description provided for @homeOvulationWindow.
  ///
  /// In tr, this message translates to:
  /// **'Pencere: döngünün {start}–{end}. günleri'**
  String homeOvulationWindow(int start, int end);

  /// No description provided for @homeSeeInsights.
  ///
  /// In tr, this message translates to:
  /// **'Analizlere git'**
  String get homeSeeInsights;

  /// No description provided for @homeTodayCheckIn.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün kaydı'**
  String get homeTodayCheckIn;

  /// No description provided for @homeCheckInPrompt.
  ///
  /// In tr, this message translates to:
  /// **'Bugün nasılsınız?'**
  String get homeCheckInPrompt;

  /// No description provided for @homeCheckInPromptBody.
  ///
  /// In tr, this message translates to:
  /// **'Kanama, ruh hali, ağrı, uyku ve stres; bir dakikadan kısa sürer. Her kayıt, Analizler\'deki örüntülere katkı sağlar.'**
  String get homeCheckInPromptBody;

  /// No description provided for @homeCheckInButton.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt ekle'**
  String get homeCheckInButton;

  /// No description provided for @homeCheckInRecorded.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedildi'**
  String get homeCheckInRecorded;

  /// No description provided for @homeCheckInLoadError.
  ///
  /// In tr, this message translates to:
  /// **'Bugünün kaydı yüklenemedi.'**
  String get homeCheckInLoadError;

  /// No description provided for @homeReadAboutPhase.
  ///
  /// In tr, this message translates to:
  /// **'Bu faz hakkında okuyun'**
  String get homeReadAboutPhase;

  /// No description provided for @homeLearnFallback.
  ///
  /// In tr, this message translates to:
  /// **'Her fazda neler olduğu ve CycleInsight\'ın fazları nasıl tahmin ettiği.'**
  String get homeLearnFallback;

  /// No description provided for @confidenceHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get confidenceHigh;

  /// No description provided for @confidenceMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get confidenceMedium;

  /// No description provided for @confidenceLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get confidenceLow;

  /// No description provided for @confidenceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Güven düzeyi: {tier}'**
  String confidenceLabel(String tier);

  /// No description provided for @logNewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kayıt'**
  String get logNewTitle;

  /// No description provided for @logEditTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kaydı düzenle'**
  String get logEditTitle;

  /// No description provided for @logSectionBody.
  ///
  /// In tr, this message translates to:
  /// **'Beden'**
  String get logSectionBody;

  /// No description provided for @logSectionMind.
  ///
  /// In tr, this message translates to:
  /// **'Zihin ve dinlenme'**
  String get logSectionMind;

  /// No description provided for @logSymptoms.
  ///
  /// In tr, this message translates to:
  /// **'Semptomlar'**
  String get logSymptoms;

  /// No description provided for @logSymptomsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Fark ettiklerinizi seçin'**
  String get logSymptomsSubtitle;

  /// No description provided for @logSymptomsSelected.
  ///
  /// In tr, this message translates to:
  /// **'{count} seçildi'**
  String logSymptomsSelected(int count);

  /// No description provided for @logNotes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get logNotes;

  /// No description provided for @logNotesHint.
  ///
  /// In tr, this message translates to:
  /// **'Bugünle ilgili eklemek istedikleriniz (isteğe bağlı)'**
  String get logNotesHint;

  /// No description provided for @logSave.
  ///
  /// In tr, this message translates to:
  /// **'Kaydı kaydet'**
  String get logSave;

  /// No description provided for @logSymptomsLoading.
  ///
  /// In tr, this message translates to:
  /// **'Semptomlar yükleniyor…'**
  String get logSymptomsLoading;

  /// No description provided for @logSymptomsError.
  ///
  /// In tr, this message translates to:
  /// **'Semptomlar yüklenemedi.'**
  String get logSymptomsError;

  /// No description provided for @logNoSymptomTypes.
  ///
  /// In tr, this message translates to:
  /// **'Kullanılabilir semptom türü yok.'**
  String get logNoSymptomTypes;

  /// No description provided for @logSavedButSymptomsFailed.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt kaydedildi ancak bazı semptomlar kaydedilemedi. Lütfen tekrar deneyin.'**
  String get logSavedButSymptomsFailed;

  /// No description provided for @logCreateFailed.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt oluşturulamadı'**
  String get logCreateFailed;

  /// No description provided for @logUpdateFailed.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt güncellenemedi'**
  String get logUpdateFailed;

  /// No description provided for @logLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıtlar yüklenemedi'**
  String get logLoadFailed;

  /// No description provided for @logDeleteFailed.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt silinemedi'**
  String get logDeleteFailed;

  /// No description provided for @journalEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt'**
  String get journalEyebrow;

  /// No description provided for @journalTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günlük'**
  String get journalTitle;

  /// No description provided for @journalCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} kayıt'**
  String journalCount(int count);

  /// No description provided for @journalNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni'**
  String get journalNew;

  /// No description provided for @journalUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Günlük yüklenemedi'**
  String get journalUnavailable;

  /// No description provided for @journalEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlk kaydınızı oluşturun'**
  String get journalEmptyTitle;

  /// No description provided for @journalEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Bugün nasıl hissettiğinizi kaydedin: kanama, ruh hali, ağrı, uyku, stres ve semptomlar. Kayıtlar burada aylara göre listelenir.'**
  String get journalEmptyBody;

  /// No description provided for @journalEmptyAction.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt ekle'**
  String get journalEmptyAction;

  /// No description provided for @journalBleeding.
  ///
  /// In tr, this message translates to:
  /// **'Kanama · {level}'**
  String journalBleeding(String level);

  /// No description provided for @journalDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Günlük kayıt silinsin mi?'**
  String get journalDeleteTitle;

  /// No description provided for @journalDeleteBody.
  ///
  /// In tr, this message translates to:
  /// **'{date} tarihli kayıt ve semptomları silinecek.'**
  String journalDeleteBody(String date);

  /// No description provided for @journalDeleted.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt silindi'**
  String get journalDeleted;

  /// No description provided for @cycleHistoryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Döngü geçmişi'**
  String get cycleHistoryTitle;

  /// No description provided for @cycleAddPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Adet ekle'**
  String get cycleAddPeriod;

  /// No description provided for @cycleUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Döngü geçmişi yüklenemedi'**
  String get cycleUnavailable;

  /// No description provided for @cycleLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Döngüler yüklenemedi'**
  String get cycleLoadFailed;

  /// No description provided for @cycleEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'İlk adet döneminizi ekleyin'**
  String get cycleEmptyTitle;

  /// No description provided for @cycleEmptyBody.
  ///
  /// In tr, this message translates to:
  /// **'Adet başlangıç tarihleri döngünüzdeki yerinizi belirler. İki veya daha fazla tarih, CycleInsight\'ın döngü uzunluğunuzu tahmin etmesini sağlar.'**
  String get cycleEmptyBody;

  /// No description provided for @cycleEmptyAction.
  ///
  /// In tr, this message translates to:
  /// **'Adet dönemi ekle'**
  String get cycleEmptyAction;

  /// No description provided for @cycleRecordedIntro.
  ///
  /// In tr, this message translates to:
  /// **'{count} adet dönemi kayıtlı. Tarihlerini düzeltmek için birine dokunun.'**
  String cycleRecordedIntro(int count);

  /// No description provided for @cycleLatest.
  ///
  /// In tr, this message translates to:
  /// **'En son'**
  String get cycleLatest;

  /// No description provided for @cyclePeriodEndMissing.
  ///
  /// In tr, this message translates to:
  /// **'Adet bitişi kaydedilmedi'**
  String get cyclePeriodEndMissing;

  /// No description provided for @cyclePeriodDays.
  ///
  /// In tr, this message translates to:
  /// **'Adet · {count} gün'**
  String cyclePeriodDays(int count);

  /// No description provided for @cycleLengthDays.
  ///
  /// In tr, this message translates to:
  /// **'{days} günlük döngü'**
  String cycleLengthDays(int days);

  /// No description provided for @cycleDeleteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Döngü silinsin mi?'**
  String get cycleDeleteTitle;

  /// No description provided for @cycleDeleteBody.
  ///
  /// In tr, this message translates to:
  /// **'{date} tarihinde başlayan döngü, geçmişinizden ve analizlerinizden kaldırılacak.'**
  String cycleDeleteBody(String date);

  /// No description provided for @cycleDeleteFailed.
  ///
  /// In tr, this message translates to:
  /// **'Döngü silinemedi'**
  String get cycleDeleteFailed;

  /// No description provided for @cycleNewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni adet dönemi'**
  String get cycleNewTitle;

  /// No description provided for @cycleEditTitle.
  ///
  /// In tr, this message translates to:
  /// **'Adet dönemini düzenle'**
  String get cycleEditTitle;

  /// No description provided for @cycleFormIntro.
  ///
  /// In tr, this message translates to:
  /// **'Döngü, adetinizin ilk günü başlar. Bildiğiniz tarihleri kaydedin; bitiş tarihini daha sonra da ekleyebilirsiniz.'**
  String get cycleFormIntro;

  /// No description provided for @cycleStarted.
  ///
  /// In tr, this message translates to:
  /// **'Adet başlangıcı'**
  String get cycleStarted;

  /// No description provided for @cycleEnded.
  ///
  /// In tr, this message translates to:
  /// **'Adet bitişi · isteğe bağlı'**
  String get cycleEnded;

  /// No description provided for @cycleNotRecorded.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilmedi'**
  String get cycleNotRecorded;

  /// No description provided for @cycleEndHelp.
  ///
  /// In tr, this message translates to:
  /// **'Kadranda menstrüel fazı göstermek için kullanılır'**
  String get cycleEndHelp;

  /// No description provided for @cycleBleedingDays.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün kanama'**
  String cycleBleedingDays(int count);

  /// No description provided for @cycleClearEnd.
  ///
  /// In tr, this message translates to:
  /// **'Bitiş tarihini temizle (adet devam ediyor)'**
  String get cycleClearEnd;

  /// No description provided for @cycleSave.
  ///
  /// In tr, this message translates to:
  /// **'Adet dönemini kaydet'**
  String get cycleSave;

  /// No description provided for @cycleCreateFailed.
  ///
  /// In tr, this message translates to:
  /// **'Döngü oluşturulamadı'**
  String get cycleCreateFailed;

  /// No description provided for @cycleUpdateFailed.
  ///
  /// In tr, this message translates to:
  /// **'Döngü güncellenemedi'**
  String get cycleUpdateFailed;

  /// No description provided for @learnEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'Öğren'**
  String get learnEyebrow;

  /// No description provided for @learnTitle.
  ///
  /// In tr, this message translates to:
  /// **'Döngünüz, dört fazda'**
  String get learnTitle;

  /// No description provided for @learnExampleCycle.
  ///
  /// In tr, this message translates to:
  /// **'Örnek bir 28 günlük döngü'**
  String get learnExampleCycle;

  /// No description provided for @learnYouAre.
  ///
  /// In tr, this message translates to:
  /// **'Siz: {phase}'**
  String learnYouAre(String phase);

  /// No description provided for @learnNow.
  ///
  /// In tr, this message translates to:
  /// **'Şu an'**
  String get learnNow;

  /// No description provided for @learnDayOne.
  ///
  /// In tr, this message translates to:
  /// **'1. gün'**
  String get learnDayOne;

  /// No description provided for @learnTapHint.
  ///
  /// In tr, this message translates to:
  /// **'Sizin döngünüz daha kısa veya daha uzun olabilir. Okumak için bir faza dokunun.'**
  String get learnTapHint;

  /// No description provided for @learnPhaseOf.
  ///
  /// In tr, this message translates to:
  /// **'Faz {number} / 4'**
  String learnPhaseOf(int number);

  /// No description provided for @learnWhen.
  ///
  /// In tr, this message translates to:
  /// **'Ne zaman'**
  String get learnWhen;

  /// No description provided for @learnWhatIsHappening.
  ///
  /// In tr, this message translates to:
  /// **'Neler oluyor'**
  String get learnWhatIsHappening;

  /// No description provided for @learnWhatYouMightNotice.
  ///
  /// In tr, this message translates to:
  /// **'Neler fark edebilirsiniz'**
  String get learnWhatYouMightNotice;

  /// No description provided for @learnInApp.
  ///
  /// In tr, this message translates to:
  /// **'CycleInsight\'ta'**
  String get learnInApp;

  /// No description provided for @learnPrevious.
  ///
  /// In tr, this message translates to:
  /// **'Önceki'**
  String get learnPrevious;

  /// No description provided for @learnNext.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki'**
  String get learnNext;

  /// No description provided for @learnSources.
  ///
  /// In tr, this message translates to:
  /// **'Kaynaklar'**
  String get learnSources;

  /// No description provided for @insightsEyebrow.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel rapor'**
  String get insightsEyebrow;

  /// No description provided for @insightsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Analizler'**
  String get insightsTitle;

  /// No description provided for @insightsCycles.
  ///
  /// In tr, this message translates to:
  /// **'{count} döngü'**
  String insightsCycles(int count);

  /// No description provided for @insightsLogs.
  ///
  /// In tr, this message translates to:
  /// **'{count} günlük kayıt'**
  String insightsLogs(int count);

  /// No description provided for @insightsBasedOn.
  ///
  /// In tr, this message translates to:
  /// **'Kaynak: {parts}'**
  String insightsBasedOn(String parts);

  /// No description provided for @insightsAnd.
  ///
  /// In tr, this message translates to:
  /// **' ve '**
  String get insightsAnd;

  /// No description provided for @insightsBuilding.
  ///
  /// In tr, this message translates to:
  /// **'Raporunuz hazırlanıyor…'**
  String get insightsBuilding;

  /// No description provided for @insightsUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Analizler yüklenemedi'**
  String get insightsUnavailable;

  /// No description provided for @insightsLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Analiz yüklenemedi'**
  String get insightsLoadFailed;

  /// No description provided for @insightsDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'Bu özetler kendi kayıtlarınızdaki örüntüleri açıklar. Fazlar ve tarihler tahmindir; bağlantılar neden-sonuç değil, ilişki gösterir. CycleInsight tıbbi teşhis koymaz.'**
  String get insightsDisclaimer;

  /// No description provided for @digestTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlarınız ne gösteriyor'**
  String get digestTitle;

  /// No description provided for @digestEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Birkaç döngü ve günlük kayıt girdiğinizde analizler burada görünür. Kayıt tutmaya devam edin; örüntülerin oluşması biraz zaman alır.'**
  String get digestEmpty;

  /// No description provided for @insightCyclePatternTitle.
  ///
  /// In tr, this message translates to:
  /// **'Döngü örüntüsü'**
  String get insightCyclePatternTitle;

  /// No description provided for @insightCycleRegular.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngü uzunluklarınız görece tutarlı görünüyor.'**
  String get insightCycleRegular;

  /// No description provided for @insightCycleIrregular.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngü uzunluklarınızda bir miktar değişkenlik var.'**
  String get insightCycleIrregular;

  /// No description provided for @insightCycleTrendTitle.
  ///
  /// In tr, this message translates to:
  /// **'Döngü uzunluğu eğilimi'**
  String get insightCycleTrendTitle;

  /// No description provided for @insightCycleTrendUp.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngü uzunluklarınız zaman içinde artış eğilimi gösteriyor.'**
  String get insightCycleTrendUp;

  /// No description provided for @insightCycleTrendDown.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngü uzunluklarınız zaman içinde azalma eğilimi gösteriyor.'**
  String get insightCycleTrendDown;

  /// No description provided for @insightPredictionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Döngü tahmini'**
  String get insightPredictionTitle;

  /// No description provided for @insightPredictionLow.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini döngü uzunluğunuz {days} gün; ancak bu tahminin daha güvenilir olması için daha fazla döngü verisi gerekiyor.'**
  String insightPredictionLow(int days);

  /// No description provided for @insightPredictionBased.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngülerinize göre tahmini döngü uzunluğunuz {days} gün.'**
  String insightPredictionBased(int days);

  /// No description provided for @insightBleedingIntensityTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kanama yoğunluğu'**
  String get insightBleedingIntensityTitle;

  /// No description provided for @insightBleedingHighAverage.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı kanama düzeyleriniz ortalamada görece yüksek.'**
  String get insightBleedingHighAverage;

  /// No description provided for @insightPeakBleedingTitle.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek kanama düzeyi'**
  String get insightPeakBleedingTitle;

  /// No description provided for @insightPeakBleeding.
  ///
  /// In tr, this message translates to:
  /// **'En az bir kayıtlı günde yüksek bir kanama düzeyi kaydettiniz.'**
  String get insightPeakBleeding;

  /// No description provided for @insightSymptomTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tekrarlayan semptomlar'**
  String get insightSymptomTitle;

  /// No description provided for @insightSymptomWithPhase.
  ///
  /// In tr, this message translates to:
  /// **'{symptom} {count} kez kaydedildi; en sık görüldüğü faz: {phase}.'**
  String insightSymptomWithPhase(String symptom, int count, String phase);

  /// No description provided for @insightSymptomNoPhase.
  ///
  /// In tr, this message translates to:
  /// **'{symptom} {count} kez kaydedildi.'**
  String insightSymptomNoPhase(String symptom, int count);

  /// No description provided for @insightWellbeingTitle.
  ///
  /// In tr, this message translates to:
  /// **'{metric} eğilimi'**
  String insightWellbeingTitle(String metric);

  /// No description provided for @insightWellbeingUp.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı {metric} değerleriniz artış eğilimi gösteriyor.'**
  String insightWellbeingUp(String metric);

  /// No description provided for @insightWellbeingDown.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı {metric} değerleriniz azalma eğilimi gösteriyor.'**
  String insightWellbeingDown(String metric);

  /// No description provided for @insightMetricMood.
  ///
  /// In tr, this message translates to:
  /// **'ruh hali'**
  String get insightMetricMood;

  /// No description provided for @insightMetricPain.
  ///
  /// In tr, this message translates to:
  /// **'ağrı'**
  String get insightMetricPain;

  /// No description provided for @insightMetricSleep.
  ///
  /// In tr, this message translates to:
  /// **'uyku'**
  String get insightMetricSleep;

  /// No description provided for @insightMetricStress.
  ///
  /// In tr, this message translates to:
  /// **'stres'**
  String get insightMetricStress;

  /// No description provided for @insightSleepMoodPositive.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı uyku kaliteniz, ruh halinizle pozitif yönde ilişkili görünüyor.'**
  String get insightSleepMoodPositive;

  /// No description provided for @insightSleepMoodNegative.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı uyku kaliteniz, ruh halinizle negatif yönde ilişkili görünüyor.'**
  String get insightSleepMoodNegative;

  /// No description provided for @insightStressPainPositive.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı stres düzeyleriniz, ağrı düzeylerinizle pozitif yönde ilişkili görünüyor.'**
  String get insightStressPainPositive;

  /// No description provided for @insightStressPainNegative.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı stres düzeyleriniz, ağrı düzeylerinizle negatif yönde ilişkili görünüyor.'**
  String get insightStressPainNegative;

  /// No description provided for @sectionCycleLength.
  ///
  /// In tr, this message translates to:
  /// **'Döngü uzunluğu'**
  String get sectionCycleLength;

  /// No description provided for @sectionCycleLengthCaption.
  ///
  /// In tr, this message translates to:
  /// **'Bir adet başlangıcından bir sonrakine kadar geçen gün sayısı'**
  String get sectionCycleLengthCaption;

  /// No description provided for @sectionCycleLengthEmpty.
  ///
  /// In tr, this message translates to:
  /// **'En az iki adet başlangıç tarihi kaydettiğinizde döngü uzunluğu burada görünür.'**
  String get sectionCycleLengthEmpty;

  /// No description provided for @statAverage.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama'**
  String get statAverage;

  /// No description provided for @statVariability.
  ///
  /// In tr, this message translates to:
  /// **'Değişkenlik'**
  String get statVariability;

  /// No description provided for @statStandardDeviation.
  ///
  /// In tr, this message translates to:
  /// **'Standart sapma'**
  String get statStandardDeviation;

  /// No description provided for @statRange.
  ///
  /// In tr, this message translates to:
  /// **'Aralık'**
  String get statRange;

  /// No description provided for @statRangeDays.
  ///
  /// In tr, this message translates to:
  /// **'{min}–{max} gün'**
  String statRangeDays(int min, int max);

  /// No description provided for @chartMedian.
  ///
  /// In tr, this message translates to:
  /// **'Medyan {value} gün'**
  String chartMedian(String value);

  /// No description provided for @chartCycleStarting.
  ///
  /// In tr, this message translates to:
  /// **'{date} tarihinde başlayan döngü'**
  String chartCycleStarting(String date);

  /// No description provided for @chartCycleNumber.
  ///
  /// In tr, this message translates to:
  /// **'Döngü {number} / {total}'**
  String chartCycleNumber(int number, int total);

  /// No description provided for @chartDaysPoint.
  ///
  /// In tr, this message translates to:
  /// **'{label}: {days} gün'**
  String chartDaysPoint(String label, int days);

  /// No description provided for @chartSemantic.
  ///
  /// In tr, this message translates to:
  /// **'Döngü uzunluğu grafiği. {summary}'**
  String chartSemantic(String summary);

  /// No description provided for @regularityLabel.
  ///
  /// In tr, this message translates to:
  /// **'Düzenlilik'**
  String get regularityLabel;

  /// No description provided for @regularityRegular.
  ///
  /// In tr, this message translates to:
  /// **'Düzenli'**
  String get regularityRegular;

  /// No description provided for @regularityIrregular.
  ///
  /// In tr, this message translates to:
  /// **'Düzensiz'**
  String get regularityIrregular;

  /// No description provided for @regularityNotAssessed.
  ///
  /// In tr, this message translates to:
  /// **'Henüz değerlendirilmedi'**
  String get regularityNotAssessed;

  /// No description provided for @regularityExplainRegular.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngü uzunluklarınız tutarlı bir aralıkta kalıyor.'**
  String get regularityExplainRegular;

  /// No description provided for @regularityExplainIrregular.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngü uzunluklarınız olağandan daha fazla değişkenlik gösteriyor.'**
  String get regularityExplainIrregular;

  /// No description provided for @regularityExplainNotAssessed.
  ///
  /// In tr, this message translates to:
  /// **'Düzenlilik, yaş grubunuz için henüz değerlendirilmiyor.'**
  String get regularityExplainNotAssessed;

  /// No description provided for @regularityExplainInsufficient.
  ///
  /// In tr, this message translates to:
  /// **'Düzenlilik, daha fazla döngü kaydedildiğinde değerlendirilir.'**
  String get regularityExplainInsufficient;

  /// No description provided for @lengthOverTime.
  ///
  /// In tr, this message translates to:
  /// **'Zaman içindeki uzunluk'**
  String get lengthOverTime;

  /// No description provided for @trendUp.
  ///
  /// In tr, this message translates to:
  /// **'Artıyor'**
  String get trendUp;

  /// No description provided for @trendDown.
  ///
  /// In tr, this message translates to:
  /// **'Azalıyor'**
  String get trendDown;

  /// No description provided for @trendNone.
  ///
  /// In tr, this message translates to:
  /// **'Belirgin eğilim yok'**
  String get trendNone;

  /// No description provided for @trendUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Yeterli veri yok'**
  String get trendUnavailable;

  /// No description provided for @trendNeedThree.
  ///
  /// In tr, this message translates to:
  /// **'En az üç döngü uzunluğu gerekir.'**
  String get trendNeedThree;

  /// No description provided for @trendNoneDetail.
  ///
  /// In tr, this message translates to:
  /// **'Döngüleriniz boyunca istatistiksel olarak belirgin bir değişim yok.'**
  String get trendNoneDetail;

  /// No description provided for @trendDetail.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngüleriniz boyunca tutarlı bir değişim var.'**
  String get trendDetail;

  /// No description provided for @sectionPredictions.
  ///
  /// In tr, this message translates to:
  /// **'Tahminler'**
  String get sectionPredictions;

  /// No description provided for @sectionPredictionsCaption.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı geçmişinizden yapılan tahminlerdir; kesinlik içermez'**
  String get sectionPredictionsCaption;

  /// No description provided for @predictionsEmptyNoCycle.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini tarihleri burada görmek için adet tarihlerinizi kaydedin.'**
  String get predictionsEmptyNoCycle;

  /// No description provided for @predictionsEmptyDay.
  ///
  /// In tr, this message translates to:
  /// **'Döngünüzün {day}. günündesiniz. Tahminler için en az iki adet başlangıç tarihi gerekir.'**
  String predictionsEmptyDay(int day);

  /// No description provided for @predictionsToday.
  ///
  /// In tr, this message translates to:
  /// **'Bugün döngünüzün {day}. günü.'**
  String predictionsToday(int day);

  /// No description provided for @predictionsCurrentPhase.
  ///
  /// In tr, this message translates to:
  /// **'Şu anki faz: {phase}.'**
  String predictionsCurrentPhase(String phase);

  /// No description provided for @predictionsNextPeriod.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki adet'**
  String get predictionsNextPeriod;

  /// No description provided for @predictionsOvulation.
  ///
  /// In tr, this message translates to:
  /// **'Ovülasyon'**
  String get predictionsOvulation;

  /// No description provided for @predictionsCycleDay.
  ///
  /// In tr, this message translates to:
  /// **'Döngünün {day}. günü'**
  String predictionsCycleDay(int day);

  /// No description provided for @predictionsWindow.
  ///
  /// In tr, this message translates to:
  /// **'pencere: {start}–{end}. günler'**
  String predictionsWindow(int start, int end);

  /// No description provided for @predictionsEstimatedLength.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini döngü uzunluğu'**
  String get predictionsEstimatedLength;

  /// No description provided for @predictionsMedianNote.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı döngülerinizin medyanı'**
  String get predictionsMedianNote;

  /// No description provided for @predictionsConfidenceBasis.
  ///
  /// In tr, this message translates to:
  /// **'Kaç döngü kaydettiğinize ve uzunluklarının ne kadar tutarlı olduğuna dayanır.'**
  String get predictionsConfidenceBasis;

  /// No description provided for @sectionWellbeing.
  ///
  /// In tr, this message translates to:
  /// **'İyi oluş'**
  String get sectionWellbeing;

  /// No description provided for @sectionWellbeingCaption.
  ///
  /// In tr, this message translates to:
  /// **'0–5 ölçeğinde kaydettiğiniz aralık ve ortalama'**
  String get sectionWellbeingCaption;

  /// No description provided for @wellbeingEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Ruh hali, uyku, ağrı ve stres özetleri ilk kayıtlarınızdan sonra görünür.'**
  String get wellbeingEmpty;

  /// No description provided for @wellbeingHigherBetter.
  ///
  /// In tr, this message translates to:
  /// **'yüksek olması daha iyi'**
  String get wellbeingHigherBetter;

  /// No description provided for @wellbeingHigherMore.
  ///
  /// In tr, this message translates to:
  /// **'yüksek değer daha fazlası'**
  String get wellbeingHigherMore;

  /// No description provided for @wellbeingAverageShort.
  ///
  /// In tr, this message translates to:
  /// **'ort.'**
  String get wellbeingAverageShort;

  /// No description provided for @wellbeingRange.
  ///
  /// In tr, this message translates to:
  /// **'Aralık {min}–{max}'**
  String wellbeingRange(String min, String max);

  /// No description provided for @wellbeingMedian.
  ///
  /// In tr, this message translates to:
  /// **'medyan {value}'**
  String wellbeingMedian(String value);

  /// No description provided for @wellbeingNoData.
  ///
  /// In tr, this message translates to:
  /// **'Henüz veri yok'**
  String get wellbeingNoData;

  /// No description provided for @wellbeingKeyRange.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilen en düşükten en yükseğe'**
  String get wellbeingKeyRange;

  /// No description provided for @wellbeingKeyAverage.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama'**
  String get wellbeingKeyAverage;

  /// No description provided for @wellbeingSemantic.
  ///
  /// In tr, this message translates to:
  /// **'{metric}: ortalama {average} / 5, aralık {min}–{max}. Eğilim: {trend}.'**
  String wellbeingSemantic(
    String metric,
    String average,
    String min,
    String max,
    String trend,
  );

  /// No description provided for @wellbeingSemanticNoData.
  ///
  /// In tr, this message translates to:
  /// **'{metric}: veri yok. Eğilim: {trend}.'**
  String wellbeingSemanticNoData(String metric, String trend);

  /// No description provided for @wellbeingByPhase.
  ///
  /// In tr, this message translates to:
  /// **'Faza göre'**
  String get wellbeingByPhase;

  /// No description provided for @wellbeingByPhaseCaption.
  ///
  /// In tr, this message translates to:
  /// **'Her tahmini faza denk gelen kayıtların ortalaması. Koyu hücreler daha yüksek değerleri gösterir.'**
  String get wellbeingByPhaseCaption;

  /// No description provided for @wellbeingCellNoData.
  ///
  /// In tr, this message translates to:
  /// **'veri yok'**
  String get wellbeingCellNoData;

  /// No description provided for @sectionSymptoms.
  ///
  /// In tr, this message translates to:
  /// **'Semptomlar'**
  String get sectionSymptoms;

  /// No description provided for @sectionSymptomsCaption.
  ///
  /// In tr, this message translates to:
  /// **'Her birinin ne sıklıkla ve hangi tahmini fazda kaydedildiği'**
  String get sectionSymptomsCaption;

  /// No description provided for @symptomsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz semptom kaydedilmedi. Ne sıklıkla ve hangi fazda görüldüklerini görmek için bir kayıtta semptom seçin.'**
  String get symptomsEmpty;

  /// No description provided for @symptomsNamesUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Semptom adları şu anda kullanılamıyor.'**
  String get symptomsNamesUnavailable;

  /// No description provided for @symptomsUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen semptom'**
  String get symptomsUnknown;

  /// No description provided for @symptomsMostly.
  ///
  /// In tr, this message translates to:
  /// **'En sık: {phase}'**
  String symptomsMostly(String phase);

  /// No description provided for @symptomsTimes.
  ///
  /// In tr, this message translates to:
  /// **'{count} kez'**
  String symptomsTimes(int count);

  /// No description provided for @symptomsOfLoggedDays.
  ///
  /// In tr, this message translates to:
  /// **'kayıtlı günlerin {percent}'**
  String symptomsOfLoggedDays(String percent);

  /// No description provided for @symptomsByPhase.
  ///
  /// In tr, this message translates to:
  /// **'Faza göre: {summary}'**
  String symptomsByPhase(String summary);

  /// No description provided for @sectionBleeding.
  ///
  /// In tr, this message translates to:
  /// **'Kanama'**
  String get sectionBleeding;

  /// No description provided for @sectionBleedingCaption.
  ///
  /// In tr, this message translates to:
  /// **'Kanama girilen tüm kayıtlardan'**
  String get sectionBleedingCaption;

  /// No description provided for @bleedingEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kanama kaydedilmedi. Burada bir özet görmek için bir kayıtta kanama düzeyini girin.'**
  String get bleedingEmpty;

  /// No description provided for @bleedingDaysLogged.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilen gün'**
  String get bleedingDaysLogged;

  /// No description provided for @bleedingAverageLevel.
  ///
  /// In tr, this message translates to:
  /// **'Ortalama düzey'**
  String get bleedingAverageLevel;

  /// No description provided for @bleedingPeakLevel.
  ///
  /// In tr, this message translates to:
  /// **'En yüksek düzey'**
  String get bleedingPeakLevel;

  /// No description provided for @bleedingIntensityScore.
  ///
  /// In tr, this message translates to:
  /// **'Yoğunluk puanı'**
  String get bleedingIntensityScore;

  /// No description provided for @bleedingIntensityNote.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilen düzeylerin toplamı'**
  String get bleedingIntensityNote;

  /// No description provided for @sectionConnections.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantılar'**
  String get sectionConnections;

  /// No description provided for @sectionConnectionsCaption.
  ///
  /// In tr, this message translates to:
  /// **'İki ölçümün kayıtlarınızda birlikte nasıl değiştiği; neden-sonuç değil, ilişki gösterir'**
  String get sectionConnectionsCaption;

  /// No description provided for @correlationSleepMood.
  ///
  /// In tr, this message translates to:
  /// **'Uyku ve ruh hali'**
  String get correlationSleepMood;

  /// No description provided for @correlationStressPain.
  ///
  /// In tr, this message translates to:
  /// **'Stres ve ağrı'**
  String get correlationStressPain;

  /// No description provided for @correlationNeedData.
  ///
  /// In tr, this message translates to:
  /// **'Değerleri farklılık gösteren en az üç kayıt gerekir.'**
  String get correlationNeedData;

  /// No description provided for @correlationNegligible.
  ///
  /// In tr, this message translates to:
  /// **'İhmal edilebilir'**
  String get correlationNegligible;

  /// No description provided for @correlationWeak.
  ///
  /// In tr, this message translates to:
  /// **'Zayıf'**
  String get correlationWeak;

  /// No description provided for @correlationModerate.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get correlationModerate;

  /// No description provided for @correlationStrong.
  ///
  /// In tr, this message translates to:
  /// **'Güçlü'**
  String get correlationStrong;

  /// No description provided for @correlationStrengthPositive.
  ///
  /// In tr, this message translates to:
  /// **'{strength}, pozitif'**
  String correlationStrengthPositive(String strength);

  /// No description provided for @correlationStrengthNegative.
  ///
  /// In tr, this message translates to:
  /// **'{strength}, negatif'**
  String correlationStrengthNegative(String strength);

  /// No description provided for @correlationSleepMoodNone.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlarınızda uyku kalitesi ile ruh hali arasında belirgin bir ilişki yok.'**
  String get correlationSleepMoodNone;

  /// No description provided for @correlationSleepMoodUp.
  ///
  /// In tr, this message translates to:
  /// **'Uyku kalitenizin daha yüksek olduğu günlerde ruh haliniz de daha iyi olma eğilimindeydi.'**
  String get correlationSleepMoodUp;

  /// No description provided for @correlationSleepMoodDown.
  ///
  /// In tr, this message translates to:
  /// **'Uyku kalitenizin daha yüksek olduğu günlerde ruh haliniz daha kötü olma eğilimindeydi.'**
  String get correlationSleepMoodDown;

  /// No description provided for @correlationStressPainNone.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlarınızda stres ile ağrı arasında belirgin bir ilişki yok.'**
  String get correlationStressPainNone;

  /// No description provided for @correlationStressPainUp.
  ///
  /// In tr, this message translates to:
  /// **'Stresinizin daha yüksek olduğu günlerde ağrınız da daha yüksek olma eğilimindeydi.'**
  String get correlationStressPainUp;

  /// No description provided for @correlationStressPainDown.
  ///
  /// In tr, this message translates to:
  /// **'Stresinizin daha yüksek olduğu günlerde ağrınız daha düşük olma eğilimindeydi.'**
  String get correlationStressPainDown;

  /// No description provided for @correlationStats.
  ///
  /// In tr, this message translates to:
  /// **'Spearman r = {r} · p = {p}'**
  String correlationStats(String r, String p);

  /// No description provided for @correlationMaybeChance.
  ///
  /// In tr, this message translates to:
  /// **'tesadüf olabilir'**
  String get correlationMaybeChance;

  /// No description provided for @correlationSemantic.
  ///
  /// In tr, this message translates to:
  /// **'{title}, korelasyon {r}'**
  String correlationSemantic(String title, String r);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
