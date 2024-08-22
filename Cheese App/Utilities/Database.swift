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
        let envDict = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, String>
        guard
            let supabaseURLString = envDict["SUPABASE_URL"],
            let supabaseURL = URL(string: supabaseURLString),
            let supabaseKey = envDict["SUPABASE_ANON_KEY"]
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
    
    func getCheesesByCategory(category: String) async -> [Cheese] {
        var results: [Cheese] = []
        do {
            results = try await supabase.from("cheese").select().eq("category", value: category).execute().value
        }
        catch {
            print(error)
        }
        return results
    }
    
    func getUserProfile(userId: String) async -> Profile? {
        var results: [Profile] = []
        do {
            results = try await supabase.from("profile").select().eq("user_id", value: userId).limit(1).execute().value
        } catch {
            print(error)
        }
        if (results.count > 0){
            return results[0]
        }
        return nil
    }
    
    func createUserProfile(userId: String) async -> Profile? {
        var results: Profile?
        let profile = Profile(user_id: userId)
        do {
            try await supabase.from("profile").insert(profile).execute().value
            results = await getUserProfile(userId: userId)
        } catch {
            print(error)
        }
        return results
    }
    
    func getUserCupboards(profileId: String) async -> [Cupboard] {
        var results: [Cupboard] = []
        do {
            results = try await supabase.from("cupboard").select().eq("profile_id", value: profileId).execute().value
        } catch {
            print(error)
        }
        return results
    }
    
    func createNewCupboard(profileId: String, cupboardName: String) async -> Void {
        var cupboard = Cupboard()
        cupboard.name = cupboardName
        cupboard.profile_id = profileId
        do {
            try await supabase.from("cupboard").insert(cupboard).execute().value
        } catch {
            print(error)
        }
    }
    
    func addCheeseToCupboard(cupboardId: String, cheeseId:  String) async -> Void {
        var cheeseCupboard = CheeseCupboard()
        cheeseCupboard.cheese_id = cheeseId
        cheeseCupboard.cupboard_id = cupboardId
        do {
            try await supabase.from("cupboard_cheese").insert(cheeseCupboard).execute().value
        } catch {
            print(error)
        }
    }

}

