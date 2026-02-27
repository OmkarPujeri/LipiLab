import SwiftUI

enum AppState: Equatable {
    case intro
    case learningPath
    case letters
    case words
    case letterDetail(index: Int)
    case tracing(index: Int)
    case wordDetail(index: Int)
    case wordTracing(index: Int)
}

struct ContentView: View {
    @State private var appState: AppState = .intro
    @State private var letters = LessonData.allLetters
    @State private var transitionDirection: Edge = .trailing
    @StateObject private var masteryManager = MasteryManager.shared
    
    private let animationDuration: Double = 0.6
    
    private var slideTransition: AnyTransition {
        .asymmetric(
            insertion: .move(edge: transitionDirection).combined(with: .opacity),
            removal: .move(edge: transitionDirection == .trailing ? .leading : .trailing).combined(with: .opacity)
        )
    }
    
    var body: some View {
            ZStack {
                // 1. Background Layer
                LinearGradient(colors: [
                    Color(red: 1.0, green: 0.98, blue: 0.95),
                    Color(red: 0.98, green: 0.95, blue: 0.92)
                ], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
                
                // 2. Main Content Layer
                ZStack {
                    switch appState {
                case .intro:
                    IntroView(onStart: {
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            appState = .learningPath
                        }
                    })
                    .transition(slideTransition)
                    
                case .learningPath:
                    LearningPathView(onLetters: {
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            appState = .letters
                        }
                    }, onWords: {
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            appState = .words
                        }
                    })
                    .transition(slideTransition)
                        
                case .letters:
                    LetterGridView(letters: letters, masteryManager: masteryManager) { index in
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            appState = .letterDetail(index: index)
                        }
                    }
                    .transition(slideTransition)
                    
                case .words:
                    WordGridView(letters: letters, masteryManager: masteryManager) { index in
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            appState = .wordDetail(index: index)
                        }
                    }
                    .transition(slideTransition)
                        
                    case .letterDetail(let index):
                        LetterDetailView(letter: letters[index], onStartTracing: {
                            transitionDirection = .trailing
                            withAnimation(.easeInOut(duration: animationDuration)) {
                                appState = .tracing(index: index)
                            }
                        })
                        .transition(slideTransition)
                        
                case .tracing(let index):
                    TracingView(letter: letters[index]) {
                        masteryManager.updateProgress(for: letters[index].targetLetter)
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            if index + 1 < letters.count {
                                appState = .tracing(index: index + 1)
                            } else {
                                appState = .letters
                            }
                        }
                    }
                    .id(index)
                    .transition(slideTransition)
                    
                case .wordDetail(let index):
                    WordDetailView(letter: letters[index], onStartTracing: {
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            appState = .wordTracing(index: index)
                        }
                    })
                    .transition(slideTransition)
                    
                case .wordTracing(let index):
                    WordTracingView(letter: letters[index]) {
                        masteryManager.updateWordProgress(for: letters[index].targetLetter)
                        transitionDirection = .trailing
                        withAnimation(.easeInOut(duration: animationDuration)) {
                            if index + 1 < letters.count {
                                appState = .wordTracing(index: index + 1)
                            } else {
                                appState = .words
                            }
                        }
                    }
                    .id(index)
                    .transition(slideTransition)
                }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                if appState != .intro {
                    VStack {
                        HStack {
                            navButton
                            Spacer()
                        }
                        Spacer()
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }
        }
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var navButton: some View {
            Button(action: {
                switch appState {
                case .learningPath:
                    transitionDirection = .leading
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        appState = .intro
                    }
                case .letters, .words:
                    transitionDirection = .leading
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        appState = .learningPath
                    }
                case .letterDetail, .tracing:
                    transitionDirection = .leading
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        appState = .letters
                    }
                case .wordDetail, .wordTracing:
                    transitionDirection = .leading
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        appState = .words
                    }
                default: break
                }
            }) {
                Image(systemName: navIcon)
                    .font(.system(isPad ? .title3 : .headline, weight: .bold))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                    .frame(width: isPad ? 28 : 24, height: isPad ? 28 : 24)
                    .padding(isPad ? 12 : 10)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.9))
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    )
            }
            .padding(.leading, 20)
            .padding(.top, isPad ? 50 : 12)
            .contentShape(Rectangle())
        }

    private var navIcon: String {
        switch appState {
        case .intro:
            return "chevron.left"
        case .learningPath, .letters, .words:
            return "chevron.left"
        case .letterDetail, .wordDetail:
            return "square.grid.2x2.fill"
        case .tracing, .wordTracing:
            return "chevron.left"
        }
    }
}

