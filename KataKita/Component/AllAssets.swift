import SwiftUI

struct AllAssets {
    static let shared = AllAssets()

    let assets: [String] = [
        "air", "alamat", "alas bedak", "alkitab", "ambulan", "anggur", "apa",
        "apel", "api", "asin", "astronot", "awas", "ayah", "ayam",
        "ayam goreng", "babi", "bagaimana", "baju", "bak mandi", "balok",
        "balon", "balon udara", "baut", "bayi", "berenang", "bantal", "batu",
        "belalang", "berat", "besar", "bidan", "bintang", "bis",
        "bola", "botol", "bowling", "buah", "buka", "buku", "bulan", "bumi",
        "bunga", "burger", "burung", "busa", "capung", "celana panjang",
        "celana pendek", "cermin kecil", "cermin", "coklat", "crayon",
        "cinta rumah", "cuci tangan", "cuci piring", "dan",
        "deodoran", "deterjen", "di", "di atas", "di bawah", "di dalam",
        "di luar", "di samping", "dingin", "dokter", "dokter bedah", "donut",
        "es krim", "drum", "foto", "gajah", "gambar", "garam", "garpu",
        "permainan", "gelas", "gunting", "gelembung", "gitar", "gunung", "guru",
        "pengering rambut", "handuk", "gantungan baju", "helikopter", "helm",
        "handphone", "headset", "hiu", "hujan", "hutan", "ibu", "ikan",
        "jagung", "jaket", "jam", "jerapah", "kacamata", "kalender",
        "kalkulator", "kamera", "kaos kaki", "kapal", "kardus", "kartu atm",
        "kasur", "ke", "kecil", "kepiting", "keran", "keranjang", "keras",
        "kereta api", "kertas", "kodok", "koki", "koala", "kolam renang",
        "komputer", "kontraktor", "kompor", "koper", "korek api", "kotak p3k",
        "kotak pensil", "kotak mainan", "ktp", "kuas", "kucing", "kuda", "kue",
        "kue kering", "kunci", "kulkas", "kupu-kupu", "kura-kura", "kursi",
        "kursi roda", "lampu", "lampu lalu lintas", "lampu tidur",
        "layang-layang", "lebah", "lem", "lemari", "lift", "lilin", "lipstik",
        "lotion", "mainan", "mandi", "manis", "map", "masuk", "matahari",
        "meja", "meja belajar", "memotong", "menempel", "mesin cuci",
        "menggunting", "menulis", "menyikat gigi", "mewarnai", "mesin cuci",
        "mie", "mixer", "mobil", "mobil polisi", "monyet", "mood tracker",
        "motor", "mug", "musik", "nasi", "nelayan", "netflix",
        "nintendo switch", "odol dan sikat gigi", "obat", "ombak", "panas",
        "panci", "panggangan", "papan tulis", "pasta gigi", "paus", "pelari",
        "pelukis", "pemadam kebakaran", "pemain basket", "penggaris",
        "penghapus", "pensil", "pensil warna", "permen", "pesawat", "permainan",
        "petani", "peternak", "piring", "pizza", "pena",
        "plester", "pohon", "polisi", "print", "puding", "putar",
        "rak buku", "rautan", "resleting", "robot", "rok",
        "roti panggang", "roti lapis", "sabun", "sarung tangan",
        "sandal", "selesai", "semangka", "semut", "sendok", "sepatu", "sepeda",
        "setrika", "shampo", "shower", "sikat gigi", "silet", "singa", "sisir",
        "soda", "sofa", "sosis", "siram tanaman", "spon cuci", "stabilo",
        "sudah", "sup", "surat", "sushi", "suster", "susu", "sweater", "tas",
        "teh", "televisi", "telur", "telfon", "termometer", "timbangan", "tisu",
        "tisu roll", "toilet", "tolong", "tong sampah", "troli", "topi", "truk",
        "tukang pos", "tutup", "uang", "ular", "virus", "wajan", "warnai",
        "youtube", "menggambar", "mendengar",
         "gelap", "terang", "talenan",
        "mendengar", "buku cerita", "menggambar", "mendengar", "gelap",
        "terang", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
    ]

