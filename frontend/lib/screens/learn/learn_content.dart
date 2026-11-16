import 'package:flutter/widgets.dart';

import '../../core/presentation/cycle_phase_style.dart';

/// Educational copy for the Learn section.
///
/// Long-form text lives here rather than in the ARB files so it can be
/// reviewed as a whole. Each locale has one [LearnContent] instance; to add
/// English, create an `_en` instance with the same structure and return it
/// from [LearnContent.of]. Layout code never changes.
///
/// The text is general background information checked against the sources
/// in [LearnContent.sources]. The "In CycleInsight" notes describe exactly
/// how the app's existing analysis treats each phase.
class LearnContent {
  const LearnContent({
    required this.intro,
    required this.variability,
    required this.estimateNote,
    required this.disclaimer,
    required this.chapters,
  });

  static LearnContent of(Locale locale) => switch (locale.languageCode) {
    _ => _tr,
  };

  final String intro;

  /// States that phase timing differs between people and cycles.
  final String variability;

  /// States that the app's phase/date estimates are not diagnoses or
  /// guarantees.
  final String estimateNote;
  final String disclaimer;
  final List<PhaseChapter> chapters;

  PhaseChapter chapterFor(CyclePhaseKind phase) =>
      chapters.firstWhere((chapter) => chapter.phase == phase);

  /// Example proportions used by the overview strip (a 28-day cycle).
  static const exampleDays = {
    CyclePhaseKind.menstrual: 5,
    CyclePhaseKind.follicular: 8,
    CyclePhaseKind.ovulatory: 2,
    CyclePhaseKind.luteal: 13,
  };

  /// Sources the content was checked against (shown in the Learn screen).
  static const sources = [
    LearnSource(
      title: 'NHS – Fertility in the menstrual cycle',
      url:
          'https://www.nhs.uk/conditions/periods/fertility-in-the-menstrual-cycle/',
    ),
    LearnSource(
      title: 'Office on Women\'s Health (ABD) – Your menstrual cycle',
      url: 'https://www.womenshealth.gov/menstrual-cycle/your-menstrual-cycle',
    ),
    LearnSource(
      title: 'Cleveland Clinic – Menstrual Cycle (Normal Menstruation)',
      url:
          'https://my.clevelandclinic.org/health/articles/10132-menstrual-cycle',
    ),
    LearnSource(
      title: 'Cleveland Clinic – Follicular Phase',
      url: 'https://my.clevelandclinic.org/health/body/23953-follicular-phase',
    ),
    LearnSource(
      title: 'Cleveland Clinic – Ovulation',
      url: 'https://my.clevelandclinic.org/health/articles/23439-ovulation',
    ),
    LearnSource(
      title: 'Cleveland Clinic – Luteal Phase',
      url: 'https://my.clevelandclinic.org/health/articles/24417-luteal-phase',
    ),
  ];
}

