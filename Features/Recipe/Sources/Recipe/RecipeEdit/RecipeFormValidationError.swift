import Foundation

enum RecipeFormValidationError: Equatable {
    case emptyTitle
    case emptyDescription
    case emptyStepText(id: UUID)
    case emptyTopTextBlockText
    case emptyBottomTextBlockText
}