struct LearningPathView: View {
    let onLetters: () -> Void
    let onWords: () -> Void
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(spacing: isPad ? 36 : 20) {
            Spacer()
            
            VStack(spacing: isPad ? 16 : 10) {
                Text("Choose Your Path")
                    .font(isPad ? .largeTitle.bold() : .title.bold())
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                Text("Start with letters or jump into words")
                    .font(isPad ? .title3 : .footnote)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7))
            }
            
            VStack(spacing: isPad ? 24 : 16) {
                pathButton(
                    title: "Learn Letters",
                    subtitle: "Build your foundation",
                    icon: "character.cursor.ibeam",
                    action: onLetters
                )
                
                pathButton(
                    title: "Learn Words",
                    subtitle: "Trace full words",
                    icon: "text.line.first.and.arrowtriangle.forward",
                    action: onWords
                )
            }
            .padding(.horizontal, isPad ? 80 : 30)
            
            Spacer()
        }
    }
    
    private func pathButton(title: String, subtitle: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: isPad ? 18 : 12) {
                Image(systemName: icon)
                    .font(.system(size: isPad ? 28 : 20, weight: .bold))
                    .foregroundColor(.orange)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(isPad ? .title3.bold() : .headline.bold())
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                    Text(subtitle)
                        .font(isPad ? .body : .footnote)
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7))
                }
                Spacer()
            }
            .padding(isPad ? 22 : 16)
            .background(
                RoundedRectangle(cornerRadius: isPad ? 26 : 18)
                    .fill(Color.white.opacity(0.9))
                    .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
            )
        }
    }
}

struct IntroView: View {
    let onStart: () -> Void
    @State private var isVisible = false
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            VStack(spacing: isPad ? 24 : 16) {
                Text("Lipi Lab")
                    .font(.system(size: isPad ? 120 : 84, weight: .thin, design: .serif))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 20)
                
                Text("The art of Devanagari")
                    .font(isPad ? .title : .title3)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.8))
                    .kerning(isPad ? 4 : 2)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 10)
            }
            
            Spacer()
            
            Button(action: onStart) {
                Text("Start Journey")
                    .font(isPad ? .title3.bold() : .headline)
                    .foregroundColor(.white)
                    .padding(.vertical, isPad ? 22 : 16)
                    .padding(.horizontal, isPad ? 72 : 48)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                            .shadow(color: Color.orange.opacity(0.4), radius: 20, x: 0, y: 10)
                    )
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.9)
            .padding(.bottom, isPad ? 200 : 150)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 1.0)) {
                isVisible = true
            }
        }
    }
}

