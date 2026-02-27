import Foundation

struct LipiLetter: Identifiable, Equatable {
    let id = UUID()
    let targetLetter: String
    let pronunciation: String
    let description: String
    let wordDevanagari: String
    let wordEmoji: String
    let wordTransliteration: String
    let wordMeaningEn: String
}

struct LessonData {
    static let swar: [LipiLetter] = [
        LipiLetter(targetLetter: "अ", pronunciation: "A", description: "The first vowel.", wordDevanagari: "अनार", wordEmoji: "🍎", wordTransliteration: "Anaar", wordMeaningEn: "pomegranate"),
        LipiLetter(targetLetter: "आ", pronunciation: "Aa", description: "The second vowel.", wordDevanagari: "आम", wordEmoji: "🥭", wordTransliteration: "Aam", wordMeaningEn: "mango"),
        LipiLetter(targetLetter: "इ", pronunciation: "I", description: "Short I.", wordDevanagari: "इमली", wordEmoji: "🫛", wordTransliteration: "Imli", wordMeaningEn: "tamarind"),
        LipiLetter(targetLetter: "ई", pronunciation: "Ee", description: "Long I.", wordDevanagari: "ईख", wordEmoji: "🎋", wordTransliteration: "Eekh", wordMeaningEn: "sugarcane"),
        LipiLetter(targetLetter: "उ", pronunciation: "U", description: "Short U.", wordDevanagari: "उल्लू", wordEmoji: "🦉", wordTransliteration: "Ullu", wordMeaningEn: "owl"),
        LipiLetter(targetLetter: "ऊ", pronunciation: "Oo", description: "Long U.", wordDevanagari: "ऊन", wordEmoji: "🧶", wordTransliteration: "Oon", wordMeaningEn: "wool"),
        LipiLetter(targetLetter: "ऋ", pronunciation: "Ri", description: "The vocalic R.", wordDevanagari: "ऋषि", wordEmoji: "🧘‍♂️", wordTransliteration: "Rishi", wordMeaningEn: "sage"),
        LipiLetter(targetLetter: "ए", pronunciation: "E", description: "Short E.", wordDevanagari: "एकतारा", wordEmoji: "🪕", wordTransliteration: "Ektara", wordMeaningEn: "one-string instrument"),
        LipiLetter(targetLetter: "ऐ", pronunciation: "Ai", description: "Long Ai.", wordDevanagari: "ऐनक", wordEmoji: "👓", wordTransliteration: "Ainak", wordMeaningEn: "glasses"),
        LipiLetter(targetLetter: "ओ", pronunciation: "O", description: "Short O.", wordDevanagari: "ओखली", wordEmoji: "🪵", wordTransliteration: "Okhli", wordMeaningEn: "mortar"),
        LipiLetter(targetLetter: "औ", pronunciation: "Au", description: "Long Au.", wordDevanagari: "औरत", wordEmoji: "👩", wordTransliteration: "Aurat", wordMeaningEn: "woman"),
        LipiLetter(targetLetter: "अं", pronunciation: "Am", description: "Anusvara.", wordDevanagari: "अंगूर", wordEmoji: "🍇", wordTransliteration: "Angoor", wordMeaningEn: "grapes"),
        LipiLetter(targetLetter: "अः", pronunciation: "Ah", description: "Visarga.", wordDevanagari: "नमः", wordEmoji: "🙏", wordTransliteration: "Namah", wordMeaningEn: "salutation")
    ]
    
