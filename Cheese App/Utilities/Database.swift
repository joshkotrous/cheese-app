//
//  Database.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import Foundation
import Supabase



class Database {
    let supabase: SupabaseClient
    
    init(){
        guard
            let supabaseURLString = ProcessInfo.processInfo.environment["SUPABASE_URL"],
            let supabaseURL = URL(string: supabaseURLString),
            let supabaseKey = ProcessInfo.processInfo.environment["SUPABASE_ANON_KEY"]
        else {
            fatalError("Supabase environment variables are not set correctly.")
        }
        print(supabaseURL)
        print(supabaseKey)
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
    
    func getAllCategories() async -> [Category] {
        var results: [Category] = []
        do {
            results = try await supabase.from("categories").select().execute().value
        }
        catch {
            print (error)
        }
        return results
    }
    
    func getAllGateways() async -> [Gateway] {
        var results: [Gateway] = []
        do {
            results = try await supabase.from("gateways").select().execute().value
        }
        catch {
            print(error)
        }
        return results
    }

}