    let englishAssets: [String] = [
        "water", "address", "foundation", "bible", "ambulance", "grape", "what",
        "apple", "fire", "salty", "astronaut", "beware", "father", "chicken",
        "fried chicken", "pig", "how", "shirt", "bathtub", "block", "balloon",
        "hot air balloon", "bolt", "baby", "swim", "pillow", "rock",
        "grasshopper", "heavy", "big", "midwife", "star", "bus", "ball",
        "bottle", "bowling", "fruit", "open", "book", "moon", "earth", "flower",
        "burger", "bird", "foam", "dragonfly", "pants", "shorts",
        "small mirror", "mirror", "chocolate", "crayon", "cupboard",
        "wash hands", "wash dishes", "and", "deodorant", "detergent",
        "in", "above", "below", "inside", "outside", "beside", "cold", "doctor",
        "surgeon", "donut", "ice cream", "drum", "photo", "elephant", "picture",
        "salt", "fork", "game", "glass", "scissors", "bubble", "guitar",
        "mountain", "teacher", "hairdryer", "towel", "hanger", "helicopter",
        "helmet", "handphone", "headset", "shark", "rain", "forest", "mother",
        "fish", "corn", "jacket", "clock", "giraffe", "glasses", "calendar",
        "calculator", "camera", "socks", "ship", "cardboard", "atm card",
        "mattress", "to", "small", "crab", "faucet", "basket", "hard", "train",
        "paper", "frog", "chef", "koala", "swimming pool", "computer",
        "contractor", "stove", "suitcase", "match", "first aid box",
        "pencil case", "toy box", "id card", "cat", "zebra", "cake",
        "cookie", "key", "refrigerator", "butterfly", "turtle", "chair",
        "wheelchair", "lamp", "traffic light", "night lamp", "kite", "bee",
        "glue", "elevator", "candle", "lipstick", "lotion", "toy",
        "shower", "sweet", "folder", "in", "sun", "table", "study table",
        "cut", "print", "washing machine", "cutting", "write", "brush teeth",
        "coloring", "washing machine", "noodles", "mixer", "car", "police car",
        "monkey", "mood tracker", "motorcycle", "mug", "music", "rice",
        "fisherman", "netflix", "nintendo switch", "toothpaste and toothbrush",
        "medicine", "wave", "hot", "pan", "grill", "blackboard", "toothpaste",
        "whale", "runner", "painter", "firefighter", "basketball player",
        "ruler", "eraser", "pencil", "colored pencil", "candy", "plane", "game",
        "farmer", "breeder", "plate", "pizza", "pen", "plaster",
        "tree", "police", "cut", "print", "pudding", "spin", "bookshelf",
        "sharpener", "zipper", "robot", "skirt", "toast", "sandwich",
        "soap", "gloves", "slippers", "done", "watermelon", "ant",
        "spoon", "shoes", "bicycle", "iron", "shampoo", "shower", "toothbrush",
        "razor", "lion", "comb", "soda", "sofa", "sausage", "water plants",
        "sponge", "highlighter", "soup", "letter", "sushi", "nurse",
        "milk", "sweater", "bag", "tea", "television", "egg",
        "thermometer", "scale", "tissue", "toilet", "help",
        "trash can", "trolley", "hat", "truck", "postman", "close", "money",
        "snake", "virus", "frying pan", "color", "youtube",
         "draw", "listen", "dark",
        "bright", "cutting board", "story book", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
    ]

    let boyAssets: [String] = [
        "BOY_AMBIL", "BOY_BERMAIN", "BOY_BUANG", "BOY_DIA", "BOY_DIMANA",
        "BOY_DUDUK", "BOY_IYA", "BOY_KAMU", "BOY_KAPAN", "BOY_KITA",
        "BOY_MAKAN", "BOY_MAU", "BOY_MEMBACA", "BOY_MENGANGKAT",
        "BOY_MENGUNYAH", "BOY_MINUM", "BOY_SAKIT", "BOY_SAYA", "BOY_SIAPA",
        "BOY_SUKA", "BOY_TIDAK MAU", "BOY_TIDAK SUKA", "BOY_TIDAK",
        "BOY_MENGANTUK", "BOY_GATAL", "BOY_MENONTON TV",
    ]

