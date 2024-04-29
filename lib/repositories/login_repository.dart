import 'package:fjghrd/utils/af_database.dart';
import 'package:fjghrd/utils/hasil.dart';

class LoginRepository {

  Future<Hasil> register(Map<String, String>? body) async {
    return await AFdatabase.send(
      url: "register",
      methodeRequest: MethodeRequest.post,
      body: body,
    );
  }

  Future<Hasil> login({required String email, required String password}) async {
    return await AFdatabase.send(
      url: "login",
      methodeRequest: MethodeRequest.post,
      body: { "email": email, "password": password },
    );
  }


  Future<Hasil> logout() async {
    return await AFdatabase.send(url: "logout");
  }

  // 462: On the Verge of Life and Death (2)
  //
  // Sejujurnya, dia tidak menyangka akan bertemu pria ini begitu cepat.
  //
  // ‘Aku tidak merasakan apa-apa darinya,’
  //
  // Energi pria itu terasa sama dengan alam di sekitarnya.
  //
  // Namun, kekuatan yang terpancar dari wajahnya memberitahunya bahwa dia berbeda dari orang-orang yang pernah ditemui Chun Yeowun sebelumnya.
  //
  // Raja Pedang itu kuat.
  //
  // Dan Dewa Timur, Ark Wui, juga akan mengeluarkan aroma seniman bela diri yang mendalam.
  //
  // Namun, dari pria di depannya, ada sesuatu yang terasa salah.
  //
  // “Dia sepertinya tidak punya emosi.”
  //
  // Itu hampir benar berdasarkan ekspresi pria itu.
  //
  // Bahkan hewan pun memiliki emosi, tetapi orang ini sepertinya tidak memilikinya.
  //
  // Dewa Pedang.
  //
  // “Pembunuh legendaris.”
  //
  // Beberapa cerita melekat pada penampilan singkatnya di Wulin.
  //
  // Seseorang yang datang dan bersaing dengan pendekar pedang legendaris, Pedang Iblis.
  //
  //
  // Untuk pertama kalinya sejak Chun Ma, gelar seniman bela diri terbaik telah berubah.
  //
  // Dan,
  //
  // “Dia dari masa depan.”
  //
  // Jika tebakan Chun Yeowun benar, orang ini membalikkan waktu.
  //
  // Di tengah ketegangan, Dewa Pedang membuka mulutnya.
  //
  // “Permisi sebentar.”
  //
  // “?”
  //
  // Kwang!
  //
  // Dewa Pedang melangkah maju dan sedikit bersandar ke tanah.
  //
  // Tanah bergetar seolah-olah ada gempa bumi, dan dalam sekejap, sebuah lubang dengan radius tiga kaki terbentuk di sekitar kakinya.
  //
  // Gedebuk!
  //
  // “Fiuh.”
  //
  // Dewa Pedang menghela nafas.
  //
  // Dia bertanya-tanya apa yang pria itu lakukan sampai dia merasakan energi yang familiar dari tanah.
  //
  // ‘Ini?’
  //
  // Itu adalah kekuatan dari Void Fist.
  //
  // Dewa Pedang memindai tanah dan berbicara.
  //
  // “Aku mencoba menyebarkannya di tubuhku, tapi bung, itu adalah kekuatan yang menyebalkan. Itu adalah pertama kalinya saya bertemu seseorang yang mencapai level itu dengan energi internal murni.”
  //
  // Dengan kata-kata itu, dia melirik Ark Wui, yang ada di belakangnya.
  //
  //
  // Energi menyebar ke seluruh lantai, dan meskipun ada getaran yang kuat, dia berdiri tegak.
  //
  // Seperti pohon tua yang berakar dalam.
  //
  // Dia menggelengkan kepalanya melihat pemandangan itu.
  //
  // “Ini adalah pertama kalinya sejak pendirimu aku bertemu seseorang dengan kebanggaan yang begitu kejam dan kuat. Saya suka itu.”
  //
  // Dia berbicara seolah-olah dia mengenal Chun Ma.
  //
  // Nenek moyang dari masa lalu yang jauh, lebih dari delapan ratus tahun yang lalu.
  //
  // ‘Orang ini…’
  //
  // Ada sesuatu yang lebih tidak menyenangkan daripada rasa ingin tahu.
  //
  // Prajurit sejati pertama yang diakui Chun Yeowun adalah Ark Wui.
  //
  // “… kau tidak terlihat seperti seseorang yang menyukainya.”
  //
  // Bertentangan dengan pujian pria itu, tidak ada emosi dalam suaranya.
  //
  // Mendengar itu, Chun Yeowun merasa ingin membentaknya.
  //
  // “Aku minta maaf karena kamu merasa seperti itu. Aku bisa mengerti emosimu. Setelah hidup selama bertahun-tahun, saya menjadi mati rasa secara emosional.”
  //
  // Dengan kata-kata itu, Dewa Pedang berbalik, mengangkat kepalanya, dan melihat ke langit yang mendung.
  //
  // Astaga!
  //
  // Langit gelap dan hujan turun.
  //
  // ‘Tidak?’
  //
  // Tapi Chun Yeowun tidak menyadarinya. Tetesan hujan tidak menyentuh tubuh Dewa Pedang.
  //
  // Tetesan hujan mengalir begitu alami ke segala sesuatu yang lain sehingga dia tidak menyadarinya sampai saat itu.
  //
  // “Dia tidak menolaknya.”
  //
  // Tetesan hujan memantul.
  //
  // Pria ini menggunakan energi internal secara alami seolah-olah bernafas.
  //
  // Seperti orang tua yang sedang mencari kematiannya, Dewa Pedang yang sedang melihat ke langit, perlahan-lahan menoleh dan kemudian menoleh ke arah Chun Yeowun.
  //
  //
  // “Waktu memang hal yang aneh. Dalam sepuluh tahun, sungai dan gunung akan berubah. Tapi itu bukan segalanya. Bahkan emosi pun berubah.”
  //
  // “Apa yang kamu coba katakan?”
  //
  // “Sepertinya posisi kita telah berubah. Warna-warni. Karena kau adalah Dewa Iblis dengan emosi manusia… pada saat itu, kau benar-benar Dewa Iblis, bukan, kau adalah Dewa yang sempurna.”
  //
  // Chun Yeowun mengerutkan kening.
  //
  // Dia tidak tahu apa yang pria itu bicarakan.
  //
  // Tapi mendengar apa yang dia katakan, seolah-olah pria itu mengenal Chun Yeowun sejak lama.
  //
  // Dewa Pedang berasal dari masa depan yang jauh dan kembali ke masa lalu yang jauh.
  //
  // Dia tidak memiliki koneksi ke Dewa Pedang.
  //
  // “Sejak awal, kamu bertingkah seolah kamu mengenalku, tapi ini pertama kalinya aku bertemu denganmu.”
  //
  // Terlepas dari kata-kata Chun Yeowun, Dewa Pedang melanjutkan.
  //
  // “Saya selalu bertanya-tanya bagaimana rasanya berdiri di garis yang sama dengan Anda, yang sempurna dalam segala hal. Aku ingin tahu dengan pasti.”
  //
  // “?”
  //
  // “Mungkin konyol untuk mengatakannya seperti itu. Hanya karena seekor lalat terbang di depan mata saya tidak berarti saya merasa sakit karenanya. Itu hanya hal yang menjengkelkan.”
  //
  // “Apa?”
  //
  // “Kamu akan merasakan hal yang sama seperti yang aku rasakan sekarang.”
  //
  // Ssst!
  //
  // Begitu kata-katanya selesai, Dewa Pedang, yang telah jauh, tiba-tiba mendekatinya.
  //
  // Itu benar-benar berbeda dari gerak kaki ringan yang digunakan orang lain.
  //
  //
  // Seolah-olah pria itu melompat melalui ruang angkasa.
  //
  // ‘Hanya ketika?’
  //
  // Dewa Pedang, yang mendekat, menendangnya.
  //
  // Astaga!
  //
  // Itu tampak seperti ayunan ringan, tetapi perasaan berat bergema di udara saat tendangan datang untuknya.
  //
  // Chun Yeowun dengan cepat mengangkat lengan kirinya dan memblokirnya.
  //
  // Kwang!
  //
  // “Kak!”
  //
  // Saat dia menghentikan tendangan, dia terbang mundur dan memantul di tanah.
  //
  // Namun, dia nyaris tidak berhasil memblokirnya.
  //
  // Cik!
  //
  // ‘Kekuatan yang luar biasa.’
  //
  // Meskipun Nano Suitnya sudah terpasang, kekuatan penghancurnya masih melukai tangannya, menyebabkan seluruh tubuhnya gemetar dan menjerit kesakitan.
  //
  // “Cukup bagus. Aku menendangmu dengan niat untuk mematahkan lenganmu.”
  //
  // ‘!?’
  //
  // Astaga!
  //
  // Dewa Pedang, yang entah bagaimana berhasil berada di belakang Chun Yeowun, menendang dan memukulnya.
  //
  // Chun Yeowun buru-buru menyilangkan tangannya dengan mengeluarkan energi internal.
  //
  // Kwak!
  //
  // Kekuatan destruktif yang luar biasa.
  //
  // Dua kali, tidak, dia ditendang tiga kali, dan ketiga tendangan itu memiliki kekuatan yang sama.
  //
  // Chun Yeowun mencoba membela diri, berpikir bahwa intensitas tendangannya akan berkurang.
  //
  // Gedebuk!
  //
  // Saat itulah, tubuhnya mencapai tanah saat lututnya jatuh ke tanah.
  //
  // ‘Seperti ini, kekuatanku akan terkuras…’
  //
  // Kwakwakwang!
  //
  // Tanah, yang telah digali dengan pergelangan kaki Chun Yeowun tenggelam dalam-dalam, terus bergerak lebih jauh ke bawah.
  //
  // Menetes!
  //
  // Saat ia menderita luka dalam, darah mengalir keluar dari mulut Chun Yeowun.
  //
  // Nano Suit membantu menyerap pukulan, tapi sepertinya suit itu retak.
  //
  // Ssst!
  //
  // [Tulang di kedua pergelangan tangan retak. Saya akan melakukan perbaikan sendiri.]
  //
  // Namun, karena inti dan kekuatan Nano, retakan dipulihkan dengan cepat.
  //
  // Mata Dewa Pedang berubah.
  //
  // Itu bukan karena Chun Yeowun telah memblokir serangannya dua kali berturut-turut.
  //
  // “Armornya tidak rusak?”
  //
  // Yang membingungkannya adalah bahwa Nano Suit tidak mencapai titik impas di bawah serangan.
  //
  // Biasanya, bahkan armor yang terbuat dari baja dingin akan pecah.
  //
  //
  // “Bukankah itu armor biasa? Tidak. Teknologi dari masa depan…”
  //
  // Menangis!
  //
  // Pada saat itu, panas terik naik dari tangan Chun Yeowun.
  //
  // Api hitam segera mengambil bentuk pedang.
  //
  // Lawan di depannya tidak berada pada level di mana dia bisa menghabiskan waktu untuk berpikir dan melawan.
  //
  // Pria ini adalah musuh terkuat yang pernah Chun Yeowun temui.
  //
  // “Oh. Api hitam? Berurusan dengan energi yang berbeda pada saat yang sama tentu menarik, yang belum pernah saya coba sebelumnya.”
  //
  // Tidak ada satu pun tanda kegugupan.
  //
  // Meskipun dia menyebutnya menarik, mata pria itu tetap tanpa emosi seperti biasanya.
  //
  // Chun Yeowun mengerutkan kening dan menjawab.
  //
  // “Rasakan sendiri apakah itu menarik atau tidak.”
  //
  // Begitu kata-kata itu selesai, pedang api hitam yang tak terlihat mulai menggambar lintasan api.
  //
  // Whoo!
  //
  // Itu adalah formasi pertama dari Seni Pedang Dewa Iblis, Tarian Pedang dari Gelombang Misterius.
  //
  // Ilmu pedang itu dalam bentuk gelombang yang mengamuk seolah-olah akan menelan matahari itu sendiri.
  //
  // Dalam sekejap, 24 lintasan ditarik saat pedang api hitam menuju Dewa Pedang.
  //
  // ‘!?’
  //
  // Mata Chun Yeowun berkibar.
  //
  // Bertentangan dengan harapannya bahwa Dewa Pedang juga akan membuka pedang tak terlihat, pria itu dengan ringan menangani energi internal dan memblokir pedang Chun Yeowun.
  //
  // Menangis!
  //
  // Tentu saja, itu tidak menghentikan serangan.
  //
  // Saat pedang terus mengubah lintasannya, Dewa Pedang tahu bahwa itu tidak bisa dihentikan, jadi dia mundur.
  //
  // Tatak!
  //
  // “The Blade Lord datang ke sini adalah hal yang baik. Apakah Anda mencampur Seni Ekstrim Dewa Pedang dengan Kekuatan Pedang Setan Langit?”
  //
  // Cara dia berbicara, seolah-olah pria itu menyaksikan pertarungannya melawan Blade Lord.
  //
  //
  // Chun Yeowun tidak peduli dengan kata-kata Dewa Pedang dan berkonsentrasi pada pertempuran.
  //
  // Menangis! Chachacha!
  //
  // Pada serangan yang hampir sempurna, bibir Dewa Pedang bergetar.
  //
  // Untuk pertama kalinya, dia tampaknya tertarik pada ilmu pedang, yang melebihi harapannya.
  //
  // Astaga!
  //
  // Babak kedua, yang membuat pedang membidik darah, Dewa Pedang mengulurkan tangan kirinya, yang tidak dia gunakan, dan memutuskan untuk memblokir serangan itu.
  //
  // Chachachang!
  //
  // Yang mengejutkan, dia membuka penghalang lain dengan tangan kirinya dan sepenuhnya memblokir pedang.
  //
  // Dewa Pedang berbicara saat dia melihat kabut hitam muncul dari pedang, yang diblokir oleh tangan kirinya.
  //
  // “Kau tentu tidak mengecewakanku. Anda membuat saya menggunakan kedua tangan. ”
  //
  // Pak!
  //
  // Begitu dia selesai mengucapkan kata-kata itu, pedang Dewa Pedang memotong lurus di udara.
  //
  // ‘Pedang tak terlihat?’
  //
  // Dengan peningkatan energi yang tiba-tiba, Chun Yeowun menerapkan lebih banyak energi internal ke pedang tak kasat mata yang terbuat dari api hitam dan menahannya seperti perisai.
  //
  // Cha!
  //
  // “Kuak!”
  //
  // Tata!
  //
  // Chun Yeowun terdorong oleh serangan kuat itu.
  //
  // Saat dia terus didorong lebih dari 20 langkah, retakan terjadi pada pedang tak terlihat yang terbuat dari api hitam, yang digunakan sebagai perisai.
  //
  // ‘Kotoran!’
  //
  // Pada akhirnya, dia tidak tahan dengan kekuatan Dewa Pedang.
  //
  // Itu adalah kekuatan luar biasa yang melampaui campuran gaya yang berbeda.
  //
  // Whoo! Retakan!
  //
  // Pedang tak terlihat yang terbuat dari api hitam, yang retak, akhirnya pecah, dan pedang tak terlihat Dewa Pedang mencoba merobek perut Chun Yeowun.
  //
  // Memotong!
  //
  // Suara melengking datang dari Nano Suit saat pedang itu menebasnya.
  //
  // Saat itulah hal yang menakjubkan terjadi.
  //
  // cincin!
  //
  // [Ketahanan setelan Gatelinium Nano telah rusak sebesar 9%]
  //
  // Nano Suit, yang terbuat dari bahan terkuat, retak.
  //
  // Meskipun tidak sepenuhnya terbelah, energi pada pedang Dewa Pedang telah menembus ke perutnya melalui celah-celah di setelan itu.
  //
  // Chacha!
  //
  // Karena serangan itu tidak berhenti dan energinya meresap ke dalam tubuhnya, ususnya robek.
  //
  // “Kuaaaak!”
  //
  // Chun Yeowun berteriak saat darahnya mulai mengalir keluar dari mulutnya.
  //
  // Ini adalah pertama kalinya dia menderita luka dalam yang parah.
  //
  // “Batuk…. Batuk…”
  //
  // Kekuatan inti dan penyembuhan diri Nano dengan cepat memulihkan organ yang robek, tetapi itu menyakitkan karena dia tidak bisa melepaskan energi Dewa Pedang yang meresap dari tubuhnya.
  //
  // ‘Energi bilah ini perlu dilepaskan …’
  //
  // Chun Yeowun, yang nyaris menghentikan serangan, berkonsentrasi pada energi di tubuhnya.
  //
  // Untuk mengeluarkan energi pedang yang merobek organ-organnya, jumlah energi internal yang tersisa harus dikonsumsi.
  //
  // “Kuuk!”
  //
  // Dia harus mengatasi rasa sakit itu.
  //
  // Berjalan santai menuju Chun Yeowun, kata Dewa Pedang.
  //
  // “Sekarang adalah waktu ketika saya tidak mampu untuk memperlambat.”
  //
  // Mata Chun Yeowun bergetar saat dia mengerti arti penuh di balik pria yang mengerti kata-kata kondisinya.

}
