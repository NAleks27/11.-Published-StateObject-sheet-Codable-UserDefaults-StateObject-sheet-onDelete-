//
//  ObserversInViewsForClasses.swift
//  iExpense
//
//  Created by Aleksey Nosik on 13.10.2022.
//

import SwiftUI
    
    // используем класс и ObservableObject протокол так как stateObject может работать только с объектами подписанными под протокол ObservableObject (это используется единажды для одного класса)
class User: ObservableObject {
    //published - для того, чтобы любые изменения свойств объекта публиковались в состояние объекта (StateObject)
    
    @Published var firstName = "Balboa"
    @Published var lastName = "Rocky"
}

struct ObserversInViewsForClasses: View {
    // состояние(стейт)  не может отследить изменения свойств объекта, поэтому не обновляет вьюшку
    // используем StateObject для того чтобы отслеживать изменения состояния всего объекта класса
    // MARK: в итоге у нас есть состояние, которое хранится во внешнем объекте и которое может отображаться в нескольких вьюшках и все эти вьюшки будут указывать на одно и то же значение
    
    // MARK: Но когда мы хотим использовать экземпляр класса в других классах - нам нужно использовать ObservedObject
    @StateObject private var user = User()
    
    var body: some View {
        VStack {
            Text("Your name is \(user.firstName) \(user.lastName)")
            
            TextField("FirstName", text: $user.firstName)
            TextField("LastName", text: $user.lastName)
        }
    }
}

struct ObserversInViewsForClasses_Previews: PreviewProvider {
    static var previews: some View {
        ObserversInViewsForClasses()
    }
}
