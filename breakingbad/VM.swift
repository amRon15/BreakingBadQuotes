//
//  VM.swift
//  breakingbad
//
//  Created by 邱允聰 on 28/10/2022.
//

import Foundation
import SwiftUI

class fetchAPI : ObservableObject {
    var quotes = [Quote]()
    @Published var allQuote = [Quote]()
    @Published var quote : String = "Loading Quote..."
    @Published var quoteID : Int = 0
    @Published var author : String = "Loading Author..."
    @Published var searchText : String = ""
    
    func loadData() async{
        guard let url = URL(string: "https://www.breakingbadapi.com/api/quotes") else {
            print("fail to fetch")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decode = try? JSONDecoder().decode([Quote].self, from: data){
                quotes = decode
            }
            DispatchQueue.main.async {
//                for quote in self.quotes {
//                    self.quote = quote.quote
//                    self.quoteID = quote.quote_id
//                    self.author = quote.author
//                }
                self.allQuote = self.quotes
//                print(self.allQuote)
            }
        }
        catch {
            print("failed")
        }
    }
}
