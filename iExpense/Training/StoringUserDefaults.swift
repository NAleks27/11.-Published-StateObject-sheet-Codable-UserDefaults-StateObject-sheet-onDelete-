//
//  StoringUserSettings.swift
//  iExpense
//
//  Created by Aleksey Nosik on 13.10.2022.
//

import SwiftUI

// userDefaults предназначен для хранение небольшого объема информации (рекомендовано около 512 килобайт)
// если приложение быстро закроется - есть вероятность, что он не успеет сохранить все изменения
// apple не рекомендует хранить большие данные в памяти приложения

struct StoringUserDefaults: View {
    // таким образом изменения сохраняются в состояние
    @State private var tapCount = UserDefaults.standard.integer(forKey: "Tap")
    
    // таким образом
    @AppStorage("tapCount") private var tapCounter = 0
    
    
    var body: some View {
        VStack {
            Button("Tap count: \(tapCount)") {
                tapCount += 1
                UserDefaults.standard.set(tapCount, forKey: "Tap") // ключ "Тар" мы потом используем для чтения данных
            }
            .padding(.bottom, 40)
         
            Button("Tap counter: \(tapCounter)") {
                tapCounter += 1
            }
        }
    }
}

struct StoringUserDefaults_Previews: PreviewProvider {
    static var previews: some View {
        StoringUserDefaults()
    }
}
