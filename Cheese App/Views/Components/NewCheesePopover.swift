//
//  NewCheesePopover.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/5/24.
//

import SwiftUI

class NewCheesePopoverModel: ObservableObject {
    @Published var categories: [Category] = []
    @Published var selectedCategory: String = ""
    @Published var cheeseName: String = ""
    @Published var description: String = ""
    @Published var notes: String = ""

}

struct NewCheesePopover: View {

    @StateObject var viewModel = NewCheesePopoverModel()
    
    @AppStorage("userId") var userId: String?
    @Binding var showNewCheesePopover: Bool
    @State var image: UIImage?
//    @State var imagePickerSourceType: UIImagePickerController.SourceType = .camera
    @State private var showActionSheet = false
    @State var showImagePicker: Bool = false
    @State var isLoading: Bool = false

    let cupboardId: String?
    let cupboardName: String?
    
    var body: some View {
        var imagePickerSourceType: UIImagePickerController.SourceType = .camera

        ZStack{
            
            CustomColors.background
                .ignoresSafeArea(.all)
            
            if isLoading {
                ProgressView() // Spinner shown when loading
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5) // Make the spinner larger if needed
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .zIndex(100)
            }
            
            VStack {
                Text("Add Cheese")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.custom(AppConfig.fontName, size: 24))
                    .fontWeight(.bold)
                ZStack{
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(maxWidth: .infinity) // Allow the image to take up the full width
                    }
                    Menu {
                        Button(action: {
                            imagePickerSourceType = .camera
                            showImagePicker = true
                        }) {
                            Label("Take Photo", systemImage: "camera")
                        }
                        
                        Button(action: {
                            imagePickerSourceType = .photoLibrary
                            showImagePicker = true
                        }) {
                            Label("Photo Library", systemImage: "photo.on.rectangle")
                        }
                        Button(role: .destructive, action: {
                            if image != nil {
                                image = nil
                            }
                        }) {
                            Label("Remove Image", systemImage: "xmark")
                        }
                        
                    } label: {
                        if image != nil {
                            Label("Edit Photo", systemImage: "camera")
                                .padding()
                                .foregroundColor(CustomColors.textColor)
                                .background(CustomColors.button)
                                .cornerRadius(18)
                        } else {
                            Label("Add Photo", systemImage: "camera")
                                .padding()
                                .foregroundColor(CustomColors.textColor)
                        }
                        
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ZStack{
                            Color.black.edgesIgnoringSafeArea(.all)
                            ImagePicker(image: $image, sourceType: imagePickerSourceType)

                        }
                            
                        
                    }
                }.frame(width: 250, height: 250)
                    .background(CustomColors.button) // Set the background color
                    .cornerRadius(28)
                    .padding()
                VStack(spacing: 2){
                    Text("Cheese name")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(AppConfig.fontName, size: 18))
                    TextField("", text: $viewModel.cheeseName, prompt: Text("").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                        .foregroundColor(CustomColors.textColor)
                        .padding(8)
                        .font(.custom(AppConfig.fontName, size: 18))
                        .background(RoundedRectangle(cornerRadius: 12).fill(CustomColors.tan1))
                }
  
                VStack(spacing: 2){
                    Text("Cheese Category")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(AppConfig.fontName, size: 18))
                Menu(content: {
                    
                    ForEach(viewModel.categories) { category in
                        Button(action:{
                            viewModel.selectedCategory = category.category
                        }){
                            Text(category.category)
                        }
                        
                    }
                    
                }, label: {
                        
                        
               
                        HStack{
                            Text(viewModel.selectedCategory)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .font(.custom(AppConfig.fontName, size: 18))
                                .padding(12)
                            Image(systemName: "chevron.down")
                                .padding(12)
                        }
                        .background(CustomColors.tan1)
                        .cornerRadius(12)
                 
                })
                }

                TextField("", text: $viewModel.notes, prompt: Text("Notes").foregroundColor(CustomColors.textColor).font(.custom(AppConfig.fontName, size: 18)))
                    .foregroundColor(CustomColors.textColor)
                    .font(.custom(AppConfig.fontName, size: 18))
                
                VStack(spacing: 2){
                    Text("Description")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.custom(AppConfig.fontName, size: 18))
                    TextEditor(text: $viewModel.description)
                            .foregroundColor(CustomColors.textColor) // Set the text color
                            .font(.custom(AppConfig.fontName, size: 18)) // Set the custom font and size
                            .frame(height: 100, alignment: .top)
                            .scrollContentBackground(.hidden) // <- Hide it
                            .cornerRadius(12)
                            .background(RoundedRectangle(cornerRadius: 12).fill(CustomColors.tan1))


                            .padding(4)
                }
        
                    
                Button(action: {
                    Task{
                        isLoading = true
                        var cheese: Cheese?

                        if (viewModel.cheeseName != ""){
                           cheese = await Database().createUserCheese(name: viewModel.cheeseName, description: viewModel.description, category: viewModel.selectedCategory, userId: userId ?? "")
                        }
                        
                        if (cupboardId != "" && (cheese?.id != "" || cheese?.id != nil) && cupboardName != AppConfig.createByMe){
                            await Database().addCheeseToCupboard(cupboardId: cupboardId!, cheeseId: cheese?.id ?? "")
                        }
                        
                        if image != nil {
                            await Database().uploadCheesePhoto(image: image!, cheeseId: cheese?.id ?? "")
                        }
                        showNewCheesePopover = false
                        isLoading = false
                   
                    }
                    
                }) {
                    Text("Add")
                        .frame(maxWidth: .infinity)
                        .font(.custom(AppConfig.fontName, size: 18))
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(CustomColors.tan1)

                }
                .foregroundColor(CustomColors.textColor)
                .cornerRadius(16)
                Spacer()
            }
            .foregroundColor(CustomColors.textColor)
            .padding()
        }.task {
            viewModel.categories = await Database().getAllCategories()
        }
    }
}

struct NewCheesePopoverViewPreview: View {
    @State var showCheesePopover: Bool = true
    var body: some View{
        NewCheesePopover(showNewCheesePopover: $showCheesePopover, cupboardId: "", cupboardName: "")
    }
}

#Preview {
        NewCheesePopoverViewPreview()
}
