//
//  Database.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import Foundation
import Supabase

struct Cheese: Decodable, Identifiable {
    let id: String
    let name: String
    let category: String
    let url: String
    let description: String
    let notes: String
    let allergens: String
    let ingredients: String
    let additionalFacts: String
}

class Database {
    let supabase: SupabaseClient
    
    init(){
        print(ProcessInfo.processInfo.environment["SUPABASE_URL"]!)
        print(ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"]!)

        guard
            let supabaseURLString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
            let supabaseURL = URL(string: supabaseURLString),
            let supabaseKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"]
        else {
            fatalError("Supabase environment variables are not set correctly.")
        }

        supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }

    func getAllCheeses() async -> [Cheese] {

        var results: [Cheese] = []
        
        do {
            results  = try await supabase.from("cheese").select().order("created_on").execute().value
        }
        catch {
         print(error)
        }
        return results
    }

}

