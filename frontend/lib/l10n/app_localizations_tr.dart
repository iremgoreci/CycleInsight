// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'CycleInsight';

  @override
  String get commonTryAgain => 'Tekrar dene';

  @override
  String get commonRetry => 'Yeniden dene';

  @override
  String get commonCancel => 'Vazgeç';

  @override
  String get commonDelete => 'Sil';

  @override
  String get commonEdit => 'Düzenle';

  @override
  String get commonMore => 'Diğer';

  @override
  String get commonSaveChanges => 'Değişiklikleri kaydet';

  @override
  String get commonChange => 'Değiştir';

  @override
  String get commonNotEnoughData => 'Yeterli veri yok';

  @override
  String get commonEstimated => 'tahmini';

  @override
  String get commonToday => 'Bugün';

  @override
  String get commonYesterday => 'Dün';

  @override
  String get commonTomorrow => 'Yarın';

  @override
  String relativeInDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün sonra',
      one: '1 gün sonra',
    );
    return '$_temp0';
  }

  @override
  String relativeDaysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün önce',
      one: '1 gün önce',
    );
    return '$_temp0';
  }

  @override
  String daysCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count gün',
      one: '1 gün',
    );
    return '$_temp0';
  }

  @override
  String get unitDays => 'gün';

  @override
  String get unitOutOfFive => '/ 5';

  @override
  String semanticValue(String label, String value) {
    return '$label: $value';
  }

  @override
  String get errorGeneric => 'Bir sorun oluştu. Lütfen tekrar deneyin.';

  @override
  String get errorLoadTitle => 'Yüklenemedi';

  @override
  String get errorNetwork =>
      'Sunucuya ulaşılamıyor. Bağlantınızı kontrol edip tekrar deneyin.';

  @override
  String get errorServer =>
      'Sunucu bu isteği tamamlayamadı. Lütfen tekrar deneyin.';

  @override
  String get errorSessionExpired =>
      'Oturumunuzun süresi doldu. Lütfen yeniden giriş yapın.';

  @override
  String get errorInvalidCredentials => 'E-posta adresi veya şifre hatalı.';

  @override
  String get errorEmailExists =>
      'Bu e-posta adresiyle kayıtlı bir hesap zaten var.';

  @override
  String get errorInvalidInput =>
      'Girilen bilgilerden bazıları geçersiz. Lütfen kontrol edin.';

  @override
  String get errorCycleDuplicateStart =>
      'Bu başlangıç tarihine sahip bir döngü zaten kayıtlı.';

  @override
  String get errorEndBeforeStart =>
      'Bitiş tarihi başlangıç tarihinden önce olamaz.';

  @override
  String get errorDailyLogExists => 'Bu tarih için zaten bir günlük kayıt var.';

  @override
  String get errorDailyLogNotFound => 'Bu günlük kayıt artık mevcut değil.';

  @override
  String get errorCycleNotFound => 'Bu döngü artık mevcut değil.';

  @override
  String get errorNotFound => 'İstenen kayıt bulunamadı.';

  @override
  String get navToday => 'Bugün';

  @override
  String get navJournal => 'Günlük';

  @override
  String get navInsights => 'Analizler';

  @override
  String get fieldEmail => 'E-posta';

  @override
  String get fieldPassword => 'Şifre';

  @override
  String get fieldFirstName => 'Ad';

  @override
  String get fieldLastName => 'Soyad';

  @override
  String get fieldDateOfBirth => 'Doğum tarihi';

  @override
  String get passwordShow => 'Şifreyi göster';

  @override
  String get passwordHide => 'Şifreyi gizle';

  @override
  String get validationEmailRequired => 'E-posta adresinizi girin';

  @override
  String get validationPasswordRequired => 'Şifrenizi girin';

  @override
  String get validationNewPasswordRequired => 'Bir şifre belirleyin';

  @override
  String get validationFirstNameRequired => 'Adınızı girin';

  @override
  String get validationLastNameRequired => 'Soyadınızı girin';

  @override
  String get validationDateOfBirthRequired => 'Doğum tarihinizi seçin';

  @override
  String get loginTitle => 'Tekrar hoş geldiniz';

  @override
  String get loginLede =>
      'Kayıtlarınıza kaldığınız yerden devam etmek için giriş yapın.';

  @override
  String get loginSubmit => 'Giriş yap';

  @override
  String get loginFailed => 'Giriş yapılamadı';

  @override
  String get loginNewPrompt => 'CycleInsight\'ta yeni misiniz?';

  @override
  String get loginCreateAccount => 'Hesap oluşturun';

  @override
  String get registerTitle => 'Hesabınızı oluşturun';

  @override
  String get registerLede =>
      'Döngü kayıtlarınız yalnızca kendi hesabınıza bağlı kalır.';

  @override
  String get registerSectionAbout => 'Hakkınızda';

  @override
  String get registerSectionAccount => 'Hesap';

  @override
  String get registerDobHelp =>
      'Döngü düzenliliğini yaşınıza göre değerlendirmek için kullanılır.';

  @override
  String get registerDobNotSet => 'Doğum tarihi, seçilmedi';

  @override
  String registerDobSemantic(String date) {
    return 'Doğum tarihi, $date';
  }

  @override
  String get registerSubmit => 'Hesap oluştur';

  @override
  String get registerFailed => 'Kayıt tamamlanamadı';

  @override
  String get registerHaveAccount => 'Zaten hesabınız var mı?';

  @override
  String get registerSignIn => 'Giriş yapın';

  @override
  String get profileAccount => 'Hesap';

  @override
  String profileBorn(String date) {
    return 'Doğum tarihi: $date';
  }

  @override
  String get profileYourRecords => 'Kayıtlarınız';

  @override
  String get profileCycleHistory => 'Döngü geçmişi';

  @override
  String get profileCycleHistorySubtitle =>
      'Kayıtlı adet dönemlerini görüntüleyin ve yönetin';

  @override
  String get profileLogHistory => 'Günlük kayıt geçmişi';

  @override
  String get profileLogHistorySubtitle => 'Önceki kayıtlarınızı inceleyin';

  @override
  String get profileLearn => 'Döngünüzü tanıyın';

  @override
  String get profileLearnSubtitle => 'Dört faz, açıklamalarıyla';

  @override
  String get profileSignOut => 'Çıkış yap';

  @override
  String get phaseMenstrual => 'Menstrüel';

  @override
  String get phaseFollicular => 'Foliküler';

  @override
  String get phaseOvulatory => 'Ovülasyon';

  @override
  String get phaseLuteal => 'Luteal';

  @override
  String get phaseMenstrualName => 'Menstrüel faz';

  @override
  String get phaseFollicularName => 'Foliküler faz';

  @override
  String get phaseOvulatoryName => 'Ovülasyon fazı';

  @override
  String get phaseLutealName => 'Luteal faz';

  @override
  String get phaseMenstrualShort => 'Mens.';

  @override
  String get phaseFollicularShort => 'Fol.';

  @override
  String get phaseOvulatoryShort => 'Ovül.';

  @override
  String get phaseLutealShort => 'Lut.';

  @override
  String get metricBleeding => 'Kanama';

  @override
  String get metricMood => 'Ruh hali';

  @override
  String get metricPain => 'Ağrı';

  @override
  String get metricSleep => 'Uyku';

  @override
  String get metricSleepQuality => 'Uyku kalitesi';

  @override
  String get metricStress => 'Stres';

  @override
  String get bleedingLevel0 => 'Yok';

  @override
  String get bleedingLevel1 => 'Çok hafif';

  @override
  String get bleedingLevel2 => 'Hafif';

  @override
  String get bleedingLevel3 => 'Orta';

  @override
  String get bleedingLevel4 => 'Şiddetli';

  @override
  String get bleedingLevel5 => 'Çok şiddetli';

  @override
  String get moodLevel1 => 'Çok kötü';

  @override
  String get moodLevel2 => 'Kötü';

  @override
  String get moodLevel3 => 'Orta';

  @override
  String get moodLevel4 => 'İyi';

  @override
  String get moodLevel5 => 'Çok iyi';

  @override
  String get painLevel0 => 'Yok';

  @override
  String get painLevel1 => 'Çok düşük';

  @override
  String get painLevel2 => 'Düşük';

  @override
  String get painLevel3 => 'Orta';

  @override
  String get painLevel4 => 'Yüksek';

  @override
  String get painLevel5 => 'Çok yüksek';

  @override
  String get sleepLevel0 => 'Uyumadım';

  @override
  String get sleepLevel1 => 'Çok kötü';

  @override
  String get sleepLevel2 => 'Kötü';

  @override
  String get sleepLevel3 => 'Orta';

  @override
  String get sleepLevel4 => 'İyi';

  @override
  String get sleepLevel5 => 'Çok iyi';

  @override
  String get stressLevel0 => 'Yok';

  @override
  String get stressLevel1 => 'Çok düşük';

  @override
  String get stressLevel2 => 'Düşük';

  @override
  String get stressLevel3 => 'Orta';

  @override
  String get stressLevel4 => 'Yüksek';

  @override
  String get stressLevel5 => 'Çok yüksek';

  @override
  String get greetingMorning => 'Günaydın';

  @override
  String get greetingAfternoon => 'İyi günler';

  @override
  String get greetingEvening => 'İyi akşamlar';

  @override
  String greetingWithName(String greeting, String name) {
    return '$greeting, $name';
  }

  @override
  String get homeReadingCycle => 'Döngünüz hazırlanıyor…';

  @override
  String get homeOverviewUnavailable => 'Döngü özeti yüklenemedi';

  @override
  String get homeCycleDay => 'Döngü günü';

  @override
  String homeOfAboutDays(int days) {
    return '~$days günlük döngü';
  }

  @override
  String get homeNoCycleYet => 'Henüz döngü yok';

  @override
  String get homePhaseNotEstimated => 'Faz tahmin edilmedi';

  @override
  String get homeDialNoCycle => 'Henüz kayıtlı döngü yok';

  @override
  String homeDialDay(int day) {
    return 'Döngünün $day. günü';
  }

  @override
  String homeDialOfAbout(int days) {
    return 'yaklaşık $days günlük döngü';
  }

  @override
  String get homeAddFirstPeriodPrompt =>
      'Bugünün döngünüzdeki yerini görmek için son adet döneminizin ilk gününü kaydedin.';

  @override
  String get homeAddPeriod => 'Adet dönemi ekle';

  @override
  String get homeNeedSecondPeriod =>
      'Döngü uzunluğunuzu ve fazlarınızı tahmin etmek için bir adet başlangıç tarihi daha ekleyin.';

  @override
  String homePastEstimate(int day, int over) {
    String _temp0 = intl.Intl.pluralLogic(
      over,
      locale: localeName,
      other: '$over gün',
      one: '1 gün',
    );
    return '$day. gün, tahmini döngü uzunluğunuzu $_temp0 geçti. Adetiniz başladıysa kaydedin.';
  }

  @override
  String get homeAddEndDate =>
      'Kadranda menstrüel fazı göstermek için son adet döneminize bitiş tarihi ekleyin.';

  @override
  String get homeRecordPeriod => 'Adet dönemi kaydet';

  @override
  String get homeOpenCycleHistory => 'Döngü geçmişini aç';

  @override
  String get homeComingUp => 'Yaklaşanlar';

  @override
  String get homeComingUpSubtitle => 'Kayıtlı döngülerinize dayalı tahminler';

  @override
  String get homeNextPeriod => 'Sonraki adet';

  @override
  String get homeOvulation => 'Ovülasyon';

  @override
  String homeOvulationWindow(int start, int end) {
    return 'Pencere: döngünün $start–$end. günleri';
  }

  @override
  String get homeSeeInsights => 'Analizlere git';

  @override
  String get homeTodayCheckIn => 'Bugünün kaydı';

  @override
  String get homeCheckInPrompt => 'Bugün nasılsınız?';

  @override
  String get homeCheckInPromptBody =>
      'Kanama, ruh hali, ağrı, uyku ve stres; bir dakikadan kısa sürer. Her kayıt, Analizler\'deki örüntülere katkı sağlar.';

  @override
  String get homeCheckInButton => 'Kayıt ekle';

  @override
  String get homeCheckInRecorded => 'Kaydedildi';

  @override
  String get homeCheckInLoadError => 'Bugünün kaydı yüklenemedi.';

  @override
  String get homeReadAboutPhase => 'Bu faz hakkında okuyun';

  @override
  String get homeLearnFallback =>
      'Her fazda neler olduğu ve CycleInsight\'ın fazları nasıl tahmin ettiği.';

  @override
  String get confidenceHigh => 'Yüksek';

  @override
  String get confidenceMedium => 'Orta';

  @override
  String get confidenceLow => 'Düşük';

  @override
  String confidenceLabel(String tier) {
    return 'Güven düzeyi: $tier';
  }

  @override
  String get logNewTitle => 'Yeni kayıt';

  @override
  String get logEditTitle => 'Kaydı düzenle';

  @override
  String get logSectionBody => 'Beden';

  @override
  String get logSectionMind => 'Zihin ve dinlenme';

  @override
  String get logSymptoms => 'Semptomlar';

  @override
  String get logSymptomsSubtitle => 'Fark ettiklerinizi seçin';

  @override
  String logSymptomsSelected(int count) {
    return '$count seçildi';
  }

  @override
  String get logNotes => 'Notlar';

  @override
  String get logNotesHint =>
      'Bugünle ilgili eklemek istedikleriniz (isteğe bağlı)';

  @override
  String get logSave => 'Kaydı kaydet';

  @override
  String get logSymptomsLoading => 'Semptomlar yükleniyor…';

  @override
  String get logSymptomsError => 'Semptomlar yüklenemedi.';

  @override
  String get logNoSymptomTypes => 'Kullanılabilir semptom türü yok.';

  @override
  String get logSavedButSymptomsFailed =>
      'Günlük kayıt kaydedildi ancak bazı semptomlar kaydedilemedi. Lütfen tekrar deneyin.';

  @override
  String get logCreateFailed => 'Günlük kayıt oluşturulamadı';

  @override
  String get logUpdateFailed => 'Günlük kayıt güncellenemedi';

  @override
  String get logLoadFailed => 'Günlük kayıtlar yüklenemedi';

  @override
  String get logDeleteFailed => 'Günlük kayıt silinemedi';

  @override
  String get journalEyebrow => 'Günlük kayıt';

  @override
  String get journalTitle => 'Günlük';

  @override
  String journalCount(int count) {
    return '$count kayıt';
  }

  @override
  String get journalNew => 'Yeni';

  @override
  String get journalUnavailable => 'Günlük yüklenemedi';

  @override
  String get journalEmptyTitle => 'İlk kaydınızı oluşturun';

  @override
  String get journalEmptyBody =>
      'Bugün nasıl hissettiğinizi kaydedin: kanama, ruh hali, ağrı, uyku, stres ve semptomlar. Kayıtlar burada aylara göre listelenir.';

  @override
  String get journalEmptyAction => 'Günlük kayıt ekle';

  @override
  String journalBleeding(String level) {
    return 'Kanama · $level';
  }

  @override
  String get journalDeleteTitle => 'Günlük kayıt silinsin mi?';

  @override
  String journalDeleteBody(String date) {
    return '$date tarihli kayıt ve semptomları silinecek.';
  }

  @override
  String get journalDeleted => 'Kayıt silindi';

  @override
  String get cycleHistoryTitle => 'Döngü geçmişi';

  @override
  String get cycleAddPeriod => 'Adet ekle';

  @override
  String get cycleUnavailable => 'Döngü geçmişi yüklenemedi';

  @override
  String get cycleLoadFailed => 'Döngüler yüklenemedi';

  @override
  String get cycleEmptyTitle => 'İlk adet döneminizi ekleyin';

  @override
  String get cycleEmptyBody =>
      'Adet başlangıç tarihleri döngünüzdeki yerinizi belirler. İki veya daha fazla tarih, CycleInsight\'ın döngü uzunluğunuzu tahmin etmesini sağlar.';

  @override
  String get cycleEmptyAction => 'Adet dönemi ekle';

  @override
  String cycleRecordedIntro(int count) {
    return '$count adet dönemi kayıtlı. Tarihlerini düzeltmek için birine dokunun.';
  }

  @override
  String get cycleLatest => 'En son';

  @override
  String get cyclePeriodEndMissing => 'Adet bitişi kaydedilmedi';

  @override
  String cyclePeriodDays(int count) {
    return 'Adet · $count gün';
  }

  @override
  String cycleLengthDays(int days) {
    return '$days günlük döngü';
  }

  @override
  String get cycleDeleteTitle => 'Döngü silinsin mi?';

  @override
  String cycleDeleteBody(String date) {
    return '$date tarihinde başlayan döngü, geçmişinizden ve analizlerinizden kaldırılacak.';
  }

  @override
  String get cycleDeleteFailed => 'Döngü silinemedi';

  @override
  String get cycleNewTitle => 'Yeni adet dönemi';

  @override
  String get cycleEditTitle => 'Adet dönemini düzenle';

  @override
  String get cycleFormIntro =>
      'Döngü, adetinizin ilk günü başlar. Bildiğiniz tarihleri kaydedin; bitiş tarihini daha sonra da ekleyebilirsiniz.';

  @override
  String get cycleStarted => 'Adet başlangıcı';

  @override
  String get cycleEnded => 'Adet bitişi · isteğe bağlı';

  @override
  String get cycleNotRecorded => 'Kaydedilmedi';

  @override
  String get cycleEndHelp =>
      'Kadranda menstrüel fazı göstermek için kullanılır';

  @override
  String cycleBleedingDays(int count) {
    return '$count gün kanama';
  }

  @override
  String get cycleClearEnd => 'Bitiş tarihini temizle (adet devam ediyor)';

  @override
  String get cycleSave => 'Adet dönemini kaydet';

  @override
  String get cycleCreateFailed => 'Döngü oluşturulamadı';

  @override
  String get cycleUpdateFailed => 'Döngü güncellenemedi';

  @override
  String get learnEyebrow => 'Öğren';

  @override
  String get learnTitle => 'Döngünüz, dört fazda';

  @override
  String get learnExampleCycle => 'Örnek bir 28 günlük döngü';

  @override
  String learnYouAre(String phase) {
    return 'Siz: $phase';
  }

  @override
  String get learnNow => 'Şu an';

  @override
  String get learnDayOne => '1. gün';

  @override
  String get learnTapHint =>
      'Sizin döngünüz daha kısa veya daha uzun olabilir. Okumak için bir faza dokunun.';

  @override
  String learnPhaseOf(int number) {
    return 'Faz $number / 4';
  }

  @override
  String get learnWhen => 'Ne zaman';

  @override
  String get learnWhatIsHappening => 'Neler oluyor';

  @override
  String get learnWhatYouMightNotice => 'Neler fark edebilirsiniz';

  @override
  String get learnInApp => 'CycleInsight\'ta';

  @override
  String get learnPrevious => 'Önceki';

  @override
  String get learnNext => 'Sonraki';

  @override
  String get learnSources => 'Kaynaklar';

  @override
  String get insightsEyebrow => 'Kişisel rapor';

  @override
  String get insightsTitle => 'Analizler';

  @override
  String insightsCycles(int count) {
    return '$count döngü';
  }

  @override
  String insightsLogs(int count) {
    return '$count günlük kayıt';
  }

  @override
  String insightsBasedOn(String parts) {
    return 'Kaynak: $parts';
  }

  @override
  String get insightsAnd => ' ve ';

  @override
  String get insightsBuilding => 'Raporunuz hazırlanıyor…';

  @override
  String get insightsUnavailable => 'Analizler yüklenemedi';

  @override
  String get insightsLoadFailed => 'Analiz yüklenemedi';

  @override
  String get insightsDisclaimer =>
      'Bu özetler kendi kayıtlarınızdaki örüntüleri açıklar. Fazlar ve tarihler tahmindir; bağlantılar neden-sonuç değil, ilişki gösterir. CycleInsight tıbbi teşhis koymaz.';

  @override
  String get digestTitle => 'Kayıtlarınız ne gösteriyor';

  @override
  String get digestEmpty =>
      'Birkaç döngü ve günlük kayıt girdiğinizde analizler burada görünür. Kayıt tutmaya devam edin; örüntülerin oluşması biraz zaman alır.';

  @override
  String get insightCyclePatternTitle => 'Döngü örüntüsü';

  @override
  String get insightCycleRegular =>
      'Kayıtlı döngü uzunluklarınız görece tutarlı görünüyor.';

  @override
  String get insightCycleIrregular =>
      'Kayıtlı döngü uzunluklarınızda bir miktar değişkenlik var.';

  @override
  String get insightCycleTrendTitle => 'Döngü uzunluğu eğilimi';

  @override
  String get insightCycleTrendUp =>
      'Kayıtlı döngü uzunluklarınız zaman içinde artış eğilimi gösteriyor.';

  @override
  String get insightCycleTrendDown =>
      'Kayıtlı döngü uzunluklarınız zaman içinde azalma eğilimi gösteriyor.';

  @override
  String get insightPredictionTitle => 'Döngü tahmini';

  @override
  String insightPredictionLow(int days) {
    return 'Tahmini döngü uzunluğunuz $days gün; ancak bu tahminin daha güvenilir olması için daha fazla döngü verisi gerekiyor.';
  }

  @override
  String insightPredictionBased(int days) {
    return 'Kayıtlı döngülerinize göre tahmini döngü uzunluğunuz $days gün.';
  }

  @override
  String get insightBleedingIntensityTitle => 'Kanama yoğunluğu';

  @override
  String get insightBleedingHighAverage =>
      'Kayıtlı kanama düzeyleriniz ortalamada görece yüksek.';

  @override
  String get insightPeakBleedingTitle => 'En yüksek kanama düzeyi';

  @override
  String get insightPeakBleeding =>
      'En az bir kayıtlı günde yüksek bir kanama düzeyi kaydettiniz.';

  @override
  String get insightSymptomTitle => 'Tekrarlayan semptomlar';

  @override
  String insightSymptomWithPhase(String symptom, int count, String phase) {
    return '$symptom $count kez kaydedildi; en sık görüldüğü faz: $phase.';
  }

  @override
  String insightSymptomNoPhase(String symptom, int count) {
    return '$symptom $count kez kaydedildi.';
  }

  @override
  String insightWellbeingTitle(String metric) {
    return '$metric eğilimi';
  }

  @override
  String insightWellbeingUp(String metric) {
    return 'Kayıtlı $metric değerleriniz artış eğilimi gösteriyor.';
  }

  @override
  String insightWellbeingDown(String metric) {
    return 'Kayıtlı $metric değerleriniz azalma eğilimi gösteriyor.';
  }

  @override
  String get insightMetricMood => 'ruh hali';

  @override
  String get insightMetricPain => 'ağrı';

  @override
  String get insightMetricSleep => 'uyku';

  @override
  String get insightMetricStress => 'stres';

  @override
  String get insightSleepMoodPositive =>
      'Kayıtlı uyku kaliteniz, ruh halinizle pozitif yönde ilişkili görünüyor.';

  @override
  String get insightSleepMoodNegative =>
      'Kayıtlı uyku kaliteniz, ruh halinizle negatif yönde ilişkili görünüyor.';

  @override
  String get insightStressPainPositive =>
      'Kayıtlı stres düzeyleriniz, ağrı düzeylerinizle pozitif yönde ilişkili görünüyor.';

  @override
  String get insightStressPainNegative =>
      'Kayıtlı stres düzeyleriniz, ağrı düzeylerinizle negatif yönde ilişkili görünüyor.';

  @override
  String get sectionCycleLength => 'Döngü uzunluğu';

  @override
  String get sectionCycleLengthCaption =>
      'Bir adet başlangıcından bir sonrakine kadar geçen gün sayısı';

  @override
  String get sectionCycleLengthEmpty =>
      'En az iki adet başlangıç tarihi kaydettiğinizde döngü uzunluğu burada görünür.';

  @override
  String get statAverage => 'Ortalama';

  @override
  String get statVariability => 'Değişkenlik';

  @override
  String get statStandardDeviation => 'Standart sapma';

  @override
  String get statRange => 'Aralık';

  @override
  String statRangeDays(int min, int max) {
    return '$min–$max gün';
  }

  @override
  String chartMedian(String value) {
    return 'Medyan $value gün';
  }

  @override
  String chartCycleStarting(String date) {
    return '$date tarihinde başlayan döngü';
  }

  @override
  String chartCycleNumber(int number, int total) {
    return 'Döngü $number / $total';
  }

  @override
  String chartDaysPoint(String label, int days) {
    return '$label: $days gün';
  }

  @override
  String chartSemantic(String summary) {
    return 'Döngü uzunluğu grafiği. $summary';
  }

  @override
  String get regularityLabel => 'Düzenlilik';

  @override
  String get regularityRegular => 'Düzenli';

  @override
  String get regularityIrregular => 'Düzensiz';

  @override
  String get regularityNotAssessed => 'Henüz değerlendirilmedi';

  @override
  String get regularityExplainRegular =>
      'Kayıtlı döngü uzunluklarınız tutarlı bir aralıkta kalıyor.';

  @override
  String get regularityExplainIrregular =>
      'Kayıtlı döngü uzunluklarınız olağandan daha fazla değişkenlik gösteriyor.';

  @override
  String get regularityExplainNotAssessed =>
      'Düzenlilik, yaş grubunuz için henüz değerlendirilmiyor.';

  @override
  String get regularityExplainInsufficient =>
      'Düzenlilik, daha fazla döngü kaydedildiğinde değerlendirilir.';

  @override
  String get lengthOverTime => 'Zaman içindeki uzunluk';

  @override
  String get trendUp => 'Artıyor';

  @override
  String get trendDown => 'Azalıyor';

  @override
  String get trendNone => 'Belirgin eğilim yok';

  @override
  String get trendUnavailable => 'Yeterli veri yok';

  @override
  String get trendNeedThree => 'En az üç döngü uzunluğu gerekir.';

  @override
  String get trendNoneDetail =>
      'Döngüleriniz boyunca istatistiksel olarak belirgin bir değişim yok.';

  @override
  String get trendDetail =>
      'Kayıtlı döngüleriniz boyunca tutarlı bir değişim var.';

  @override
  String get sectionPredictions => 'Tahminler';

  @override
  String get sectionPredictionsCaption =>
      'Kayıtlı geçmişinizden yapılan tahminlerdir; kesinlik içermez';

  @override
  String get predictionsEmptyNoCycle =>
      'Tahmini tarihleri burada görmek için adet tarihlerinizi kaydedin.';

  @override
  String predictionsEmptyDay(int day) {
    return 'Döngünüzün $day. günündesiniz. Tahminler için en az iki adet başlangıç tarihi gerekir.';
  }

  @override
  String predictionsToday(int day) {
    return 'Bugün döngünüzün $day. günü.';
  }

  @override
  String predictionsCurrentPhase(String phase) {
    return 'Şu anki faz: $phase.';
  }

  @override
  String get predictionsNextPeriod => 'Sonraki adet';

  @override
  String get predictionsOvulation => 'Ovülasyon';

  @override
  String predictionsCycleDay(int day) {
    return 'Döngünün $day. günü';
  }

  @override
  String predictionsWindow(int start, int end) {
    return 'pencere: $start–$end. günler';
  }

  @override
  String get predictionsEstimatedLength => 'Tahmini döngü uzunluğu';

  @override
  String get predictionsMedianNote => 'Kayıtlı döngülerinizin medyanı';

  @override
  String get predictionsConfidenceBasis =>
      'Kaç döngü kaydettiğinize ve uzunluklarının ne kadar tutarlı olduğuna dayanır.';

  @override
  String get sectionWellbeing => 'İyi oluş';

  @override
  String get sectionWellbeingCaption =>
      '0–5 ölçeğinde kaydettiğiniz aralık ve ortalama';

  @override
  String get wellbeingEmpty =>
      'Ruh hali, uyku, ağrı ve stres özetleri ilk kayıtlarınızdan sonra görünür.';

  @override
  String get wellbeingHigherBetter => 'yüksek olması daha iyi';

  @override
  String get wellbeingHigherMore => 'yüksek değer daha fazlası';

  @override
  String get wellbeingAverageShort => 'ort.';

  @override
  String wellbeingRange(String min, String max) {
    return 'Aralık $min–$max';
  }

  @override
  String wellbeingMedian(String value) {
    return 'medyan $value';
  }

  @override
  String get wellbeingNoData => 'Henüz veri yok';

  @override
  String get wellbeingKeyRange => 'Kaydedilen en düşükten en yükseğe';

  @override
  String get wellbeingKeyAverage => 'Ortalama';

  @override
  String wellbeingSemantic(
    String metric,
    String average,
    String min,
    String max,
    String trend,
  ) {
    return '$metric: ortalama $average / 5, aralık $min–$max. Eğilim: $trend.';
  }

  @override
  String wellbeingSemanticNoData(String metric, String trend) {
    return '$metric: veri yok. Eğilim: $trend.';
  }

  @override
  String get wellbeingByPhase => 'Faza göre';

  @override
  String get wellbeingByPhaseCaption =>
      'Her tahmini faza denk gelen kayıtların ortalaması. Koyu hücreler daha yüksek değerleri gösterir.';

  @override
  String get wellbeingCellNoData => 'veri yok';

  @override
  String get sectionSymptoms => 'Semptomlar';

  @override
  String get sectionSymptomsCaption =>
      'Her birinin ne sıklıkla ve hangi tahmini fazda kaydedildiği';

  @override
  String get symptomsEmpty =>
      'Henüz semptom kaydedilmedi. Ne sıklıkla ve hangi fazda görüldüklerini görmek için bir kayıtta semptom seçin.';

  @override
  String get symptomsNamesUnavailable =>
      'Semptom adları şu anda kullanılamıyor.';

  @override
  String get symptomsUnknown => 'Bilinmeyen semptom';

  @override
  String symptomsMostly(String phase) {
    return 'En sık: $phase';
  }

  @override
  String symptomsTimes(int count) {
    return '$count kez';
  }

  @override
  String symptomsOfLoggedDays(String percent) {
    return 'kayıtlı günlerin $percent';
  }

  @override
  String symptomsByPhase(String summary) {
    return 'Faza göre: $summary';
  }

  @override
  String get sectionBleeding => 'Kanama';

  @override
  String get sectionBleedingCaption => 'Kanama girilen tüm kayıtlardan';

  @override
  String get bleedingEmpty =>
      'Henüz kanama kaydedilmedi. Burada bir özet görmek için bir kayıtta kanama düzeyini girin.';

  @override
  String get bleedingDaysLogged => 'Kaydedilen gün';

  @override
  String get bleedingAverageLevel => 'Ortalama düzey';

  @override
  String get bleedingPeakLevel => 'En yüksek düzey';

  @override
  String get bleedingIntensityScore => 'Yoğunluk puanı';

  @override
  String get bleedingIntensityNote => 'Kaydedilen düzeylerin toplamı';

  @override
  String get sectionConnections => 'Bağlantılar';

  @override
  String get sectionConnectionsCaption =>
      'İki ölçümün kayıtlarınızda birlikte nasıl değiştiği; neden-sonuç değil, ilişki gösterir';

  @override
  String get correlationSleepMood => 'Uyku ve ruh hali';

  @override
  String get correlationStressPain => 'Stres ve ağrı';

  @override
  String get correlationNeedData =>
      'Değerleri farklılık gösteren en az üç kayıt gerekir.';

  @override
  String get correlationNegligible => 'İhmal edilebilir';

  @override
  String get correlationWeak => 'Zayıf';

  @override
  String get correlationModerate => 'Orta';

  @override
  String get correlationStrong => 'Güçlü';

  @override
  String correlationStrengthPositive(String strength) {
    return '$strength, pozitif';
  }

  @override
  String correlationStrengthNegative(String strength) {
    return '$strength, negatif';
  }

  @override
  String get correlationSleepMoodNone =>
      'Kayıtlarınızda uyku kalitesi ile ruh hali arasında belirgin bir ilişki yok.';

  @override
  String get correlationSleepMoodUp =>
      'Uyku kalitenizin daha yüksek olduğu günlerde ruh haliniz de daha iyi olma eğilimindeydi.';

  @override
  String get correlationSleepMoodDown =>
      'Uyku kalitenizin daha yüksek olduğu günlerde ruh haliniz daha kötü olma eğilimindeydi.';

  @override
  String get correlationStressPainNone =>
      'Kayıtlarınızda stres ile ağrı arasında belirgin bir ilişki yok.';

  @override
  String get correlationStressPainUp =>
      'Stresinizin daha yüksek olduğu günlerde ağrınız da daha yüksek olma eğilimindeydi.';

  @override
  String get correlationStressPainDown =>
      'Stresinizin daha yüksek olduğu günlerde ağrınız daha düşük olma eğilimindeydi.';

  @override
  String correlationStats(String r, String p) {
    return 'Spearman r = $r · p = $p';
  }

  @override
  String get correlationMaybeChance => 'tesadüf olabilir';

  @override
  String correlationSemantic(String title, String r) {
    return '$title, korelasyon $r';
  }
}
