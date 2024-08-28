//
//  AppConfig.swift
//  Cheese App
//
//  Created by Josh Kotrous on 8/23/24.
//

import Foundation
import SwiftUI

struct AppConfig {
    static let fontName = "IowanOldStyle-Roman"
    static let createByMe = "Created By Me"
    static let eaten = "Eaten"
    static let inTheFridge = "In the Fridge"
    static let wantToEat = "Want to Eat"
    static let reviewedByMe = "Reviewed By Me"
    static let tan = "#FFF5DC"
    static let tan1 = "#FAEBC6"
    static let tan2 = "#6C5B30"
    static let tan3 = "#C2A253"
    static let defaultCupboards = [AppConfig.createByMe, AppConfig.eaten, AppConfig.inTheFridge, AppConfig.wantToEat, AppConfig.reviewedByMe]
    static let cheeseWords: [String] = [
        // Cheese names
        "Cheddar", "Brie", "Gouda", "Swiss", "Feta", "Havarti", "Camembert",
        "Gruyere", "Manchego", "Monterey", "Fontina", "Asiago", "Ricotta",
        "Colby", "Parmesan", "Provolone", "Gorgonzola", "Roquefort", "Pecorino",
        "Romano", "Stilton", "Blue", "Muenster", "Boursin", "Paneer", "Queso",
        "Cotija", "Halloumi", "Mascarpone", "Quesillo", "Cheshire", "Reblochon",
        "Jarlsberg", "Taleggio", "Bocconcini", "Stracchino", "Chevre", "Neufchatel",
        "Chevrotin", "Wensleydale", "Burrata", "Comte", "Edam", "Limburger",
        "Brillat", "Tilsit", "PortSalut", "Fromage", "Boursault", "Cotoletta",
        "Pimento", "RedWindsor", "Stinking", "BleudAuvergne", "Beaufort",
        "Banon", "Caboc", "Casciotta", "Castelmagno", "Chabichou", "Crescenza",
        "Crozier", "Derby", "Dorstone", "Epoisses", "Fiore", "Gamay", "Gaperon",
        "Gjetost", "Idiazabal", "Livarot", "Mahon", "Ogleshield", "Orkney",
        "PavedAffinois", "Reblechon", "Roccolo", "Roncal", "Roulade",
        "SainteMaure", "Samso", "Serpa", "Shropshire", "Sottocenere", "Teifi",
        "Tomme", "Vacherin", "Valdeon", "Valencay", "Washed",
        
        // Cheese-related words
        "Curds", "Whey", "Rennet", "Cultures", "Aging", "Mold", "Paste",
        "Wedge", "Block", "Wheel", "Crumbly", "Creamy", "Sharp", "Mild",
        "Aged", "Fresh", "Melt", "Grate", "Slice", "Spread", "Fondue",
        "Cave", "Brine", "Fermentation", "Crust", "Rind", "Smoked", "Artisan",
        "Lactic", "Moldy", "Cheeseboard", "Cracker", "Gourmet", "Dairy",
        "Cheesemonger", "Deli", "Goat", "Sheep", "Cow", "Buffalo", "Organic",
        "Grassfed", "Pasteurized", "Unpasteurized", "Homemade", "Farmhouse",
        "Creamery", "Cheesecloth", "Churn", "Starter", "Ferment", "Lactose",
        "Affineur", "Tasting", "Pairing", "Fondue", "Raclette", "Probiotic",
        "Lactobacillus", "Acidic", "Salty", "Buttery", "Nutty", "Tangy",
        "Zesty", "Ripe", "Bacteria", "Soft", "Hard", "SemiHard", "Cheesemaking"
    ]
    static let termsAndConditions = "Terms and conditions"
}
