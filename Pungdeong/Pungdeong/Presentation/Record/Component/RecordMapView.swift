//
//  RecordMapView.swift
//  Pungdeong
//
//  Created by sun on 4/17/26.
//

import SwiftUI
import MapKit

struct RecordMapView: View {
    @State private var position: MapCameraPosition = .automatic
    @Binding var result: CLLocationCoordinate2D?
    @Binding var currentKeyword: String

    @State private var searchText: String = ""
    @State private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position) {
                if let result {
                    Annotation(currentKeyword, coordinate: result) {
                        BluePin(imageName: "Progress2")
                    }
                }
            }

            SearchBar(text: $searchText) {
                search(searchText)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            if let coord = result {
                position = .region(
                    MKCoordinateRegion(
                        center: coord,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    )
                )
            } else {
                setupLocation()
            }
        }
    }

    private func setupLocation() {
        locationManager.onUpdate = { loc in
            let coord = loc.coordinate

            DispatchQueue.main.async {
                if result == nil {
                    result = coord
                    currentKeyword = "현재 위치"
                    position = .region(
                        MKCoordinateRegion(
                            center: coord,
                            latitudinalMeters: 1000,
                            longitudinalMeters: 1000
                        )
                    )
                }
            }
        }
    }

    private func search(_ keyword: String) {
        guard !keyword.isEmpty else { return }

        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = keyword

        MKLocalSearch(request: req).start { response, _ in
            guard let item = response?.mapItems.first else { return }

            let coord = item.placemark.coordinate

            DispatchQueue.main.async {
                currentKeyword = item.name ?? keyword
                result = coord
                position = .region(
                    MKCoordinateRegion(
                        center: coord,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    )
                )
            }
        }
    }
}
