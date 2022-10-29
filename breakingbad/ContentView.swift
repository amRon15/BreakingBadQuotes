//
//  ContentView.swift
//  breakingbad
//
//  Created by 邱允聰 on 28/10/2022.
//

import SwiftUI
import CoreData

struct Quote : Codable,Hashable {
    let quote_id : Int
    let quote : String
    let author : String
}


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject var fetch = fetchAPI()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    //    @State private var quotes = [Quote]()
    
    var body: some View {
        NavigationView{
            VStack(spacing: 15){
                List(fetch.allQuote,id: \.self){quote in
                    VStack(alignment: .leading, spacing: 10){
                        Text(quote.quote)
                            .font(.title3)
                        Text("By: \(quote.author)")
                            .frame(maxWidth: .infinity,alignment: .bottomTrailing)
                    }
                    .frame(maxWidth: .infinity,alignment: .leading)
                }
                .listStyle(.plain)
                .navigationTitle("All Quotes")
            }
            .task {
                await fetch.loadData()
            }
            .animation(.default, value: fetch.quoteID)
        }
        .searchable(text: $fetch.searchText)
        .textInputAutocapitalization(.never)
        .onChange(of: fetch.searchText){searchText in
            if !searchText.isEmpty{
                fetch.allQuote = fetch.quotes.filter{ $0.quote.uppercased().contains(searchText.uppercased())}
            }
            else {
                fetch.allQuote = fetch.quotes
            }
        }
    }
    
    
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
