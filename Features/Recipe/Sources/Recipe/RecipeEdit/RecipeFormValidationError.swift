import Foundation

enum RecipeFormValidationError: Equatable {
    case emptyTitle
    case emptyDescription
    case emptyStepText(id: UUID)
    case emptyTopTextBlockText
    case emptyBottomTextBlockText
}

extension RecipeFormValidationError {
    var fieldKey: String {
        switch self {
        case .emptyTitle: return "title"
        case .emptyDescription: return "description"
        case .emptyStepText(let id): return "step/\(id.uuidString)/text"
        case .emptyTopTextBlockText: return "topTextBlock/text"
        case .emptyBottomTextBlockText: return "bottomTextBlock/text"
        }
    }

    static func errors(from fieldErrors: [String: String]) -> [RecipeFormValidationError] {
        var result: [RecipeFormValidationError] = []
        for key in fieldErrors.keys {
            switch key {
            case "title": result.append(.emptyTitle)
            case "description": result.append(.emptyDescription)
            case "topTextBlock/text": result.append(.emptyTopTextBlockText)
            case "bottomTextBlock/text": result.append(.emptyBottomTextBlockText)
            default:
                if key.hasPrefix("step/"), key.hasSuffix("/text") {
                    let uuidString = String(key.dropFirst(5).dropLast(5))
                    if let id = UUID(uuidString: uuidString) {
                        result.append(.emptyStepText(id: id))
                    }
                }
            }
        }
        return result
    }
}
