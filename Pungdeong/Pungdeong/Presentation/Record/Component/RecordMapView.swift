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
    @State private var result: CLLocationCoordinate2D?
    @State private var searchText: String = ""
    @State private var currentKeyword: String = "현재 위치"
    @State private var locationManager = LocationManager()

    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position) {
                
                if let result {
                    Annotation(currentKeyword, coordinate: result) {
                        BluePin(imageName: "햄토리")
                    }
                }
            }

            SearchBar(text: $searchText) {
                search(searchText)
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            setupLocation()
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

    // 검색
    private func search(_ keyword: String) {
        guard !keyword.isEmpty else { return }

        let req = MKLocalSearch.Request()
        req.naturalLanguageQuery = keyword

        MKLocalSearch(request: req).start { response, _ in
            guard let item = response?.mapItems.first else { return }

            let coord = item.placemark.location?.coordinate ?? item.location.coordinate

            DispatchQueue.main.async {
                currentKeyword = item.name ?? keyword
                result = coord   // 👉 기존 핀 교체
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
