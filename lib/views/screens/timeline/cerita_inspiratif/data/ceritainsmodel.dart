class Cerita {
  final String imageUrl;
  final String name;
  final String category;
  final int price;

  final String description;

  Cerita({
    this.imageUrl,
    this.name,
    this.category,
    this.price,
    this.description,
  });
}

final List<Cerita> ceritas = [
  Cerita(
    imageUrl: 'assets/images/cerita_inspiratif/plant0.png',
    name: 'Penjual Kerupuk Buta',
    category: 'Teratas',
    price: 0,
    description:
        'Dikisahkan seorang pedagang kerupuk yang buta ketika hendak diminta kembalian:Si pembeli bertanya : "Pak, seumpama saya tidak kasih bapak uang tapi saya mengambil kembalian 10 ribu bapak tidak takut rugi?"  Sambil nada menggoda.Penjual kerupuk menjawab dengan lembut: "Allah tidak akan menukarkan rezeki nak, rezeki sudah diatur oleh-Nya, kalau sekarang saya rugi, saya yakin Allah akan menyediakan rezeki yang lain untuk saya."Seketika mendengar jawaban penjual kerupuk pemuda itu  Langsung bertepuk tangan kemudian Allah memberi rezeki kepada tukang kerupuk itu lewat pemuda yang membeli tadi dengan memberikan uang yang lebih.',
  ),
  Cerita(
    imageUrl: 'assets/images/cerita_inspiratif/plant1.png',
    name: 'Kisah Isra Miraj',
    category: 'Kisah Nabi',
    price: 0,
    description: 'Kisah Isra Miraj yang ada di drive.',
  ),
  Cerita(
    imageUrl: 'assets/images/cerita_inspiratif/plant2.png',
    name: 'Rasulullah Menenangkan Abu Bakar',
    category: 'Kisah Nabi',
    price: 0,
    description: 'Kisah yang ada di drive.',
  ),
];
