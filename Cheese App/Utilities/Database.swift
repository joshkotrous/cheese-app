//
//  Database.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/4/24.
//

import Foundation
import Supabase
import os
import GoogleSignIn

class Database {
    let supabase: SupabaseClient

    init(){
        let logger = Logger(subsystem: "Database.init", category: "network")

        let envDict = Bundle.main.infoDictionary?["LSEnvironment"] as! Dictionary<String, String>
        if let url = envDict["SUPABASE_URL"] {
            logger.info("Supabase URL: \(url, privacy: .public)")
        } else {
            logger.error("Supabase URL not found in envDict.")
        }

        if let key = envDict["SUPABASE_ANON_KEY"] {
            logger.info("Supbase key: \(key, privacy: .public)")
        } else {
            logger.error("Supabase key not found in envDict.")
        }

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
            results  = try await supabase.from("cheese").select().neq("community_added", value: "TRUE").order("created_on").execute().value
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
    
    func signInWithSupabase(idToken: String, nonce: String) async throws -> Void {
                let logger = Logger(subsystem: "Database.signInWithSupabase", category: "network")
                logger.info("ID Token:\(idToken, privacy: .public)")
                logger.info("Nonce:\(nonce, privacy: .public)")
                let session = try await Database().supabase.auth.signInWithIdToken(
                    credentials: .init(provider: .apple, idToken: idToken, nonce: nonce))
                let userId = session.user.id.uuidString
                UserDefaults.standard.set(session.accessToken, forKey: "accessToken")
                UserDefaults.standard.set(userId, forKey: "userId")
                if(userId != ""){
                    logger.info("User ID:\(userId, privacy: .public)")
                    var profile = await getUserProfile(userId: userId)
                    if(profile == nil){
                        profile = await handleFirstTimeSignUp(userId: userId)
                    } else {
                        UserDefaults.standard.set(profile?.id, forKey: "profileId")

                    }

                }
                UserDefaults.standard.set(true, forKey: "isSignedIn")
     
        }
    
    func googleSignIn(idToken: String, accessToken: String) async throws {
        let logger = Logger(subsystem: "Database.googleSignIn", category: "network")

       let session = try await supabase.auth.signInWithIdToken(
         credentials: OpenIDConnectCredentials(
           provider: .google,
           idToken: idToken,
           accessToken: accessToken
         )
       )
        let userId = session.user.id.uuidString
        UserDefaults.standard.set(session.accessToken, forKey: "accessToken")
        UserDefaults.standard.set(userId, forKey: "userId")
        if(userId != ""){
            logger.info("User ID:\(userId, privacy: .public)")
            var profile = await getUserProfile(userId: userId)
            if(profile == nil){
                profile = await handleFirstTimeSignUp(userId: userId)
            } else {
                UserDefaults.standard.set(profile?.id, forKey: "profileId")

            }

        }
        UserDefaults.standard.set(true, forKey: "isSignedIn")
     }
    
    func handleFirstTimeSignUp(userId: String) async -> Profile? {
        let rand1 = Int.random(in: 0...AppConfig.cheeseWords.count - 1)
            let rand2 = Int.random(in: 0...AppConfig.cheeseWords.count - 1)
            let currentTimestamp = Int(Date().timeIntervalSince1970)
            let username = "\(AppConfig.cheeseWords[rand1])\(AppConfig.cheeseWords[rand2])\(currentTimestamp)".lowercased()
            let profile = await createUserProfile(userId: userId, username: username)
            if (profile?.id != nil){
                await createDefaultCupboards(profileId: profile?.id ?? "")
                UserDefaults.standard.set(profile?.id, forKey: "profileId")
            }
        
        return profile
    }
    
    func createCreatedByMeCupboard(profileId: String) async -> Void {
        await createNewCupboard(profileId: profileId, cupboardName: AppConfig.createByMe)

    }
    
    
    func createDefaultCupboards(profileId: String) async -> Void {
        var defaultCupboards: [Cupboard] = []
//        [[Cupboard(name: "Eaten", profile_id: profileId), Cupboard(name: "Want to Eat", profile_id: profileId), Cupboard(name: "In the Fridge", profile_id: profileId), Cupboard(name: "Created By Me", profile_id: profileId)]]
        for item in AppConfig.defaultCupboards {
            defaultCupboards.append(Cupboard(name: item, profile_id: profileId))
        }
        
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
    
    
    func createUserCheese(name: String, description: String, category: String, userId: String) async -> Cheese? {
        print(name, description, category, userId)
        var mewCheese: Cheese = Cheese()
        mewCheese.name = name
        mewCheese.description = description
        mewCheese.category = category
        mewCheese.user_id = userId
        mewCheese.community_added = true
        print(mewCheese)
        do {
            let cheese: Cheese = try await supabase.from("cheese").insert(mewCheese).select().single().execute().value
            print(cheese)
            let cupboard: Cupboard = try await supabase.from("cupboard").select().eq("name", value: AppConfig.createByMe).eq("user_id", value: userId).single().execute().value
            print(cupboard)
            var cupboardCheese = CheeseCupboard()
            cupboardCheese.cheese_id = cheese.id!
            cupboardCheese.cupboard_id = cupboard.id!
            print(cupboardCheese)
            try await supabase.from("cupboard_cheese").insert(cupboardCheese).execute().value
            return cheese

        } catch {
            print(error)
            return nil
        }
    }
    
    func deleteUserCheese(cheeseId: String, userId: String) async -> Void {
        do {
            try await supabase.from("cheese").delete().eq("id", value: cheeseId).execute().value
        } catch {
            print(error)
        }
    }
    
    func searchForCheeses(query: String) async -> [Cheese] {
        var result: [Cheese] = []
        print(query)
        do {
//            result = try await supabase.from("cheese").select().like("name", pattern: "%\(query)%").execute().value
            result = try await supabase.from("cheese").select().or("name.ilike.%\(query.trimmingCharacters(in: .whitespaces))%,category.ilike.%\(query.trimmingCharacters(in: .whitespaces))%").execute().value
            print(result)
        } catch {
            print(error)
        }
        
        return result
    }
    
    func uploadCheesePhoto(image: UIImage, cheeseId: String) async -> Void {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert UIImage to Data")
            return
        }
        let fileName = "\(cheeseId).jpg"
        let filePath = "public/\(fileName)"
        do {
            try await supabase.storage.from("cheese_images").upload(
                path: filePath,
                file: imageData,
                options: FileOptions(
                  cacheControl: "3600",
                  contentType: "image/jpeg",
                  upsert: false
                )
            )
            let imageUrl = try supabase.storage.from("cheese_images").getPublicURL(path: filePath)
            try await supabase.from("cheese").update(["image": imageUrl]).eq("id", value: cheeseId).execute().value
            
        } catch {
            print(error)
        }
    }
    
    func uploadProfileImage(image: UIImage, profileId: String) async -> Void {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Failed to convert UIImage to Data")
            return
        }
        let fileName = "\(profileId).jpg"
        let filePath = "public/\(fileName)"
        do {
            try await supabase.storage.from("profile_images").upload(
                path: filePath,
                file: imageData,
                options: FileOptions(
                  cacheControl: "3600",
                  contentType: "image/jpeg",
                  upsert: false
                )
            )
            let imageUrl = try supabase.storage.from("profile_images").getPublicURL(path: filePath)
            try await supabase.from("profile").update(["image": imageUrl]).eq("id", value: profileId).execute().value
            
        } catch {
            print(error)
        }
    }
    
}