    static let vyanjan: [LipiLetter] = [
        LipiLetter(targetLetter: "क", pronunciation: "Ka", description: "First consonant.", wordDevanagari: "कमल", wordEmoji: "🪷", wordTransliteration: "Kamal", wordMeaningEn: "lotus"),
        LipiLetter(targetLetter: "ख", pronunciation: "Kha", description: "Aspirated Ka.", wordDevanagari: "खटिया", wordEmoji: "🛏️", wordTransliteration: "Khatiya", wordMeaningEn: "cot"),
        LipiLetter(targetLetter: "ग", pronunciation: "Ga", description: "Soft G.", wordDevanagari: "गदा", wordEmoji: "🔨", wordTransliteration: "Gada", wordMeaningEn: "mace"),
        LipiLetter(targetLetter: "घ", pronunciation: "Gha", description: "Aspirated Ga.", wordDevanagari: "घड़ियाल", wordEmoji: "🐊", wordTransliteration: "Ghariyal", wordMeaningEn: "gharial"),
        LipiLetter(targetLetter: "ङ", pronunciation: "Nga", description: "Nasal sound.", wordDevanagari: "वाङ्मय", wordEmoji: "📚", wordTransliteration: "Wangmay", wordMeaningEn: "literature"),
        
        LipiLetter(targetLetter: "च", pronunciation: "Cha", description: "Cha sound.", wordDevanagari: "चरखा", wordEmoji: "🧶", wordTransliteration: "Charkha", wordMeaningEn: "spinning wheel"),
        LipiLetter(targetLetter: "छ", pronunciation: "Chha", description: "Aspirated Cha.", wordDevanagari: "छड़ी", wordEmoji: "🦯", wordTransliteration: "Chhadi", wordMeaningEn: "stick"),
        LipiLetter(targetLetter: "ज", pronunciation: "Ja", description: "Ja sound.", wordDevanagari: "जलेबी", wordEmoji: "🥨", wordTransliteration: "Jalebi", wordMeaningEn: "sweet"),
        LipiLetter(targetLetter: "झ", pronunciation: "Jha", description: "Aspirated Ja.", wordDevanagari: "झरना", wordEmoji: "🌊", wordTransliteration: "Jharna", wordMeaningEn: "waterfall"),
        LipiLetter(targetLetter: "ञ", pronunciation: "Nya", description: "Nasal sound.", wordDevanagari: "चञ्चु", wordEmoji: "🐤", wordTransliteration: "Chanchu", wordMeaningEn: "beak"),
        
        LipiLetter(targetLetter: "ट", pronunciation: "Ta", description: "Hard Ta.", wordDevanagari: "टमाटर", wordEmoji: "🍅", wordTransliteration: "Tamatar", wordMeaningEn: "tomato"),
        LipiLetter(targetLetter: "ठ", pronunciation: "Tha", description: "Aspirated Ta.", wordDevanagari: "ठठेरा", wordEmoji: "🛠️", wordTransliteration: "Thathera", wordMeaningEn: "metal artisan"),
        LipiLetter(targetLetter: "ड", pronunciation: "Da", description: "Hard Da.", wordDevanagari: "डमरू", wordEmoji: "🥁", wordTransliteration: "Damru", wordMeaningEn: "drum"),
        LipiLetter(targetLetter: "ढ", pronunciation: "Dha", description: "Aspirated Da.", wordDevanagari: "ढकना", wordEmoji: "🍲", wordTransliteration: "Dhakna", wordMeaningEn: "lid"),
        LipiLetter(targetLetter: "ण", pronunciation: "Na", description: "Hard Na.", wordDevanagari: "बाण", wordEmoji: "🏹", wordTransliteration: "Baan", wordMeaningEn: "arrow"),
        
        LipiLetter(targetLetter: "त", pronunciation: "Ta", description: "Soft Ta.", wordDevanagari: "तराजू", wordEmoji: "⚖️", wordTransliteration: "Taraju", wordMeaningEn: "scale"),
        LipiLetter(targetLetter: "थ", pronunciation: "Tha", description: "Aspirated Soft Ta.", wordDevanagari: "थन", wordEmoji: "🐄", wordTransliteration: "Than", wordMeaningEn: "udder"),
        LipiLetter(targetLetter: "द", pronunciation: "Da", description: "Soft Da.", wordDevanagari: "दवात", wordEmoji: "✒️", wordTransliteration: "Dawat", wordMeaningEn: "inkpot"),
        LipiLetter(targetLetter: "ध", pronunciation: "Dha", description: "Aspirated Soft Da.", wordDevanagari: "धनुष", wordEmoji: "🏹", wordTransliteration: "Dhanush", wordMeaningEn: "bow"),
        LipiLetter(targetLetter: "न", pronunciation: "Na", description: "Na sound.", wordDevanagari: "नल", wordEmoji: "🚰", wordTransliteration: "Nal", wordMeaningEn: "tap"),
        
        LipiLetter(targetLetter: "प", pronunciation: "Pa", description: "Pa sound.", wordDevanagari: "पतंग", wordEmoji: "🪁", wordTransliteration: "Patang", wordMeaningEn: "kite"),
        LipiLetter(targetLetter: "फ", pronunciation: "Pha", description: "Pha/Fa sound.", wordDevanagari: "फव्वारा", wordEmoji: "⛲", wordTransliteration: "Phawwara", wordMeaningEn: "fountain"),
        LipiLetter(targetLetter: "ब", pronunciation: "Ba", description: "Ba sound.", wordDevanagari: "बतख", wordEmoji: "🦆", wordTransliteration: "Batakh", wordMeaningEn: "duck"),
        LipiLetter(targetLetter: "भ", pronunciation: "Bha", description: "Aspirated Ba.", wordDevanagari: "भरनी", wordEmoji: "🏺", wordTransliteration: "Bharni", wordMeaningEn: "jar"),
        LipiLetter(targetLetter: "म", pronunciation: "Ma", description: "Ma sound.", wordDevanagari: "मछली", wordEmoji: "🐟", wordTransliteration: "Machhli", wordMeaningEn: "fish"),
        
        LipiLetter(targetLetter: "य", pronunciation: "Ya", description: "Ya sound.", wordDevanagari: "यज्ञ", wordEmoji: "🔥", wordTransliteration: "Yagya", wordMeaningEn: "sacrifice"),
        LipiLetter(targetLetter: "र", pronunciation: "Ra", description: "Ra sound.", wordDevanagari: "रथ", wordEmoji: "🏇", wordTransliteration: "Rath", wordMeaningEn: "chariot"),
        LipiLetter(targetLetter: "ल", pronunciation: "La", description: "La sound.", wordDevanagari: "लट्टू", wordEmoji: "🪀", wordTransliteration: "Lattu", wordMeaningEn: "spinning top"),
        LipiLetter(targetLetter: "व", pronunciation: "Va", description: "Va/Wa sound.", wordDevanagari: "वजन", wordEmoji: "⚖️", wordTransliteration: "Vajan", wordMeaningEn: "weight"),
        
        LipiLetter(targetLetter: "श", pronunciation: "Sha", description: "Sha sound.", wordDevanagari: "शलगम", wordEmoji: "🍠", wordTransliteration: "Shalgam", wordMeaningEn: "turnip"),
        LipiLetter(targetLetter: "ष", pronunciation: "Sha", description: "Retroflex Sha.", wordDevanagari: "षट्कोण", wordEmoji: "🔷", wordTransliteration: "Shatkon", wordMeaningEn: "hexagon"),
        LipiLetter(targetLetter: "स", pronunciation: "Sa", description: "Sa sound.", wordDevanagari: "सरोता", wordEmoji: "✂️", wordTransliteration: "Sarota", wordMeaningEn: "scissors"),
        LipiLetter(targetLetter: "ह", pronunciation: "Ha", description: "Ha sound.", wordDevanagari: "हथौड़ी", wordEmoji: "🔨", wordTransliteration: "Hathaudi", wordMeaningEn: "hammer")
    ]
    
    static let samyukta: [LipiLetter] = [
        LipiLetter(targetLetter: "क्ष", pronunciation: "Ksha", description: "Compound Ka + Sha.", wordDevanagari: "क्षत्रिय", wordEmoji: "⚔️", wordTransliteration: "Kshatriya", wordMeaningEn: "warrior"),
        LipiLetter(targetLetter: "त्र", pronunciation: "Tra", description: "Compound Ta + Ra.", wordDevanagari: "त्रिशूल", wordEmoji: "🔱", wordTransliteration: "Trishool", wordMeaningEn: "trident"),
        LipiLetter(targetLetter: "ज्ञ", pronunciation: "Gya", description: "Compound Ja + Nya.", wordDevanagari: "ज्ञानी", wordEmoji: "🧠", wordTransliteration: "Gyani", wordMeaningEn: "wise person"),
        LipiLetter(targetLetter: "श्र", pronunciation: "Shra", description: "Compound Sha + Ra.", wordDevanagari: "श्रमिक", wordEmoji: "👷", wordTransliteration: "Shramik", wordMeaningEn: "worker")
    ]
    
    static var allLetters: [LipiLetter] {
        swar + vyanjan + samyukta
    }
}
