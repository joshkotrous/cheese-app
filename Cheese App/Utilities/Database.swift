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
    
    func createUserProfile(userId: String, username: String) async -> Profile? {
        var results: Profile?
        let profile = Profile(user_id: userId, username: username)
        do {
            results = try await supabase.from("profile").insert(profile).select().single().execute().value
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
        print(cheeseCupboard)
        do {
            try await supabase.from("cupboard_cheese").insert(cheeseCupboard).execute().value
        } catch {
            print(error)
        }
    }
    
    func deleteCupboard(cupboardId: String) async -> Void {
        do {
            try await supabase.from("cupboard").delete().eq("id", value: cupboardId).execute().value
        } catch {
            print(error)
        }
    }
    
    func getCheesesForCupboard(cupboardId: String) async -> [CupboardCheeseList] {
        let query = 
        """
            id,
            cheese ( * )
        """
        var result: [CupboardCheeseList] = []
        do {
            result = try await supabase.from("cupboard_cheese").select(query).eq("cupboard_id", value: cupboardId).execute().value
            print(result.count)
            print(result)
        } catch {
            print(error)
        }
        return result
    }
    
    func updateProfile(profileId: String, bio: String, username: String) async -> Void {
        do {
            try await supabase.from("profile").update(["bio": bio,"username": username]).eq("id", value: profileId).execute().value
        } catch {
            print(error)
        }
    }
    
    func signOut() async -> Void{
        do {
            try await supabase.auth.signOut()
            clearAppStorage()
        } catch {
            print(error)
        }
    }
    
    func deleteUser() async -> Void {
        do {
            let userId = UserDefaults.standard.string(forKey: "userId")
            if (userId != nil){
                try await supabase.auth.admin.deleteUser(id: userId!)
            }
            await signOut()
        } catch {
            print(error)
        }
    }
    
    func clearAppStorage() -> Void {
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.removeObject(forKey: "profileId")
    }
    
    func signInWithSupabase(idToken: String, nonce: String) async -> Void {
            do {
                let session = try await Database().supabase.auth.signInWithIdToken(
                    credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
                let userId = session.user.id.uuidString
                UserDefaults.standard.set(session.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(userId, forKey: "userId")
                if(userId != ""){
                    var profile = await getUserProfile(userId: userId)
                    if(profile == nil){
                        profile = await handleFirstTimeSignUp(userId: userId)
                    } else {
                        UserDefaults.standard.set(profile?.id, forKey: "profileId")

                    }
                }
                UserDefaults.standard.set(true, forKey: "isSignedIn")
            } catch {
                print(error)
            }
        }
    
    func handleFirstTimeSignUp(userId: String) async -> Profile? {
            let rand1 = Int.random(in: 0...CheeseWords.count - 1)
            let rand2 = Int.random(in: 0...CheeseWords.count - 1)
            let currentTimestamp = Int(Date().timeIntervalSince1970)
        let username = "\(CheeseWords[rand1])\(CheeseWords[rand2])\(currentTimestamp)".lowercased()
            let profile = await createUserProfile(userId: userId, username: username)
            if (profile?.id != nil){
//                await createCreatedByMeCupboard(profileId: profile?.id ?? "")
                await createDefaultCupboards(profileId: profile?.id ?? "")
                UserDefaults.standard.set(profile?.id, forKey: "profileId")
            }
        
        return profile
    }
    
    func createCreatedByMeCupboard(profileId: String) async -> Void {
        await createNewCupboard(profileId: profileId, cupboardName: "Created By Me")

    }
    
    
    func createDefaultCupboards(profileId: String) async -> Void {
        let defaultCupboards: [Cupboard] = [Cupboard(name: "Eaten", profile_id: profileId), Cupboard(name: "Want to Eat", profile_id: profileId), Cupboard(name: "In the Fridge", profile_id: profileId), Cupboard(name: "Created By Me", profile_id: profileId)]
        do {
            try await supabase.from("cupboard").insert(defaultCupboards).execute().value
            
        } catch {
            print(error)
        }
   
    }
    
    func deleteCupboardCheese(cupboardCheeseId: String) async -> Void {
        do {
            try await supabase.from("cupboard_cheese").delete().eq("id", value: cupboardCheeseId).execute().value
        } catch {
            print(error)
        }
    }
    
    
    func addUserCheese(name: String, description: String, category: String, userId: String) async -> Void {
        print(name, description, category, userId)
        var cheese = UserCheese()
        cheese.name = name
        cheese.description = description
        cheese.category = category
        cheese.user_id = userId
        print(cheese)
        do {
            let userCheese: Cheese = try await supabase.from("user_cheese").insert(cheese).select().single().execute().value
            print(userCheese)
            let cupboard: Cupboard = try await supabase.from("cupboard").select().eq("name", value: "Created By Me").eq("user_id", value: userId).limit(1).single().execute().value
            print(cupboard)
            var cupboardCheese = CheeseCupboard()
            cupboardCheese.cheese_id = userCheese.id
            cupboardCheese.cupboard_id = cupboard.id
            print(cupboardCheese)
            try await supabase.from("cupboard_user_cheese").insert(cupboardCheese).execute().value
        } catch {
            print(error)
        }
    }
    
}

