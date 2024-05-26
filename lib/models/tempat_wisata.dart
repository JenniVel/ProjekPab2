class Tempat {
  final int id;
  final String title;
  final String location;
  final String star;
  final String description;
  final String type;
  final String imageAsset;
  final List<String> imageUrls;
  bool isFavorite;
  bool isSelected;

  Tempat({
    required this.id,
    required this.title,
    required this.location,
    required this.star,
    required this.description,
    required this.type,
    required this.imageAsset,
    required this.imageUrls,
    required this.isFavorite,
    required this.isSelected
  });

//   static List<Tempat> tempatList = [
//   Tempat(
    
//     name: 'Danau Moraine',
//     location: 'Kanada',
//     star: '5',
//     description:
//         'Danau Moraine, yang terletak di Taman Nasional Banff, Alberta, Kanada, adalah salah satu destinasi wisata alam paling menakjubkan di dunia. Danau ini dikenal karena keindahan alamnya yang luar biasa, airnya yang jernih, dan latar belakangnya yang megah, dengan Puncak Sepuluh Terkenal di Rocky Mountains sebagai latar belakangnya.',
//     type: 'Danau',
//     imageAsset: 'images/ic_alam.jpg',
//     imageUrls: [
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/1_moraine_lake_pano_2019.jpg/1200px-1_moraine_lake_pano_2019.jpg',
//       'https://cdn.idntimes.com/content-images/community/2021/05/20210530-124353-329ae2b286ff7799fbbec7d4597d307a-6bdea83c8ffa992d5d7d3efd4c1f5de7.jpg',
//       'https://media.suara.com/pictures/970x544/2019/09/07/65736-wikimedia-commons-gorgo.jpg',
//       'https://img.okezone.com/content/2022/02/25/408/2553130/5-danau-tercantik-di-dunia-pesonanya-bak-serpihan-surga-nNgPMrGrv8.jpg',
//     ],
//     isFavorite: true,
//     isSelected: false
//   ),
//   Tempat(
//     name: 'Gunung Matterhorn',
//     location: 'Swiss',
//     star: '5',
//     description:
//         'Gunung Matterhorn, yang terletak di Alpen Swiss-Italia, adalah salah satu ikon alam paling terkenal di dunia. Dikenal karena puncaknya yang menyerupai piramida dan keindahan alam sekitarnya, Matterhorn menjadi daya tarik utama bagi para petualang, pendaki gunung, dan pecinta alam.',
//     type: 'Gunung',
//     imageAsset: 'images/ic_alam2.jpg',
//     imageUrls: [
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Matterhorn.jpg/1200px-Matterhorn.jpg',
//       'https://asset.kompas.com/crops/XNLURKCbG0MSS7ezurU3_Ct_1nE=/0x0:740x493/750x500/data/photo/2021/03/27/605f0a91d4c27.jpg',
//       'https://asset.kompas.com/crops/Qihpb6b0BISJJblJlRbILrES270=/0x0:739x493/750x500/data/photo/2021/03/27/605f0a3b6e123.jpg',
//       'https://bafageh.com/uploads/cms/images/1683707566_Screenshot%202023-05-10%20152748.png',
//     ],
//    isFavorite: true,
//     isSelected: false
//   ),
//   Tempat(
//     name: 'Raja Ampat',
//     location: 'Papua Barat',
//     star: '5',
//     description:
//         'Raja Ampat adalah destinasi wisata yang sangat terkenal di Indonesia dan diakui secara internasional sebagai salah satu surga bagi penyelam dan pecinta alam. Terletak di ujung barat laut Papua, Raja Ampat merupakan kelompok kepulauan yang terdiri dari lebih dari 1.500 pulau kecil yang tersebar di sekitar Laut Cenderawasih. Destinasi ini menawarkan keindahan alam bawah laut yang luar biasa, terumbu karang yang subur, dan keanekaragaman hayati laut yang kaya.',
//     type: 'Laut',
//     imageAsset: 'images/ic_alam3.jpg',
//     imageUrls: [
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Raja_Ampat%2C_Mutiara_Indah_di_Timur_Indonesia.jpg/375px-Raja_Ampat%2C_Mutiara_Indah_di_Timur_Indonesia.jpg',
//       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/13/Lokasi_Papua_Barat_Daya_Kabupaten_Raja_Ampat.svg/1024px-Lokasi_Papua_Barat_Daya_Kabupaten_Raja_Ampat.svg.png',
//       'https://upload.wikimedia.org/wikipedia/id/d/d5/Dermaga_Apung_Waisai_Raja_Ampat.JPG',
//       'https://upload.wikimedia.org/wikipedia/commons/d/d4/Raja_Ampat_yuhuu.jpg',
//     ],
//     isFavorite: true,
//     isSelected: false
//   ),
//   Tempat(
//     name: 'Tembok Besar Tiongkok',
//     location: 'Tiongkok',
//     star: '5',
//     description:
//         'Tembok Besar Tiongkok, sebuah keajaiban arsitektur yang luar biasa, menawarkan pengalaman bersejarah dan pemandangan alam yang menakjubkan. Dalam konteks tempat wisata, Tembok Besar Tiongkok memikat wisatawan dengan keindahan alam sekitarnya dan keberadaannya yang kaya akan sejarah.',
//     type: 'Sejarah',
//     imageAsset: 'images/ic_alam4.jpg',
//     imageUrls: [
//       'https://mmc.tirto.id/image/2022/01/11/istock-598959570_ratio-16x9.jpg',
//       'https://asset.kompas.com/crops/drOaN4jx88vo1GMmDIt8u2xeLgA=/0x0:500x333/750x500/data/photo/2019/12/21/5dfda9e1d7243.jpg',
//       'https://asset.kompas.com/crops/OxqlRru-JTEYAR8kA_INfojA0Nk=/0x0:1000x667/750x500/data/photo/2020/03/27/5e7db07d1c82d.jpg',
//       'https://asset.kompas.com/crops/drOaN4jx88vo1GMmDIt8u2xeLgA=/0x0:500x333/750x500/data/photo/2019/12/21/5dfda9e1d7243.jpg',
//     ],
//     isFavorite: true,
//     isSelected: false
//   ),
//   Tempat(
//     name: 'Gunung Bromo',
//     location: 'Daerah Istimewa Yogyakarta',
//     star: '5',
//     description:
//         'Gunung Bromo adalah salah satu destinasi wisata alam yang paling menakjubkan di Indonesia. Terletak di Taman Nasional Bromo Tengger Semeru, gunung ini menawarkan pemandangan luar biasa yang mencakup gunung berapi aktif, lautan pasir, dan pemandangan pegunungan yang megah.',
//     type: 'Gunung',
//     imageAsset: 'images/ic_alam5.jpg',
//     imageUrls: [
//       'https://asset.kompas.com/crops/OD9itl1d8QHvxgLLaKN3u13KhYw=/1x0:1000x666/750x500/data/photo/2023/02/28/63fdb9789cf09.jpg',
//       'https://nahwatravel.co.id/wp-content/uploads/2022/05/Gunung-Bromo.jpg',
//       'https://static.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/p1/04/2023/09/08/Gunung-Bromo-1952636682.jpg',
//       'https://cdn.antaranews.com/cache/1200x800/2020/06/29/gunung-bromo-covid.jpg',
//     ],
//    isFavorite: true,
//     isSelected: false
//   ),
//   Tempat(
//     name: 'Menara Eiffel',
//     location: 'Paris',
//     star: '5',
//     description:
//         'Menara Eiffel, dengan arsitektur ikoniknya yang dirancang oleh insinyur Gustave Eiffel, menjadi daya tarik utama di Paris, Prancis. Dengan ketinggian mencapai sekitar 324 meter, menara ini memancarkan kemegahan dan keanggunan, menawarkan pengunjung pemandangan yang luar biasa dari tiga tingkat observasi yang berbeda. Menara Eiffel juga terkenal sebagai tempat romantis yang sering dipilih oleh pasangan untuk momen kencan atau pernikahan mereka. Di samping fasilitas seperti restoran, toko suvenir, dan ruang pameran, pengunjung dapat memilih naik tangga atau menggunakan lift untuk mencapai tingkat observasi dan merasakan keunikan desain rangka logam yang transparan dan indah.',
//     type: 'Sejarah',
//     imageAsset: 'images/ic_alam6.jpg',
//     imageUrls: [
//       'https://imgx.sonora.id/crop/0x0:0x0/x/photo/2021/11/08/eifeeljpg-20211108124311.jpg',
//       'https://statik.tempo.co/data/2020/03/10/id_922054/922054_720.jpg',
//       'https://cdns.klimg.com/dream.co.id/resized/640x320/news/2019/09/23/118161/inilah-alasannya-tempat-wisata-menara-eiffel-tidak-boleh-difoto-190923o.jpg',
//       'https://res.klook.com/images/fl_lossy.progressive,q_65/c_fill,w_1620,h_1080,f_auto/w_80,x_15,y_15,g_south_west,l_Klook_water_br_trans_yhcmh3/activities/szp84mwxnb2elekivine/MenaraEiffel,TingkatKeduaatauAksesPuncakdiParisJoinInTour-KlookIndonesia.jpg',
//     ],
//     isFavorite: true,
//     isSelected: false
//   ),
//   Tempat(
//     name: 'Punti Kayu',
//     location: 'Palembang, Sumatera Selatan',
//     star: '5',
//     description:
//         'Puncak Punti Kayu adalah destinasi wisata yang menakjubkan di kota Palembang, Sumatera Selatan. Terletak di ketinggian, Punti Kayu menawarkan pengunjung pemandangan alam yang memukau dan udara segar yang menyegarkan. Salah satu daya tarik utamanya adalah Taman Punti Kayu, sebuah taman kota yang luas dan indah yang dikelilingi oleh pepohonan hijau yang rindang. Di dalam taman, pengunjung dapat menikmati berbagai fasilitas rekreasi seperti kolam renang, taman bermain anak, dan lapangan olahraga. Keberadaan jembatan gantung di atas danau kecil menambah kesan romantis dan menarik bagi para pengunjung.Selain itu, Punti Kayu juga dikenal dengan Pusat Edukasi Satwa dan Alam, tempat yang ideal untuk belajar mengenai berbagai jenis fauna dan flora. Pengunjung dapat melihat beragam spesies binatang, mulai dari burung hingga reptil, dan memahami pentingnya konservasi alam. Tak hanya itu, area ini sering digunakan sebagai lokasi berbagai kegiatan seni, budaya, dan edukatif, sehingga menambah nilai tambah sebagai tempat wisata yang multifungsi. Dengan suasana yang tenang dan sejuk, Puncak Punti Kayu menjadi destinasi yang cocok untuk bersantai, bersama keluarga, atau sekadar melepas penat dari kesibukan kota.',
//     type: 'Hutan',
//     imageAsset: 'images/ic_alam7.jpg',
//     imageUrls: [
//       'https://indonesiakaya.com/wp-content/uploads/2020/10/Punti_Kayu_Hutan_Wisata_di_Tengah_Kota.jpg',
//       'https://i2.wp.com/travelspromo.com/wp-content/uploads/2019/05/Punti-Kayu-Palembang-Michael-Kesuma.jpg',
//       'https://wisata-id.com/wp-content/uploads/2023/01/pintu2.jpeg',
//       'https://picture.triptrus.com/image/2017/08/hutan-wisata-punti-kayu.jpeg',
//     ],
//     isFavorite: true,
//     isSelected: false
//   ),
//   Tempat(
//     name: 'Danau Toba',
//     location: 'Sumatera Utara',
//     star: '5',
//     description:
//         'Danau Toba adalah danau alami terbesar di Indonesia dan juga merupakan danau vulkanik terbesar di dunia. Danau ini terbentuk oleh letusan gunung berapi raksasa yang kemudian membentuk kaldera besar, dengan pulau Samosir di tengahnya. Terletak di provinsi Sumatra Utara, Danau Toba menawarkan pemandangan alam yang indah, udara sejuk pegunungan, dan keanekaragaman budaya Batak.',
//     type: 'Danau',
//     imageAsset: 'images/ic_alam9.jpeg',
//     imageUrls: [
//       'https://upload.wikimedia.org/wikipedia/commons/a/ae/Indonesia_-_Lake_Toba_%2826224127503%29.jpg',
//       'https://airport.id/wp-content/uploads/2016/03/DanauToba_220316.jpg',
//       'https://asset.kompas.com/crops/PZkNa1XEcC9huIv3Gd1tHebvzIA=/0x0:780x520/1200x800/data/photo/2023/07/25/64bf6a78dfe73.jpg',
//       'https://static.promediateknologi.id/crop/0x0:0x0/750x500/webp/photo/2022/09/06/1954612222.jpg',
//     ],
//     isFavorite: true,
//     isSelected: false
//   ),
// ];

 }