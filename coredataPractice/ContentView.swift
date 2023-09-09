//
//  ContentView.swift
//  CoreDataDemo
//
//  Created by Suryadev Singh on 05/09/23.
//

import SwiftUI
import CoreData
import WidgetKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(entity: FruitEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(keyPath: \FruitEntity.name, ascending: true)])
    
    var fruits:FetchedResults<FruitEntity>
    
    @State var textFieldText: String = ""
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
                
                TextField("Add fruit here...",text: $textFieldText)
                    .font(.headline)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    addItem()
                    WidgetCenter.shared.reloadAllTimelines()
                },label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height:55)
                        .background(Color.blue)
                        .cornerRadius(10)
                        
                }).padding(.horizontal)
                
                
                List {
                    ForEach(fruits) { fruit in
                        Text(fruit.name ?? "").onTapGesture {
                            updateItem(fruit: fruit)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("Fruits")
            
        }
    }
    
    private func addItem() {
        withAnimation {
            let newFruit = FruitEntity(context: viewContext)
//            newFruit.name = "Orange "
            newFruit.name = textFieldText
            saveItems()
            textFieldText = ""
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            guard let index = offsets.first else { return }
            let fruitEntity =  fruits[index]
            viewContext.delete(fruitEntity)
            saveItems()
            
            WidgetCenter.shared.reloadAllTimelines()
            
        }
    }
    
    
    private func updateItem(fruit: FruitEntity) {
        withAnimation {
            let currentName = fruit.name ?? ""
            let newName = currentName + "!"
            fruit.name = newName
            
            saveItems()
        }
    }
    
    private func saveItems() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