    let girlAssets: [String] = [
        "GIRL_AMBIL", "GIRL_BUANG", "GIRL_DIA", "GIRL_BERMAIN", "GIRL_DIMANA",
        "GIRL_DUDUK", "GIRL_IYA", "GIRL_KAMU", "GIRL_KAPAN", "GIRL_KITA",
        "GIRL_MAKAN", "GIRL_MAU", "GIRL_MEMBACA", "GIRL_MENGANGKAT",
        "GIRL_MENGUNYAH", "GIRL_MINUM", "GIRL_SAKIT", "GIRL_SAYA", "GIRL_SIAPA",
        "GIRL_SUKA", "GIRL_TIDAK MAU", "GIRL_TIDAK SUKA", "GIRL_TIDAK",
        "GIRL_MENGANTUK", "GIRL_GATAL", "GIRL_MENONTON TV",
    ]
    
    let girlEnglishAssets: [String] = [
        "GIRL_TAKE", "GIRL_THROW", "GIRL_SHE", "GIRL_PLAY", "GIRL_WHERE",
        "GIRL_SIT", "GIRL_YES", "GIRL_YOU", "GIRL_WHEN", "GIRL_WE",
        "GIRL_EAT", "GIRL_WANT", "GIRL_READ", "GIRL_LIFT",
        "GIRL_CHEW", "GIRL_DRINK", "GIRL_SICK", "GIRL_I", "GIRL_WHO",
        "GIRL_LIKE", "GIRL_DONT WANT", "GIRL_DONT LIKE", "GIRL_NO",
        "GIRL_SLEEPY", "GIRL_ITCHY", "GIRL_WATCH TV",
    ]
    
    let boyEnglishAssets: [String] = [
        "BOY_TAKE", "BOY_THROW", "BOY_SHE", "BOY_PLAY", "BOY_WHERE",
        "BOY_SIT", "BOY_YES", "BOY_YOU", "BOY_WHEN", "BOY_WE",
        "BOY_EAT", "BOY_WANT", "BOY_READ", "BOY_LIFT",
        "BOY_CHEW", "BOY_DRINK", "BOY_SICK", "BOY_I", "BOY_WHO",
        "BOY_LIKE", "BOY_DONT WANT", "BOY_DONT LIKE", "BOY_NO",
        "BOY_SLEEPY", "BOY_ITCHY", "BOY_WATCH TV",
    ]

    let genderIndoAssets: [String] = [
        "ambil", "buang", "dia", "bermain", "dimana", "duduk", "iya", "kamu",
        "kapan", "kita", "makan", "mau", "membaca", "mengangkat", "mengunyah",
        "minum", "sakit", "saya", "siapa", "suka", "tidak mau", "tidak suka", "menonton tv", "mengantuk",
        "tidak", "gatal",
    ]
    
    let genderEnglishAssets: [String] = [
        "take", "throw", "she", "play", "where", "sit", "yes", "you",
        "when", "we", "eat", "want", "read", "lift", "chew", "drink", "sick", "i", "who", "like", "dont want", "dont like", "no", "sleepy", "itchy", "watch tv",
    ]
    
    let genderAssets: [String] = [
        "ambil", "buang", "dia", "bermain", "dimana", "duduk", "iya", "kamu",
        "kapan", "kita", "makan", "mau", "membaca", "mengangkat", "mengunyah",
        "minum", "sakit", "saya", "siapa", "suka", "tidak mau", "tidak suka", "menonton tv", "mengantuk",
        "tidak", "gatal", "take", "throw", "she", "play", "where", "sit", "yes", "you",
        "when", "we", "eat", "want", "read", "lift", "chew", "drink", "sick", "i", "who", "like", "dont want", "dont like", "no", "sleepy", "itchy", "watch tv",
    ]
}
