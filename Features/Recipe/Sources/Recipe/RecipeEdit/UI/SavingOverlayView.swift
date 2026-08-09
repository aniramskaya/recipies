//import SwiftUI
//
//struct SavingOverlayView: View {
//    let savingState: SavingState
//    let onClose: () -> Void
//
//    var body: some View {
//        switch savingState {
//        case .idle:
//            EmptyView()
//        case .saving:
//            Color.black.opacity(0.3)
//                .ignoresSafeArea()
//                .overlay {
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                        .tint(.white)
//                        .scaleEffect(1.5)
//                }
//                .accessibilityIdentifier(RecipeEditA11y.savingOverlay)
//        case .succeeded:
//            Color.black.opacity(0.3)
//                .ignoresSafeArea()
//                .overlay {
//                    Text("Рецепт сохранён")
//                        .font(.headline)
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.green.opacity(0.9))
//                        .cornerRadius(12)
//                }
//                .accessibilityIdentifier(RecipeEditA11y.successOverlay)
//        case .failed(let error):
//            Color.black.opacity(0.3)
//                .ignoresSafeArea()
//                .overlay {
//                    VStack(spacing: 16) {
//                        Text(error.localizedDescription)
//                            .font(.body)
//                            .foregroundColor(.white)
//                            .multilineTextAlignment(.center)
//                        Button("Закрыть", action: onClose)
//                            .foregroundColor(.white)
//                            .padding(.horizontal, 24)
//                            .padding(.vertical, 8)
//                            .background(Color.white.opacity(0.2))
//                            .cornerRadius(8)
//                            .accessibilityIdentifier(RecipeEditA11y.errorOverlayCloseButton)
//                    }
//                    .padding()
//                    .background(Color.red.opacity(0.85))
//                    .cornerRadius(12)
//                    .padding(.horizontal, 32)
//                }
//                .accessibilityIdentifier(RecipeEditA11y.errorOverlay)
//        }
//    }
//}
