//
//  ShowingAndHidingViews.swift
//  iExpense
//
//  Created by Aleksey Nosik on 13.10.2022.
//

import SwiftUI

// создаем второе вью, которое будем показывать поверх первого вью
// чтобы отклонить/освободить (dismiss) нашу вторую вьюшку - нужно чтобы она выяснила сначала, какое состояние отвечает за его показ и затем изменить это состояние
struct SecondView: View {
    @Environment(\.dismiss) var dismiss

    let name: String
    
    var body: some View {
        VStack {
            Text("Second View")
            Text("Hello \(name)")
            Button("Dismiss") {
                dismiss()
            }
        }
    }
}

struct ShowingAndHidingViews: View {
    // создаем состояние при котором будет показываться вторая вьюшка
    @State private var showingSheet = false
    
    var body: some View {
        Button("Showing sheet") {
            showingSheet.toggle()
        }
        .sheet(isPresented: $showingSheet) {
            SecondView(name: "Alex")
        }
    }
}

struct ShowingAndHidingViews_Previews: PreviewProvider {
    static var previews: some View {
        ShowingAndHidingViews()
    }
}
