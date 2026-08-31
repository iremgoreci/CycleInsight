class DailyLogLabels {
  const DailyLogLabels._();

  static const bleeding = {
    0: 'Yok',
    1: 'Çok hafif',
    2: 'Hafif',
    3: 'Orta',
    4: 'Şiddetli',
    5: 'Çok şiddetli',
  };

  static const mood = {
    1: 'Çok kötü',
    2: 'Kötü',
    3: 'Orta',
    4: 'İyi',
    5: 'Çok iyi',
  };

  static const pain = {
    0: 'Yok',
    1: 'Çok düşük',
    2: 'Düşük',
    3: 'Orta',
    4: 'Yüksek',
    5: 'Çok yüksek',
  };

  static const sleep = {
    0: 'Uyumadım',
    1: 'Çok kötü',
    2: 'Kötü',
    3: 'Orta',
    4: 'İyi',
    5: 'Çok iyi',
  };

  static const stress = pain;
}
