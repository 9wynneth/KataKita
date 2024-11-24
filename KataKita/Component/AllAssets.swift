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
        "kotak pensil", "kotak mainan", "ktp", "kuas", "kucing", "zebra", "kue",
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
         "gelap", "terang", "talenan", "buku cerita", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10",
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
        "when", "we", "eat", "want", "read", "lift", "chew", "drink", "sick", "i", "who", "like", "dont want", "dont like", "no", "sleepy", "itchy", "watch tv", "拿", "丢", "他", "玩", "在哪里", "坐", "是", "你", "什么时候", "我们", "吃", "要", "读", "举起", "咀嚼", "喝", "痛", "我", "谁", "喜欢", "不要", "不喜欢", "看电视", "困", "不", "痒",
    ]
    
    let cinaAssets: [String] = ["水", "地址", "粉底", "圣经", "救护车", "葡萄", "什么", "苹果", "火", "咸", "宇航员", "小心", "爸爸", "鸡", "炸鸡", "猪", "怎么样", "衣服", "浴缸", "积木", "气球", "热气球", "螺栓", "婴儿", "游泳", "枕头", "石头", "蚱蜢", "重", "大", "助产士", "星星", "巴士", "球", "瓶子", "保龄球", "水果", "打开", "书", "月亮", "地球", "花", "汉堡", "鸟", "泡沫", "蜻蜓", "长裤", "短裤", "小镜子", "镜子", "巧克力", "蜡笔", "爱家", "洗手", "洗碗", "和", "除臭剂", "洗衣液", "在", "在上面", "在下面", "在里面", "在外面", "在旁边", "冷", "医生", "外科医生", "甜甜圈", "冰淇淋", "鼓", "照片", "大象", "画", "盐", "叉子", "游戏", "杯子", "剪刀", "泡泡", "吉他", "山", "老师", "吹风机", "毛巾", "衣架", "直升机", "头盔", "手机", "耳机", "鲨鱼", "雨", "森林", "妈妈", "鱼", "玉米", "夹克", "时钟", "长颈鹿", "眼镜", "日历", "计算器", "相机", "袜子", "船", "纸箱", "银行卡", "床垫", "到", "小", "螃蟹", "水龙头", "篮子", "硬", "火车", "纸", "青蛙", "厨师", "考拉", "游泳池", "计算机", "承包商", "炉子", "行李箱", "火柴", "急救箱", "铅笔盒", "玩具箱", "身份证", "刷子", "猫", "斑马", "蛋糕", "饼干", "钥匙", "冰箱", "蝴蝶", "乌龟", "椅子", "轮椅", "灯", "交通灯", "夜灯", "风筝", "蜜蜂", "胶水", "柜子", "电梯", "蜡烛", "口红", "乳液", "玩具", "洗澡", "甜", "文件夹", "进去", "太阳", "桌子", "书桌", "切割", "粘贴", "洗衣机", "剪", "写", "刷牙", "上色", "洗衣机", "面条", "搅拌机", "汽车", "警车", "猴子", "心情记录", "摩托车", "马克杯", "音乐", "米饭", "渔民", "网飞", "任天堂游戏机", "牙膏和牙刷", "药", "海浪", "热", "锅", "烤箱", "黑板", "牙膏", "鲸鱼", "跑步者", "画家", "消防员", "篮球运动员", "尺子", "橡皮擦", "铅笔", "彩铅", "糖果", "飞机", "游戏", "农民", "牧民", "盘子", "披萨", "钢笔", "创可贴", "树", "警察", "打印", "布丁", "旋转", "书架", "卷笔刀", "拉链", "机器人", "裙子", "吐司", "三明治", "肥皂", "手套", "拖鞋", "完成", "西瓜", "蚂蚁", "勺子", "鞋子", "自行车", "熨斗", "洗发水", "淋浴", "牙刷", "剃刀", "狮子", "梳子", "苏打水", "沙发", "香肠", "浇花", "海绵", "荧光笔", "已经", "汤", "信件", "寿司", "护士", "牛奶", "毛衣", "包", "茶", "电视", "鸡蛋", "电话", "体温计", "秤", "纸巾", "卷纸", "厕所", "帮忙", "垃圾桶", "手推车", "帽子", "卡车", "邮递员", "关闭", "钱", "蛇", "病毒", "锅", "涂色", "YouTube", "画画", "听", "暗", "亮", "切菜板", "故事书", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
                    
    ]
    
    let genderCinaAssets: [String] = ["拿", "丢", "他", "玩", "在哪里", "坐", "是", "你", "什么时候", "我们", "吃", "要", "读", "举起", "咀嚼", "喝", "痛", "我", "谁", "喜欢", "不要", "不喜欢", "看电视", "困", "不", "痒",
    ]
    
    let boyCinaAssets: [String] = ["BOY_拿", "BOY_丢", "BOY_他", "BOY_玩", "BOY_在哪里", "BOY_坐", "BOY_是", "BOY_你", "BOY_什么时候", "BOY_我们", "BOY_吃", "BOY_要", "BOY_读", "BOY_举起", "BOY_咀嚼", "BOY_喝", "BOY_痛", "BOY_我", "BOY_谁", "BOY_喜欢", "BOY_不要", "BOY_不喜欢", "BOY_看电视", "BOY_困", "BOY_不", "BOY_痒",
    ]
    
    let girlCinaAssets: [String] = ["GIRL_拿", "GIRL_丢", "GIRL_她", "GIRL_玩", "GIRL_在哪里", "GIRL_坐", "GIRL_是", "GIRL_你", "GIRL_什么时候", "GIRL_我们", "GIRL_吃", "GIRL_要", "GIRL_读", "GIRL_举起", "GIRL_咀嚼", "GIRL_喝", "GIRL_痛", "GIRL_我", "GIRL_谁", "GIRL_喜欢", "GIRL_不要", "GIRL_不喜欢", "GIRL_看电视", "GIRL_困", "GIRL_不", "GIRL_痒",
    ]
}
