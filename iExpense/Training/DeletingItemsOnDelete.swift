//
//  DeletingItemsOnDelete.swift
//  iExpense
//
//  Created by Aleksey Nosik on 13.10.2022.
//

import SwiftUI

// onDelete работает только с ForEach

struct DeletingItemsOnDelete: View {
    @State private var numbers = [Int]()
    @State private var currentNumber = 1
     
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(numbers, id: \.self) {
                        Text("Row \($0)")
                    }
                    .onDelete(perform: removeRows)
                }
                
                Button("Add Number") {
                    numbers.append(currentNumber)
                    currentNumber += 1
                }
            }
            .navigationTitle("onDelete()")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                EditButton()                // для удаления нескольких элементов 
            }
        }
    }
    
    // создаем метод для удаления элементов массива по их индексу в форИч
    func removeRows(at offsets: IndexSet) {
        numbers.remove(atOffsets: offsets)
    }
}

struct DeletingItemsOnDelete_Previews: PreviewProvider {
    static var previews: some View {
        DeletingItemsOnDelete()
    }
}
