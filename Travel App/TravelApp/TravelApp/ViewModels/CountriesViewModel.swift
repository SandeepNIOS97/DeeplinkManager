import Foundation
import Combine

final class CountriesViewModel: ObservableObject {
    @Published var countries: [Country] = []
    @Published var errorMessage: String?

    private let loader: CountriesLoading

    init(loader: CountriesLoading = BundleCountriesLoader()) {
        self.loader = loader
    }

    func loadCountries() {
        Task {
            do {
                let decoded = try await loader.loadCountries()
                DispatchQueue.main.async {
                    self.countries = decoded
                }
            } catch {
                self.errorMessage = "Failed to load countries: \(error.localizedDescription)"
            }
        }
    }
}
