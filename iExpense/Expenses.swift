//  Expenses.swift
//  iExpense
//  Created by Aleksey Nosik on 14.10.2022.

// encoder - кодировщик
// encoded - закодирован

// 21. Займемся для начала записью данных. Создаем экземпляр JSON кодировщика который преобразует наши данные в JSON (мы просим попробовать кодировать наш массив items). Затем мы можем записать это в UserDefaults используя ключ наших items - didSet -> encoder JSON -> if let encoded -> UserDefaults
// 22. encoder.encode может кодировать и декодировать данные соответсвующие Сodable протоколу, поэтому в структуре нашего расхода (ExpenseItem) подписываем ее под протокол Codable
// 23. Компилятор предупредит, что свойство id структуры ExpenseItem не будет декодировано так как это константа и у него есть значение по умолчанию, поэтому изменим let на var - таким образом компилятор понимает что наше свойство может быть перезаписано если оно существует в данных, а иначе - нет 
// На данном этапе наш код didSet... - неэффективен, так как наши данные могут быть сохранены, но они не загружаются, когда приложение перезапускается - для этого нужно реализовать собственный инициализатор (custom initialisator) для нашего класса Expenses - init()...
// 24. Пытаемся прочитать ключ "Items" из UserDefaults -> создаем экземпляр JSONDecoder который переходит от данных JSON в объекты свифта -> просим декодер полученные данные из UserDefaults преобразовать в массив расходов (expense.items) -> если это работает то назначьте это нашим items а иначе создайте пустой массив - init()...


import Foundation

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            
            if let encoded = try? encoder.encode(items) {                   // можно записать if let encoded = try? JSONEncoder().encode(items)
                UserDefaults.standard.set(encoded, forKey: "Items")
            }
        }
    }
    
    init() {
        if let savedItems = UserDefaults.standard.data(forKey: "Items") {           // проверили, есть ли у над данные в UserDefaults по ключу "Items"
            if let decodedItems = try? JSONDecoder().decode([ExpenseItem].self, from: savedItems) { // проверяем, можем ли мы декодировать эти данные и указываем результат типа свифта, который мы ожидаем - [ExpenseItem].self
                items = decodedItems
                return
            }
        }
        items = []                  // если мы сюда дошли, то данные недействительны, поэтому вместо этого пустой массив
    }
}