struct LetterGridView: View {
    let letters: [LipiLetter]
    @ObservedObject var masteryManager: MasteryManager
    let onSelect: (Int) -> Void
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: isPad ? 140 : 80), spacing: isPad ? 30 : 20)]
    }
    
    private var progressInfo: (stars: Int, unlocked: Int) {
        let values = Array(masteryManager.progress.values)
        return (
            values.map { $0.rawValue }.reduce(0, +),
            values.filter { $0.rawValue > 0 }.count
        )
    }
    
    private var sections: [(title: String, items: [LipiLetter])] {
        [
            ("स्वर (Vowels)", LessonData.swar),
            ("व्यंजन (Consonants)", LessonData.vyanjan),
            ("संयुक्त (Compounds)", LessonData.samyukta)
        ]
    }
    
    private let starColor: Color = .orange
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 8) {
                Text("Varnamala")
                    .font(isPad ? .largeTitle.bold() : .title.bold())
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                .padding(.horizontal, isPad ? 40 : 20)
                
                let info = progressInfo
                HStack(spacing: 16) {
                    HStack(spacing: 6) {
                        Image(systemName: "star.fill")
                            .foregroundColor(starColor)
                        Text("\(info.stars)")
                    }
                    Text("Letters: \(info.unlocked)/\(letters.count)")
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7))
                }
                .font(isPad ? .title3.bold() : .caption.bold())
                .padding(.horizontal, isPad ? 20 : 12)
                .padding(.vertical, isPad ? 10 : 6)
                .background(Capsule().fill(Color.white.opacity(0.5)))
            }
            .padding(.top, isPad ? 60 : 40)
            
            ScrollView {
                VStack(alignment: .leading, spacing: isPad ? 40 : 24) {
                    ForEach(sections, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(section.title)
                                .font(isPad ? .title2.bold() : .headline)
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                                .padding(.horizontal, isPad ? 40 : 20)
                            
                            LazyVGrid(columns: columns, spacing: isPad ? 30 : 20) {
                                ForEach(section.items) { letter in
                                    if let index = letters.firstIndex(of: letter) {
                                        Button(action: { onSelect(index) }) {
                                            VStack(spacing: 0) {
                                                Spacer(minLength: 0)
                                                Text(letter.targetLetter)
                                                    .font(.custom("Devanagari Sangam MN", size: isPad ? 60 : 36))
                                                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                                                
                                                Text(letter.pronunciation)
                                                    .font(.system(size: isPad ? 13 : 9, weight: .bold, design: .rounded))
                                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.6))
                                                    .padding(.top, 2)
                                                
                                                Spacer(minLength: 0)
                                                
                                                let tier = masteryManager.getTier(for: letter.targetLetter).rawValue
                                                HStack(spacing: isPad ? 4 : 2) {
                                                    ForEach(1...3, id: \.self) { star in
                                                        Image(systemName: star <= tier ? "star.fill" : "star")
                                                            .font(.system(size: isPad ? 12 : 8))
                                                            .foregroundColor(star <= tier ? starColor : .gray.opacity(0.3))
                                                    }
                                                }
                                                .padding(.bottom, isPad ? 12 : 8)
                                            }
                                            .frame(width: isPad ? 126 : 72, height: isPad ? 162 : 104)
                                            .background(Color.white)
                                            .cornerRadius(isPad ? 22 : 14)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: isPad ? 22 : 14)
                                                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .padding(.horizontal, isPad ? 40 : 20)
                        }
                    }
                }
                .padding(.vertical, isPad ? 40 : 20)
            }
        }
    }
    
}

struct WordGridView: View {
    let letters: [LipiLetter]
    @ObservedObject var masteryManager: MasteryManager
    let onSelect: (Int) -> Void
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    private var columns: [GridItem] {
        [GridItem(.adaptive(minimum: isPad ? 160 : 100), spacing: isPad ? 30 : 20)]
    }
    
    private var sections: [(title: String, items: [LipiLetter])] {
        [
            ("स्वर (Vowels)", LessonData.swar),
            ("व्यंजन (Consonants)", LessonData.vyanjan),
            ("संयुक्त (Compounds)", LessonData.samyukta)
        ]
    }
    
    private let starColor: Color = .orange
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 8) {
                Text("Shabd Path")
                    .font(isPad ? .largeTitle.bold() : .title.bold())
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                .padding(.horizontal, isPad ? 40 : 20)
                Text("Trace full words")
                    .font(isPad ? .title3.bold() : .caption.bold())
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7))
            }
            .padding(.top, isPad ? 60 : 40)
            
            ScrollView {
                VStack(alignment: .leading, spacing: isPad ? 40 : 24) {
                    ForEach(sections, id: \.title) { section in
                        VStack(alignment: .leading, spacing: 16) {
                            Text(section.title)
                                .font(isPad ? .title2.bold() : .headline)
                                .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                                .padding(.horizontal, isPad ? 40 : 20)
                            
                            LazyVGrid(columns: columns, spacing: isPad ? 30 : 20) {
                                ForEach(section.items) { letter in
                                    if let index = letters.firstIndex(of: letter) {
                                        Button(action: { onSelect(index) }) {
                                            VStack(spacing: 0) {
                                                Spacer(minLength: 0)
                                                Text(letter.targetLetter)
                                                    .font(.custom("Devanagari Sangam MN", size: isPad ? 54 : 32))
                                                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                                                
                                                Text("\(letter.wordDevanagari) \(letter.wordEmoji)")
                                                    .font(.custom("Devanagari Sangam MN", size: isPad ? 20 : 14))
                                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4))
                                                    .padding(.top, 6)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.7)
                                                
                                                Text(letter.wordTransliteration)
                                                    .font(.system(size: isPad ? 12 : 9, weight: .semibold, design: .rounded))
                                                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.6))
                                                    .padding(.top, 2)
                                                
                                                Spacer(minLength: 0)
                                                
                                                let tier = masteryManager.getWordTier(for: letter.targetLetter).rawValue
                                                HStack(spacing: isPad ? 4 : 2) {
                                                    ForEach(1...3, id: \.self) { star in
                                                        Image(systemName: star <= tier ? "star.fill" : "star")
                                                            .font(.system(size: isPad ? 12 : 8))
                                                            .foregroundColor(star <= tier ? starColor : .gray.opacity(0.3))
                                                    }
                                                }
                                                .padding(.bottom, isPad ? 12 : 8)
                                            }
                                            .frame(width: isPad ? 150 : 94, height: isPad ? 190 : 120)
                                            .background(Color.white)
                                            .cornerRadius(isPad ? 22 : 14)
                                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: isPad ? 22 : 14)
                                                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
                                            )
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                            .padding(.horizontal, isPad ? 40 : 20)
                        }
                    }
                }
                .padding(.vertical, isPad ? 40 : 20)
            }
        }
    }
    
}

