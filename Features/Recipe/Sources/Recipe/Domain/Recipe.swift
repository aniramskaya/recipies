import Foundation

public struct Recipe: Sendable, Identifiable {
    public let id: UUID
    public let imageSource: URL
    public let cookingTimeMins: Int
    public let complexity: Int
    public let title: String
    public let description: String?
    public let ingredients: [Ingredient]
    public let topText: TextBlock?
    public let steps: [RecipeStep]
    public let bottomText: TextBlock?
    
    public init(id: UUID, imageSource: URL, cookingTimeMins: Int, complexity: Int, title: String, description: String?, ingredients: [Ingredient], topText: TextBlock?, steps: [RecipeStep], bottomText: TextBlock?) {
        self.id = id
        self.imageSource = imageSource
        self.cookingTimeMins = cookingTimeMins
        self.complexity = complexity
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.topText = topText
        self.steps = steps
        self.bottomText = bottomText
    }
}

public struct Ingredient: Sendable {
    public let isOn: Bool
    public let name: String
    
    public init(isOn: Bool = false, name: String) {
        self.isOn = isOn
        self.name = name
    }
}

public struct RecipeStep: Sendable, Identifiable {
    public let id: UUID
    public let title: String
    public let imageSource: URL?
    public let text: String
    
    public init(id: UUID, title: String, imageSource: URL?, text: String) {
        self.id = id
        self.title = title
        self.imageSource = imageSource
        self.text = text
    }
}

public struct TextBlock: Sendable {
    public let text: String
    public let title: String?
    
    public init(text: String, title: String?) {
        self.text = text
        self.title = title
    }
}
