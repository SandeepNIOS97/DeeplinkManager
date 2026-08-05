import SwiftUI
import UIKit

struct CountryCardView: View {
    let country: Country

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                if !country.monumentImage.isEmpty {
                    // SF Symbol
                    let name = String(country.monumentImage)
                    Image(name)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .foregroundStyle(.secondary)
                        .background(Color(.systemGray5))
                } else if let url = URL(string: country.monumentImage) {
                    // Remote image
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .frame(maxWidth: .infinity)
                                .clipped()
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .foregroundStyle(.secondary)
                                .frame(maxWidth: .infinity)
                                .background(Color(.systemGray5))
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Color(.systemGray5)
                        .frame(height: 180)
                        .frame(maxWidth: .infinity)
                }
            }
            .cornerRadius(12)

            // Name overlay
            Text(country.name)
                .font(.headline)
                .foregroundColor(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(.black.opacity(0.5))
                .cornerRadius(12, corners: [.bottomLeft, .bottomRight])
        }
        .frame(maxWidth: .infinity, minHeight: 180)
        .shadow(radius: 3)
    }
}

// corner radius helper for specific corners
fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct CountryCardView_Previews: PreviewProvider {
    static var previews: some View {
        CountryCardView(country: Country(name: "France", monumentName: "Eiffel Tower", monumentImage: "sf:tram.fill", countryDescription: "France is...", monumentDescription: "Eiffel Tower is..."))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
