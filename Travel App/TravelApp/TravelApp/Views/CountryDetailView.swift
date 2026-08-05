import SwiftUI

struct CountryDetailView: View {
    @StateObject var detailVM: CountryDetailVM

    init(detailVM: CountryDetailVM) {
        self._detailVM = StateObject(wrappedValue: detailVM)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    if let monumentImage = detailVM.country?.monumentImage, !monumentImage.isEmpty {
                        Image(String(monumentImage))
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(4)
                            .frame(height: 240)
                            .frame(maxWidth: .infinity)
//                            .foregroundStyle(.accentColor)
                    } else if let monumentImage = detailVM.country?.monumentImage, let url = URL(string: monumentImage) {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                                    .frame(height: 240)
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 240)
                                    .clipped()
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 120)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Color(.systemGray5)
                            .frame(height: 240)
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(detailVM.country?.monumentName ?? "")
                        .font(.title2)
                        .bold()

                    Text(detailVM.country?.monumentDescription ?? "")
                        .font(.body)

                    Divider()

                    Text("About \(detailVM.country?.name ?? "")")
                        .font(.headline)

                    Text(detailVM.country?.countryDescription ?? "")
                        .font(.body)
                }
                .padding([.horizontal])
            }
        }
        .task {
            await detailVM.load()
        }
        .navigationTitle(detailVM.country?.name ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}