const _tr = LearnContent(
  intro:
      'Menstrüel döngü, bir adet döneminin ilk gününden bir sonraki adetin '
      'başlamasından önceki güne kadar sayılır. Ortalama döngü yaklaşık 28 '
      'gündür; ancak yetişkinlerde yaklaşık 21 ile 38 gün arasındaki '
      'uzunluklar olağan kabul edilir.',
  variability:
      'Döngü ve fazların süresi kişiden kişiye değişir; aynı kişide de aydan '
      'aya farklı olabilir. Burada verilen gün sayıları yalnızca örnektir. '
      'Sizin döngünüz daha kısa, daha uzun ya da daha değişken olabilir.',
  estimateNote:
      'CycleInsight\'ın gösterdiği faz, ovülasyon ve adet tarihleri, yalnızca '
      'girdiğiniz kayıtlardan hesaplanan tahminlerdir. Tıbbi teşhis değildir, '
      'kesinlik ya da garanti sunmaz ve doğum kontrolü veya gebelik planlaması '
      'için kullanılmamalıdır.',
  disclaimer:
      'Bu bölüm, döngünüzü anlamanıza yardımcı olmak için genel bilgi sunar; '
      'tıbbi tavsiye değildir. Döngünüzle ilgili sizi endişelendiren bir '
      'durum varsa bir sağlık profesyoneline danışın.',
  chapters: [
    PhaseChapter(
      phase: CyclePhaseKind.menstrual,
      timing: '1. günden yaklaşık 5. güne kadar',
      timingDetail:
          'Kanama çoğu kişide 3 ile 7 gün sürer; süre kişiden kişiye değişir.',
      summary:
          'Rahim iç tabakası dökülür ve kanamanın ilk günüyle yeni bir döngü '
          'başlar.',
      happening:
          'Gebelik oluşmadıysa önceki döngünün sonunda östrojen ve progesteron '
          'hormonlarının düzeyi düşer. Bu düşüş, rahmin iç tabakasını dökmesini '
          'başlatır ve bu tabaka adet kanaması olarak vücuttan atılır. '
          'Kanamanın ilk günü, yeni döngünün 1. günü sayılır.',
      notice:
          'Kanama genellikle ilk günlerde daha yoğundur, sonra azalır. En sık '
          'bildirilen belirti karın krampıdır; ruh hali değişiklikleri, uyku '
          'sorunları ve baş ağrısı da görülebilir. Deneyimler kişiden kişiye '
          've döngüden döngüye büyük farklılık gösterir.',
      inCycleInsight:
          'Adet başlangıç tarihiniz, geçmişinizde yeni bir döngü başlatır. '
          'Bitiş tarihini de kaydettiğinizde CycleInsight bu tarihi kullanarak '
          'menstrüel fazı döngü kadranınızda gösterir.',
      careNote:
          'Sık sık 8 günden uzun süren ya da çok yoğun kanama ve günlük '
          'işlerinizi yapmanızı engelleyen ağrı olağan değildir; bir sağlık '
          'profesyoneliyle görüşmeniz önerilir.',
    ),
    PhaseChapter(
      phase: CyclePhaseKind.follicular,
      timing: '1. günden ovülasyona kadar',
      timingDetail:
          'Döngünün en uzun fazıdır ve süresi döngüden döngüye değişebilir.',
      summary:
          'Vücut yumurtlamaya hazırlanır ve rahim iç tabakası yeniden '
          'kalınlaşmaya başlar.',
      happening:
          'Folikül uyarıcı hormon (FSH), yumurtalıklardaki foliküllerin, yani '
          'olgunlaşmamış yumurta içeren keseciklerin büyümesini sağlar. '
          'Genellikle bunlardan biri baskın hale gelir. Östrojen düzeyi '
          'yükselir ve rahim iç tabakasının olası bir gebeliğe hazırlanarak '
          'kalınlaşmasına yardımcı olur. Bu faz adetin ilk günü başladığı için '
          'adet dönemiyle örtüşür.',
      notice:
          'Ovülasyona yaklaşırken servikal akıntı daha berrak ve kaygan hale '
          'gelebilir. Bu fazda belirgin bir değişiklik fark etmemek de '
          'olağandır.',
      inCycleInsight:
          'Kaydettiğiniz adet döneminden sonraki ve tahmini ovülasyon gününden '
          'önceki günler foliküler faz olarak gösterilir.',
    ),
    PhaseChapter(
      phase: CyclePhaseKind.ovulatory,
      timing: 'Genellikle bir sonraki adetten yaklaşık 10–16 gün önce',
      timingDetail:
          'Ovülasyonun zamanı herkeste farklıdır ve döngü uzunluğuna göre '
          'değişir; kesin gününü belirlemek zordur.',
      summary:
          'Olgunlaşmış bir yumurta yumurtalıktan serbest bırakılır. Döngünün '
          'en kısa fazıdır.',
      happening:
          'Luteinleştirici hormondaki (LH) ani bir yükseliş, baskın folikülün '
          'yumurtayı serbest bırakmasını tetikler. Serbest kalan yumurta '
          'yaklaşık 12–24 saat canlı kalır.',
      notice:
          'Ovülasyondan önceki günlerde servikal akıntı berrak ve kaygan bir '
          'hal alabilir. Bazı kişiler karnın alt kısmında, ortada ya da bir '
          'tarafta kısa süreli bir ağrı hisseder ya da vücut sıcaklığında '
          'hafif bir artış fark eder. Herkes bu belirtileri fark etmez.',
      inCycleInsight:
          'CycleInsight, ovülasyonu kayıtlı tipik döngü uzunluğunuza göre bir '
          'sonraki beklenen adetten 14 gün önce olarak tahmin eder ve bu günün '
          'iki yanında üçer günlük bir pencere gösterir. Bu, kayıtlarınızdan '
          'yapılan bir tahmindir, ölçüm değildir; doğum kontrolü ya da gebelik '
          'planlaması için güvenilir bir yöntem olarak kullanılmamalıdır.',
    ),
    PhaseChapter(
      phase: CyclePhaseKind.luteal,
      timing: 'Ovülasyondan bir sonraki adete kadar',
      timingDetail:
          'Ortalama 12–14 gün sürer; 10–17 gün arası normal kabul edilir ve '
          'kişiden kişiye değişebilir.',
      summary:
          'Progesteron, rahim iç tabakasını olası bir gebeliğe hazırlamak için '
          'yükselir; gebelik oluşmazsa düşer.',
      happening:
          'Yumurtayı serbest bırakan folikül, korpus luteum adı verilen bir '
          'yapıya dönüşür. Korpus luteum, bir miktar östrojenle birlikte '
          'progesteron üretir; progesteron rahim iç tabakasının kalınlaşmasına '
          'yardımcı olur. Gebelik oluşmazsa östrojen ve progesteron düzeyleri '
          'düşer ve bir sonraki adet başlar.',
      notice:
          'Adetten önceki günlerde bazı kişiler şişkinlik, göğüs hassasiyeti, '
          'ruh hali değişiklikleri, sivilce ya da iştah değişiklikleri yaşar. '
          'Herkes bu belirtileri fark etmez ve şiddetleri döngüden döngüye '
          'değişebilir.',
      inCycleInsight:
          'Tahmini ovülasyon gününden sonraki günler, kaydedilen bir sonraki '
          'adet başlangıcına kadar luteal faz olarak gösterilir. Bu fazda '
          'semptomlarınızı kaydetmeniz, Analizler bölümünün semptomların hangi '
          'fazda görülme eğiliminde olduğunu göstermesine yardımcı olur.',
    ),
  ],
);

class PhaseChapter {
  const PhaseChapter({
    required this.phase,
    required this.timing,
    required this.timingDetail,
    required this.summary,
    required this.happening,
    required this.notice,
    required this.inCycleInsight,
    this.careNote,
  });

  final CyclePhaseKind phase;
  final String timing;
  final String timingDetail;
  final String summary;

  /// Body of the "What is happening" section.
  final String happening;

  /// Body of the "What you might notice" section.
  final String notice;
  final String inCycleInsight;
  final String? careNote;
}

class LearnSource {
  const LearnSource({required this.title, required this.url});

  final String title;
  final String url;
}
