//
//  BundleCountriesLoader.swift
//  TravelApp
//
//  Created by Sandeep Nigam on 05/08/26.
//

import Foundation

/// Loads countries.json from a Bundle. Injectable for testability.
struct BundleCountriesLoader: CountriesLoading {
    private let bundle: Bundle
    private let resourceName: String
    private let decoder: JSONDecoder

    init(bundle: Bundle = .main,
         resourceName: String = "countries",
         decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.resourceName = resourceName
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func loadCountries() async throws -> [Country] {
        guard let url = bundle.url(forResource: resourceName, withExtension: "json") else {
            throw LoaderError.resourceNotFound(resourceName)
        }
        let data = try Data(contentsOf: url)
        do {
            return try decoder.decode([Country].self, from: data)
        } catch {
            throw LoaderError.decodingFailed(error)
        }
    }
}

enum LoaderError: Error, LocalizedError {
    case resourceNotFound(String)
    case decodingFailed(Error)

    var errorDescription: String? {
        switch self {
        case .resourceNotFound(let name):
            return "\(name).json not found in bundle"
        case .decodingFailed(let wrapped):
            return "Decoding failed: \(wrapped.localizedDescription)"
        }
    }
}
