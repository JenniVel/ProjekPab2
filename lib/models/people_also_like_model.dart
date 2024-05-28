class PeopleAlsoLikeModel {
  final int id;
  final String title;
  final String location;
  final String description;
  final int day;
  final String image;
  final int price;
  bool isFavorite;
  bool isSelected;

  PeopleAlsoLikeModel(
      {required this.id,
      required this.title,
      required this.location,
      required this.description,
      required this.day,
      required this.image,
      required this.price,
      required this.isFavorite,
      required this.isSelected});


  static List<PeopleAlsoLikeModel> peopleAlsoLikeModeList = [
    PeopleAlsoLikeModel(
        id: 0,
        title: "Eiffel Tower",
        location: "Paris",
        image: "images/ic_alam6.jpg",
        description:
            'Menara Eiffel, sebuah ikon yang megah dan tak terbantahkan dari keindahan arsitektur, berdiri sebagai simbol kemegahan Kota Paris, Prancis. Didesain oleh insinyur Gustave Eiffel dan selesai dibangun pada tahun 1889, menara ini memukau pengunjung dengan struktur besi yang mengagumkan, menjulang setinggi 324 meter. Terletak di Champ de Mars, menara ini menawarkan pemandangan spektakuler Kota Cahaya yang memikat, dengan Sungai Seine membelah Paris di bawahnya. Di malam hari, Menara Eiffel menyala dengan gemerlap ribuan lampu yang memberikan kilauan romantis dan memperkuat keindahan malam Paris. Sebagai pusat wisata yang tak terbantahkan, menara ini tak hanya menciptakan kenangan tak terlupakan bagi pengunjungnya, tetapi juga mewakili keajaiban teknologi dan keindahan yang abadi dalam sejarah arsitektur dunia.',
        day: 5,
        price: 756000,
        isFavorite: false,
        isSelected: true),
    PeopleAlsoLikeModel(
        id: 1,
        title: "Punti Kayu",
        location: "Palembang",
        image: "images/ic_alam7.jpg",
        description:
            'Punti Kayu adalah sebuah kawasan pelestarian alam yang dimanfaatkan untuk kegiatan pariwisata alam dan rekreasi di Palembang, Sumatera Selatan . Terletak di tengah kota Palembang - tepatnya di kawasan Km.7 Palembang, Punti Kayu menjadi tempat liburan favorit yang ramai dikunjungi warga kota Palembang khususnya pada akhir pekan dan hari-hari libur. Kawasan ini dilengkapi dengan fasilitas flying fox, taman bermain, miniatur 7 keajaiban dunia, danau, waterpark, dan berbagai hiburan lainnya.',
        day: 7,
        price: 50000,
        isFavorite: false,
        isSelected: true),
    PeopleAlsoLikeModel(
        id: 2,
        title: "Gunung Bromo",
        location: "Probolinggo",
        image: "images/ic_alam5.jpg",
        description:
            'Gunung Bromo adalah salah satu destinasi wisata alam yang paling menakjubkan di Indonesia. Terletak di Taman Nasional Bromo Tengger Semeru, gunung ini menawarkan pemandangan luar biasa yang mencakup gunung berapi aktif, lautan pasir, dan pemandangan pegunungan yang megah.',
        day: 9,
        price: 99000,
        isFavorite: false,
        isSelected: true),
    PeopleAlsoLikeModel(
        id: 3,
        title: "Tembok Besar Cina",
        location: "Tiongkok",
        image: "images/ic_alam4.jpg",
        description:
            'Tembok Besar China, suatu keajaiban arsitektur yang melintasi perbukitan dan dataran di utara Tiongkok, menghadirkan pesona sejarah yang memukau. Dibangun selama berabad-abad untuk melindungi kerajaan dari invasi dan serangan, Tembok Besar China membentang sepanjang ribuan kilometer dengan menampilkan kemegahan konstruksi batu dan bata. Pemandangan alam yang indah, seperti pegunungan dan lembah, melengkapi perjalanan sepanjang tembok ini, menciptakan pengalaman yang tak terlupakan. Dari menara penjaga hingga benteng bersejarah, setiap bagian tembok mencerminkan keahlian teknis dan ketahanan yang luar biasa. Hari ini, Tembok Besar China menjadi destinasi wisata yang mengagumkan, membiarkan pengunjung menyelami warisan kuno Tiongkok sambil menikmati panorama luar biasa yang disajikan oleh struktur megah ini.',
        day: 3,
        price: 321000,
        isFavorite: false,
        isSelected: true),
  ];

    static List<PeopleAlsoLikeModel> peopleAlsoLikeModeList1 = [
  PeopleAlsoLikeModel(
    id: 4,
    title: 'Danau Moraine',
    location: 'Kanada',
    description:
    'Danau Moraine, yang terletak di Taman Nasional Banff, Alberta, Kanada, adalah salah satu destinasi wisata alam paling menakjubkan di dunia. Danau ini dikenal karena keindahan alamnya yang luar biasa, airnya yang jernih, dan latar belakangnya yang megah, dengan Puncak Sepuluh Terkenal di Rocky Mountains sebagai latar belakangnya.',
    day: 3,
    price: 321000,
    image: 'images/ic_alam.jpg',
    isFavorite: false, 
    isSelected: true,
  ),
  PeopleAlsoLikeModel(
    id: 5,
    title: 'Gunung Matterhorn',
    location: 'Swiss',
    description:
        'Gunung Matterhorn, yang terletak di Alpen Swiss-Italia, adalah salah satu ikon alam paling terkenal di dunia. Dikenal karena puncaknya yang menyerupai piramida dan keindahan alam sekitarnya, Matterhorn menjadi daya tarik utama bagi para petualang, pendaki gunung, dan pecinta alam.',
    image: 'images/ic_alam2.jpg',
    day: 3,
    price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 6,
    title: 'Raja Ampat',
    location: 'Papua Barat',
    description:
        'Raja Ampat adalah destinasi wisata yang sangat terkenal di Indonesia dan diakui secara internasional sebagai salah satu surga bagi penyelam dan pecinta alam. Terletak di ujung barat laut Papua, Raja Ampat merupakan kelompok kepulauan yang terdiri dari lebih dari 1.500 pulau kecil yang tersebar di sekitar Laut Cenderawasih. Destinasi ini menawarkan keindahan alam bawah laut yang luar biasa, terumbu karang yang subur, dan keanekaragaman hayati laut yang kaya.',
    image: 'images/ic_alam3.jpg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 7,
    title: 'Tembok Besar Tiongkok',
    location: 'Tiongkok',
    description:
        'Tembok Besar Tiongkok, sebuah keajaiban arsitektur yang luar biasa, menawarkan pengalaman bersejarah dan pemandangan alam yang menakjubkan. Dalam konteks tempat wisata, Tembok Besar Tiongkok memikat wisatawan dengan keindahan alam sekitarnya dan keberadaannya yang kaya akan sejarah.',
    image: 'images/ic_alam4.jpg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 2,
    title: 'Gunung Bromo',
    location: 'Daerah Istimewa Yogyakarta',

    description:
        'Gunung Bromo adalah salah satu destinasi wisata alam yang paling menakjubkan di Indonesia. Terletak di Taman Nasional Bromo Tengger Semeru, gunung ini menawarkan pemandangan luar biasa yang mencakup gunung berapi aktif, lautan pasir, dan pemandangan pegunungan yang megah.',
    image: 'images/ic_alam5.jpg',
    day: 3,
        price: 321000,
    
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 0,
  title: 'Menara Eiffel',
    location: 'Paris',
    
    description:
        'Menara Eiffel, dengan arsitektur ikoniknya yang dirancang oleh insinyur Gustave Eiffel, menjadi daya tarik utama di Paris, Prancis. Dengan ketinggian mencapai sekitar 324 meter, menara ini memancarkan kemegahan dan keanggunan, menawarkan pengunjung pemandangan yang luar biasa dari tiga tingkat observasi yang berbeda. Menara Eiffel juga terkenal sebagai tempat romantis yang sering dipilih oleh pasangan untuk momen kencan atau pernikahan mereka. Di samping fasilitas seperti restoran, toko suvenir, dan ruang pameran, pengunjung dapat memilih naik tangga atau menggunakan lift untuk mencapai tingkat observasi dan merasakan keunikan desain rangka logam yang transparan dan indah.',
   
    image: 'images/ic_alam6.jpg',
   day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 1,
    title: 'Punti Kayu',
    location: 'Palembang, Sumatera Selatan',

    description:
        'Puncak Punti Kayu adalah destinasi wisata yang menakjubkan di kota Palembang, Sumatera Selatan. Terletak di ketinggian, Punti Kayu menawarkan pengunjung pemandangan alam yang memukau dan udara segar yang menyegarkan. Salah satu daya tarik utamanya adalah Taman Punti Kayu, sebuah taman kota yang luas dan indah yang dikelilingi oleh pepohonan hijau yang rindang. Di dalam taman, pengunjung dapat menikmati berbagai fasilitas rekreasi seperti kolam renang, taman bermain anak, dan lapangan olahraga. Keberadaan jembatan gantung di atas danau kecil menambah kesan romantis dan menarik bagi para pengunjung.Selain itu, Punti Kayu juga dikenal dengan Pusat Edukasi Satwa dan Alam, tempat yang ideal untuk belajar mengenai berbagai jenis fauna dan flora. Pengunjung dapat melihat beragam spesies binatang, mulai dari burung hingga reptil, dan memahami pentingnya konservasi alam. Tak hanya itu, area ini sering digunakan sebagai lokasi berbagai kegiatan seni, budaya, dan edukatif, sehingga menambah nilai tambah sebagai tempat wisata yang multifungsi. Dengan suasana yang tenang dan sejuk, Puncak Punti Kayu menjadi destinasi yang cocok untuk bersantai, bersama keluarga, atau sekadar melepas penat dari kesibukan kota.',
    image: 'images/ic_alam7.jpg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 11,
    title: 'Danau Toba',
    location: 'Sumatera Utara',
    description:
        'Danau Toba adalah danau alami terbesar di Indonesia dan juga merupakan danau vulkanik terbesar di dunia. Danau ini terbentuk oleh letusan gunung berapi raksasa yang kemudian membentuk kaldera besar, dengan pulau Samosir di tengahnya. Terletak di provinsi Sumatra Utara, Danau Toba menawarkan pemandangan alam yang indah, udara sejuk pegunungan, dan keanekaragaman budaya Batak.',
    
    image: 'images/ic_alam9.jpeg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 12,
    title: 'Pantai Pink',
    location: 'Lombok',
    
    description:
        'Selamat datang di Pantai Pink, keajaiban alam dengan pasir merah muda yang memukau. Rasakan keindahan uniknya dengan ombak lembut, air laut biru jernih, dan pemandangan matahari terbenam yang spektakuler. Nikmati aktivitas seru, kuliner lokal lezat, dan kenangan tak terlupakan di destinasi wisata ini. Pantai Pink, tempat di mana kecantikan alam dan ketenangan bersatu dalam satu pengalaman liburan.',
   
    image: 'images/ic_alam10.jpg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 13,
    title: 'Pantai Sanur',
    location: 'Bali',
   
    description:
        'Pantai Sanur, terletak di pesisir tenggara pulau Bali, Indonesia, adalah sebuah destinasi wisata yang memukau dengan keindahan alamnya yang menakjubkan. Dengan pasir putihnya yang lembut, air laut yang jernih, dan pohon-pohon kelapa yang menjulang, Pantai Sanur menawarkan pengalaman santai yang sempurna bagi para pengunjung. Terkenal sebagai salah satu tempat terbaik untuk menikmati matahari terbit, pantai ini memancarkan pesona keindahan yang romantis. Selain itu, suasana tenang dan kegiatan air seperti snorkeling dan selancar menambah daya tarik bagi para wisatawan. Dengan deretan kafe dan restoran yang menghadap laut, Pantai Sanur tidak hanya memanjakan mata dengan pemandangan spektakuler, tetapi juga menyajikan pengalaman kuliner yang menggoda selera. Tempat ini tidak hanya menjadi tempat yang cocok untuk bersantai, tetapi juga menggambarkan pesona Bali yang eksotis dan memukau.',
   
    image: 'images/ic_alam11.jpg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 14,
    title: 'Gunung Everest',
    location: '',
    description:
        'Gunung Everest, yang terletak di Pegunungan Himalaya, merupakan daya tarik wisata alam yang penuh tantangan dan keindahan alam yang menakjubkan. Dengan ketinggian mencapai 8.848 meter di atas permukaan laut, Everest menjadi puncak tertinggi di dunia, menarik para pendaki gunung dari seluruh dunia untuk menaklukkan puncaknya. Selain pesona alam yang memukau, pengunjung juga dapat merasakan budaya dan kehidupan lokal Sherpa yang unik di sekitar daerah ini. Perjalanan menuju Everest Base Camp memberikan pengalaman mendalam, melalui pemandangan pegunungan yang megah, lembah hijau yang subur, dan perkampungan tradisional. Everest tidak hanya menantang fisik, tetapi juga menyajikan pengalaman spiritual dan petualangan yang luar biasa bagi mereka yang mencari ketangguhan dan keindahan alam yang tak tertandingi.',
    image: 'images/ic_alam12.jpg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 15,
    title: 'Gunung Fuji',
    location: 'Tokyo, Jepang',
    description:
        'Gunung Fuji, yang terletak di Honshu, Jepang, menjadi daya tarik utama sebagai ikon alam dan budaya negara tersebut. Dengan ketinggian 3.776 meter, Fuji merupakan gunung tertinggi di Jepang dan sering dianggap sebagai simbol keindahan dan ketenangan. Puncaknya yang berbentuk kerucut sempurna selalu ditutupi oleh salju di musim dingin, menciptakan pemandangan yang menakjubkan. Ribuan wisatawan setiap tahunnya mendaki Fuji selama musim panas saat jalur pendakian dibuka. Selain pengalaman mendaki, kawasan sekitar Gunung Fuji menawarkan taman dan danau yang indah, seperti Danau Kawaguchi, memberikan suasana yang damai dan memikat bagi para pengunjung. Fuji juga memiliki nilai budaya yang tinggi, dengan kuil-kuil dan festival-festival lokal yang menambah daya tarik bagi wisatawan yang mencari pengalaman yang mendalam di Jepang.',
    image: 'images/ic_alam13.jpg',
day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
  PeopleAlsoLikeModel(
    id: 16,
    title: 'Danau Kelimutu',
    location: 'Sumatera Utara',
    description:
        'Danau Kelimutu, terletak di Pulau Flores, Indonesia, menawarkan pesona alam yang unik dan memikat. Keistimewaan utama danau ini terletak pada tiga kawahnya yang menampung air berwarna-warni, yang dapat berubah-ubah seiring waktu. Warna-warna yang paling umum dikenal adalah putih, merah, dan biru. Terletak di ketinggian sekitar 1.600 meter di atas permukaan laut, danau ini dikelilingi oleh pemandangan pegunungan yang hijau dan hutan tropis yang memukau. Perjalanan menuju Danau Kelimutu sering melibatkan pendakian dan perjalanan melalui pedesaan yang indah, memberikan pengalaman yang tak terlupakan bagi para pengunjung. Selain keindahan alamnya, situs ini juga memiliki nilai budaya yang tinggi karena dianggap sebagai tempat sakral oleh masyarakat lokal. Danau Kelimutu menjadi destinasi yang menarik bagi mereka yang mencari keajaiban alam yang unik dan perpaduan antara keindahan alam dan warisan budaya.',
    image: 'images/ic_alam14.jpg',
    day: 3,
        price: 321000,
    isFavorite: false,
    isSelected: true
  ),
];

static List<PeopleAlsoLikeModel> places = [
  PeopleAlsoLikeModel(
    id: 6,
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Raja Ampat",
      location: "Papua, Indonesia",
      image: "images/ic_alam3.jpg",
      description:
          "Raja Ampat adalah destinasi wisata yang sangat terkenal di Indonesia dan diakui secara internasional sebagai salah satu surga bagi penyelam dan pecinta alam. Terletak di ujung barat laut Papua, Raja Ampat merupakan kelompok kepulauan yang terdiri dari lebih dari 1.500 pulau kecil yang tersebar di sekitar Laut Cenderawasih. Destinasi ini menawarkan keindahan alam bawah laut yang luar biasa, terumbu karang yang subur, dan keanekaragaman hayati laut yang kaya.",
      price: 320000),
  PeopleAlsoLikeModel(
    id: 12,
     day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Pantai Pink",
      location: "Lombok, Indonesia",
      image: "images/ic_alam10.jpg",
      description:
          "Selamat datang di Pantai Pink, keajaiban alam dengan pasir merah muda yang memukau. Rasakan keindahan uniknya dengan ombak lembut, air laut biru jernih, dan pemandangan matahari terbenam yang spektakuler. Nikmati aktivitas seru, kuliner lokal lezat, dan kenangan tak terlupakan di destinasi wisata ini. Pantai Pink, tempat di mana kecantikan alam dan ketenangan bersatu dalam satu pengalaman liburan.",
      price: 262000),
  PeopleAlsoLikeModel(
    id: 13,
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Pantai Sanur",
      location: "Bali, Indonesia",
      image: "images/ic_alam11.jpg",
      description:
          "Pantai Sanur, terletak di pesisir tenggara pulau Bali, Indonesia, adalah sebuah destinasi wisata yang memukau dengan keindahan alamnya yang menakjubkan. Dengan pasir putihnya yang lembut, air laut yang jernih, dan pohon-pohon kelapa yang menjulang, Pantai Sanur menawarkan pengalaman santai yang sempurna bagi para pengunjung. Terkenal sebagai salah satu tempat terbaik untuk menikmati matahari terbit, pantai ini memancarkan pesona keindahan yang romantis. Selain itu, suasana tenang dan kegiatan air seperti snorkeling dan selancar menambah daya tarik bagi para wisatawan. Dengan deretan kafe dan restoran yang menghadap laut, Pantai Sanur tidak hanya memanjakan mata dengan pemandangan spektakuler, tetapi juga menyajikan pengalaman kuliner yang menggoda selera. Tempat ini tidak hanya menjadi tempat yang cocok untuk bersantai, tetapi juga menggambarkan pesona Bali yang eksotis dan memukau.",
      price: 150000)
];
static List<PeopleAlsoLikeModel> inspiration = [
  PeopleAlsoLikeModel(
    id: 2,
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Gunung Bromo",
      location: "Probolinggo, Indonesia",
      image: "images/ic_alam5.jpg",
      description:
          "Gunung Bromo adalah salah satu destinasi wisata alam yang paling menakjubkan di Indonesia. Terletak di Taman Nasional Bromo Tengger Semeru, gunung ini menawarkan pemandangan luar biasa yang mencakup gunung berapi aktif, lautan pasir, dan pemandangan pegunungan yang megah.",
      price: 99000),
  PeopleAlsoLikeModel(
    id: 14,
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Gunung Everest",
      location: "Sagarmatha, Nepal",
      image: "images/ic_alam12.jpg",
      description:
          "Gunung Everest, yang terletak di Pegunungan Himalaya, merupakan daya tarik wisata alam yang penuh tantangan dan keindahan alam yang menakjubkan. Dengan ketinggian mencapai 8.848 meter di atas permukaan laut, Everest menjadi puncak tertinggi di dunia, menarik para pendaki gunung dari seluruh dunia untuk menaklukkan puncaknya. Selain pesona alam yang memukau, pengunjung juga dapat merasakan budaya dan kehidupan lokal Sherpa yang unik di sekitar daerah ini. Perjalanan menuju Everest Base Camp memberikan pengalaman mendalam, melalui pemandangan pegunungan yang megah, lembah hijau yang subur, dan perkampungan tradisional. Everest tidak hanya menantang fisik, tetapi juga menyajikan pengalaman spiritual dan petualangan yang luar biasa bagi mereka yang mencari ketangguhan dan keindahan alam yang tak tertandingi.",
      price: 510000),
  PeopleAlsoLikeModel(
    id: 15,
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Gunung Fuji",
      location: "Tokyo, Jepang",
      image: "images/ic_alam13.jpg",
      description:
          "Gunung Fuji, yang terletak di Honshu, Jepang, menjadi daya tarik utama sebagai ikon alam dan budaya negara tersebut. Dengan ketinggian 3.776 meter, Fuji merupakan gunung tertinggi di Jepang dan sering dianggap sebagai simbol keindahan dan ketenangan. Puncaknya yang berbentuk kerucut sempurna selalu ditutupi oleh salju di musim dingin, menciptakan pemandangan yang menakjubkan. Ribuan wisatawan setiap tahunnya mendaki Fuji selama musim panas saat jalur pendakian dibuka. Selain pengalaman mendaki, kawasan sekitar Gunung Fuji menawarkan taman dan danau yang indah, seperti Danau Kawaguchi, memberikan suasana yang damai dan memikat bagi para pengunjung. Fuji juga memiliki nilai budaya yang tinggi, dengan kuil-kuil dan festival-festival lokal yang menambah daya tarik bagi wisatawan yang mencari pengalaman yang mendalam di Jepang.",
      price: 450000),
  PeopleAlsoLikeModel(
    id: 5, 
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Gunung Matterhorn",
      location: "Alpine, Swiss",
      image: "images/ic_alam2.jpg",
      description:
          "Gunung Matterhorn, yang terletak di Alpen Swiss-Italia, adalah salah satu ikon alam paling terkenal di dunia. Dikenal karena puncaknya yang menyerupai piramida dan keindahan alam sekitarnya, Matterhorn menjadi daya tarik utama bagi para petualang, pendaki gunung, dan pecinta alam.",
      price: 756000),
];
static List<PeopleAlsoLikeModel> popular = [
  PeopleAlsoLikeModel(
    id: 4, 
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Danau Moraine",
      location: "Alberta, Kanada",
      image: "images/ic_alam.jpg",
      description:
          "Danau Moraine, yang terletak di Taman Nasional Banff, Alberta, Kanada, adalah salah satu destinasi wisata alam paling menakjubkan di dunia. Danau ini dikenal karena keindahan alamnya yang luar biasa, airnya yang jernih, dan latar belakangnya yang megah, dengan Puncak Sepuluh Terkenal di Rocky Mountains sebagai latar belakangnya.",
      price: 720000),
  PeopleAlsoLikeModel(
    id: 11, 
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Danau Toba",
      location: "Pulau Samosir, Indonesia",
      image: "images/ic_alam9.jpeg",
      description:
          "Danau Toba adalah danau alami terbesar di Indonesia dan juga merupakan danau vulkanik terbesar di dunia. Danau ini terbentuk oleh letusan gunung berapi raksasa yang kemudian membentuk kaldera besar, dengan pulau Samosir di tengahnya. Terletak di provinsi Sumatra Utara, Danau Toba menawarkan pemandangan alam yang indah, udara sejuk pegunungan, dan keanekaragaman budaya Batak.",
      price: 140000),
  PeopleAlsoLikeModel(
    id: 16, 
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Danau Kelimutu",
      location: "Ende, Indonesia",
      image: "images/ic_alam14.jpg",
      description:
          "Danau Kelimutu, terletak di Pulau Flores, Indonesia, menawarkan pesona alam yang unik dan memikat. Keistimewaan utama danau ini terletak pada tiga kawahnya yang menampung air berwarna-warni, yang dapat berubah-ubah seiring waktu. Warna-warna yang paling umum dikenal adalah putih, merah, dan biru. Terletak di ketinggian sekitar 1.600 meter di atas permukaan laut, danau ini dikelilingi oleh pemandangan pegunungan yang hijau dan hutan tropis yang memukau. Perjalanan menuju Danau Kelimutu sering melibatkan pendakian dan perjalanan melalui pedesaan yang indah, memberikan pengalaman yang tak terlupakan bagi para pengunjung. Selain keindahan alamnya, situs ini juga memiliki nilai budaya yang tinggi karena dianggap sebagai tempat sakral oleh masyarakat lokal. Danau Kelimutu menjadi destinasi yang menarik bagi mereka yang mencari keajaiban alam yang unik dan perpaduan antara keindahan alam dan warisan budaya.",
      price: 340000),
];
static List<PeopleAlsoLikeModel> perkotaan = [
  PeopleAlsoLikeModel(
    id: 0, 
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Eiffel Tower",
      location: "Paris",
      image: "images/ic_alam6.jpg",
      description:
          "Menara Eiffel, sebuah ikon yang megah dan tak terbantahkan dari keindahan arsitektur, berdiri sebagai simbol kemegahan Kota Paris, Prancis. Didesain oleh insinyur Gustave Eiffel dan selesai dibangun pada tahun 1889, menara ini memukau pengunjung dengan struktur besi yang mengagumkan, menjulang setinggi 324 meter. Terletak di Champ de Mars, menara ini menawarkan pemandangan spektakuler Kota Cahaya yang memikat, dengan Sungai Seine membelah Paris di bawahnya. Di malam hari, Menara Eiffel menyala dengan gemerlap ribuan lampu yang memberikan kilauan romantis dan memperkuat keindahan malam Paris. Sebagai pusat wisata yang tak terbantahkan, menara ini tak hanya menciptakan kenangan tak terlupakan bagi pengunjungnya, tetapi juga mewakili keajaiban teknologi dan keindahan yang abadi dalam sejarah arsitektur dunia.",
      price: 756000),
  PeopleAlsoLikeModel(
    id: 28, 
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Tembok Besar China",
      location: "Tiongkok",
      image: "images/ic_alam4.jpg",
      description:
          "Tembok Besar Tiongkok, sebuah keajaiban arsitektur yang luar biasa, menawarkan pengalaman bersejarah dan pemandangan alam yang menakjubkan. Dalam konteks tempat wisata, Tembok Besar Tiongkok memikat wisatawan dengan keindahan alam sekitarnya dan keberadaannya yang kaya akan sejarah.",
      price: 321000),
  PeopleAlsoLikeModel(
    id: 29,
    day: 3,
    isFavorite: false,
    isSelected: true,
      title: "Menara Pisa",
      location: "Italia",
      image: "images/ic_alam15.jpg",
      description:
          "Menara Pisa adalah sebuah menara lonceng yang terkenal karena kemiringannya yang mencolok. Dibangun pada abad ke-12, menara ini adalah bagian dari kompleks Katedral Pisa. Konstruksi menara dimulai pada tahun 1173 oleh arsitek Bonanno Pisano dan terus berlanjut selama dua abad karena terhenti beberapa kali akibat peperangan dan ketidakstabilan tanah. Menara ini memiliki ketinggian sekitar 56 meter (183 kaki) dan terdiri dari delapan tingkat. Kemiringannya, yang disebabkan oleh tanah yang tidak stabil di bawahnya, membuatnya menjadi salah satu struktur arsitektur paling unik di dunia. Meskipun dibangun dengan tujuan menjadi menara lonceng, Menara Pisa segera menjadi terkenal karena kemiringannya yang menarik perhatian wisatawan dari seluruh dunia. Wisatawan dapat mengunjungi Lapangan Keajaiban di Pisa untuk melihat Menara Pisa bersama dengan Katedral Pisa, Bapisteri, dan Camposanto Monumentale yang merupakan bagian dari kompleks tersebut. Lapangan ini telah menjadi Situs Warisan Dunia UNESCO sejak tahun 1987. Para pengunjung dapat naik ke Menara Pisa dan menikmati pemandangan kota Pisa dari ketinggian yang menakjubkan. Meskipun kemiringannya terus diawasi dan diperbaiki untuk menjaga kestabilan, Menara Pisa tetap menjadi simbol arsitektur yang unik dan menarik bagi ",
      price: 340000),
];

  static List<PeopleAlsoLikeModel> getFavoriteWisata() {
    List<PeopleAlsoLikeModel> _travelList =
        PeopleAlsoLikeModel.peopleAlsoLikeModeList+
        PeopleAlsoLikeModel.peopleAlsoLikeModeList1+
        PeopleAlsoLikeModel.inspiration+
        PeopleAlsoLikeModel.perkotaan+
        PeopleAlsoLikeModel.places+
        PeopleAlsoLikeModel.popular;

    return _travelList.where((element) => element.isFavorite == true).toList();
  }
}


