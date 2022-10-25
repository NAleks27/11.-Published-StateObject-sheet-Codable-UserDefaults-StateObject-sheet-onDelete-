
//  ContentView.swift
//  iExpense
//  Created by Aleksey Nosik on 13.10.2022.

// ObservableObject - ПРОТОКОЛ - Наблюдаемый Объект
// @Published - Публикация изменений в состояние
// @StateObject - Состояние объекта обновляет свойство body и перерисовывает вьюшку
// ObservedObject - СВОЙСТВО - Объект который наблюдает за Наблюдаемым Объектом (ObservableObject)

//  ObservableObject класс (тип) + @Published массив класса (свойство типа) -> @StateObject (состояние объекта)

// MARK: Порядок создания
// 1. Создаем структуру самого расхода/элемента (имя, тип, кол-во) - ExpenseItem
// 2. Создаем класс расходов под протоколом ObservableObject (наблюдаемый объект) - Expenses
// 3. В этом классе создаем массив, где будем хранить все расходы/элементы с состоянием @Published, которое будет передавать все изменения в расходе/элементе(имя, тип, кол-во) в наше состояние объекта @StateObject - ContentView
// 4. Создаем @StateObject свойство (expenses) типа нашего Наблюдаемого Объекта @StateObject var expenses = Expenses()
// 5. Если мы изображаем список расходов динамически(через ForEach) мы указываем что можем идентифицировать каждый элемент внутри статьи наших расходов по его уникальному имени (id:\.name), но если имена будут повторяться (Test/Обед/Такси) - могут быть ошибки так как имена не уникальны получаются - ПОЭТОМУ НУЖНО МЕНЯТЬ ЛОГИКУ СТРУКТУРЫ
// 6. Для этого в структуру нашего расхода нужно добавить что-то уникальное. Например ID - но в таком случае нам нужно будет отслеживать наш последний ID, чтобы не было дубликатов
// 7. Поэтому самое простое и оптимальное решение - использование УНИВЕРСАЛЬНОГО УНИКАЛЬНОГО ИДЕНТИФИКАТОРА - UUID (B0D0C644-436B-46CF-B5EC-931F69C84CB8 - код)
// 8. Добавляем в структуру нашего расхода свойство ID (UUID) с автоматическим вычислением - let id = UUID()
// 9. Помечаем структуру расхода как соответствующую протоколу Identifiable - то есть этот тип (структура) может быть идентифицирован однозначно так как у нас теперь есть уникальное свойство id
// 10. Мы можем убрать из ForEach подпись id: \.id так как наш расход/объект уже имеет свойство по которому может быть идентифицирован
// 11. Создаем второй экран, который будет отображаться при добавлении нового расхода - AddView
// 12. Добавляем в ContentView отображение второго экрана: Маркер состояния -> Модификатор sheet(isPresented: ... ) -> Добавление в модификатор нашего экрана отображения.
// 13. Так как у нас уже есть экземпляр расходов в ContentView (@StateObject var expenses) и чтобы не создавать его в AddView - мы в AddView создаем свойство которое наблюдает за изменениями уже созданного экземпляра класса в ContentView - AddView(expenses: expenses)
// 14. Таким образом свойство expenses структуры ContentView и свойство expenses структуры AddView наблюдают за изменениями одного и того же объекта
// 15. Чтобы устранить ошибку предварительного просмотра в AddView мы можем использовать фиктивное значение для нашего свойства (expenses) -  AddView(expenses: Expenses())
// 16. В toolbar у нас есть кнопка добавления расхода, но пока она тестовая (сразу добавляет тестовый расход). Поэтому заменяем ее функционал на отображение второго экрана - showingAddExpense = true
// 17. В AddView нам нужно создать кнопку, чтобы при нажатии она создавала новый расход из трех @State свойств структуры AddView (name, type, amount) и затем добавляла этот расход к расходам (expenses)
// 18. В AddView в toolbar создаем кнопку в которой создается расход(item) и добавляется в массив всех расходов(expense.items.append) - Button("Save") 
// 19. В AddView добавим свойство и вызовем его в нашей кнопке "Save" чтобы после добавления расхода второй экран скрывался - @Environment(\.dismiss) var dismiss
// 20. Чтобы сохранять все изменения расходов после выхода из приложения мы будем использовать (Codable протокол для архивации данных, UserDefaults для сохранения и записи данных, custom initialisator для данных из UserDefaults, и два didSet oservers для моментальной записи изменений элемента) в нашем классе расходов - Expenses (далее в Expenses)
// ...
// 25. Корректируем отображение расхода

import SwiftUI

//struct StylesOfExpenses: ViewModifier {
//    func body(content: Content) -> some View {
//        content
//            .foregroundColor(.red)
//    }
//}


struct ContentView: View {
    @StateObject var expenses = Expenses()
    @State private var showingAddExpense = false

    let currencyCode = Locale.current.currency?.identifier ?? "USD"
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in   // мы говорим, что можем идентифицировать каждый элемент внутри статьи наших расходов по его уникальному имени, но если имена будут повторяться - могут быть ошибки (поэтому используем let id = UUID())                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                    
                        Text(item.amount, format: .currency(code: currencyCode))
                            .foregroundColor(currentColor(item: item))
                    }
                    .accessibilityLabel("\(item.name), \(item.amount)\(currencyCode)")
                }
                .onDelete(perform: removeItems)
            }
            .navigationTitle("iExpense")
            .toolbar {
                Button {
//                    let expense = ExpenseItem(name: "Test", type: "Personal", amount: 5)
//                    expenses.items.append(expense)
                    showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingAddExpense) {
                AddView(expenses: expenses)         // передаем все изменения из текущего expenses в AddView(expenses:)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
    
    func currentColor(item: ExpenseItem) -> Color {
        var currentColor = Color.black
        
        switch item.amount {
        case 1..<10: currentColor = .blue
        case 10..<100: currentColor = .green
        case 100...1000: currentColor = .red
        default: currentColor = .black
        }
        
        return currentColor
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