struct LetterDetailView: View {
    let letter: LipiLetter
    let onStartTracing: () -> Void
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(spacing: isPad ? 60 : 30) {
            Spacer()
                .frame(height: isPad ? 120 : 80)
            
            Spacer()
            
            VStack(spacing: isPad ? 40 : 20) {
                Text(letter.targetLetter)
                    .font(.custom("Devanagari Sangam MN", size: isPad ? 280 : 180))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                    .padding(.top, 20)
                
                VStack(spacing: isPad ? 16 : 8) {
                    Text(letter.pronunciation)
                        .font(.system(size: isPad ? 64 : 40, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                    
                    Text(letter.description)
                        .font(isPad ? .title2 : .body)
                        .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, isPad ? 80 : 40)
                }
            }
            
            Spacer()
            
            Button(action: onStartTracing) {
                Text("Start Tracing")
                    .font(isPad ? .title3.bold() : .headline)
                    .foregroundColor(.white)
                    .padding(.vertical, isPad ? 22 : 16)
                    .padding(.horizontal, isPad ? 72 : 48)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                            .shadow(color: Color.orange.opacity(0.4), radius: 20, x: 0, y: 10)
                    )
            }
            .padding(.bottom, isPad ? 100 : 60)
        }
    }
}

struct WordDetailView: View {
    let letter: LipiLetter
    let onStartTracing: () -> Void
    
    private var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
    
    var body: some View {
        VStack(spacing: isPad ? 40 : 24) {
            Spacer()
            
            VStack(spacing: isPad ? 20 : 12) {
                Text("\(letter.wordDevanagari) \(letter.wordEmoji)")
                    .font(.custom("Devanagari Sangam MN", size: isPad ? 140 : 90))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .padding(.horizontal, isPad ? 60 : 30)
                
                Text(letter.wordTransliteration)
                    .font(isPad ? .title2.bold() : .headline.bold())
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.7))
                
                Text(letter.wordMeaningEn)
                    .font(isPad ? .title3 : .footnote)
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.4).opacity(0.6))
            }
            .frame(maxWidth: .infinity)
            .multilineTextAlignment(.center)
            .padding(.top, isPad ? 6 : 4)
            
            VStack(spacing: isPad ? 12 : 6) {
                Text(letter.targetLetter)
                    .font(.custom("Devanagari Sangam MN", size: isPad ? 90 : 60))
                    .foregroundColor(Color(red: 0.15, green: 0.15, blue: 0.3))
                Text(letter.pronunciation)
                    .font(.system(size: isPad ? 28 : 18, weight: .bold, design: .rounded))
                    .foregroundColor(.orange)
            }
            
            Spacer()
            
            Button(action: onStartTracing) {
                Text("Start Word Tracing")
                    .font(isPad ? .title3.bold() : .headline)
                    .foregroundColor(.white)
                    .padding(.vertical, isPad ? 22 : 16)
                    .padding(.horizontal, isPad ? 72 : 48)
                    .background(
                        Capsule()
                            .fill(Color.orange)
                            .shadow(color: Color.orange.opacity(0.4), radius: 20, x: 0, y: 10)
                    )
            }
            .padding(.bottom, isPad ? 90 : 60)
        }
    }
}
