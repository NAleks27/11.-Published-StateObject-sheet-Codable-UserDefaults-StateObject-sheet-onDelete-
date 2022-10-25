//
//  ArchivingObjectsWithCodable.swift
//  iExpense
//
//  Created by Aleksey Nosik on 13.10.2022.
//

import SwiftUI

struct Users: Codable {
    let firstName: String
    let lastName: String
}

struct ArchivingObjectsWithCodable: View {
    @State private var user = Users(firstName: "Bob", lastName: "Harrisson")
    
    
    var body: some View {
        Button("Save User") {
            let encoder = JSONEncoder()
            
            if let data = try? encoder.encode(user){
                UserDefaults.standard.set(data, forKey: "UserData")
            }
        }
    }
}

struct ArchivingObjectsWithCodable_Previews: PreviewProvider {
    static var previews: some View {
        ArchivingObjectsWithCodable()
    }
}
