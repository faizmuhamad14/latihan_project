class PetData {
  static const List<String> jenisHewan = ["Kucing", "Anjing"];

  static const Map<String, List<String>> petBreeds = {
    "Kucing": [
      "Persia",
      "Anggora",
      "Maine Coon",
      "British Shorthair",
      "Ragdoll",
      "Kampung",
    ],

    "Anjing": [
      "Golden Retriever",
      "Pomeranian",
      "Husky",
      "Bulldog",
      "Beagle",
      "Shih Tzu",
    ],
  };

  static const List<Map<String, String>> umurPet = [
    {"label": "Anak", "desc": "0 - 1 Tahun"},
    {"label": "Dewasa", "desc": "1 - 7 Tahun"},
    {"label": "Senior", "desc": "> 7 Tahun"},
  ];
}
