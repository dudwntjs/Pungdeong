import SwiftUI
import MusicKit

struct RecordMusicSection: View {
    @Binding var song: RecordSong?
    @State private var showsSearch = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("오늘 빠진 노래")
                .font(.headline)

            if let song {
                RecordSongRow(song: song)
                HStack {
                    Button("변경") { showsSearch = true }
                    Button("삭제", role: .destructive) { self.song = nil }
                    Spacer()
                    if let url = song.url {
                        Link("Apple Music에서 듣기", destination: url)
                    }
                }
                .font(.subheadline)
            } else {
                Button { showsSearch = true } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "music.note")
                            .font(.title2)
                        VStack(alignment: .leading, spacing: 4) {
                            Text("노래 추가하기").font(.subheadline.bold())
                            Text("푹 빠져 들었던 한 곡을 남겨보세요")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "plus")
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.blue.opacity(0.06), in: RoundedRectangle(cornerRadius: 16))
                }
                .buttonStyle(.plain)
            }
        }
        .sheet(isPresented: $showsSearch) {
            RecordMusicSearchView { song = $0 }
        }
    }
}

private struct RecordSongRow: View {
    let song: RecordSong

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: song.artworkURL) { image in
                image.resizable().scaledToFill()
            } placeholder: {
                ZStack {
                    Color.blue.opacity(0.08)
                    Image(systemName: "music.note").foregroundStyle(.blue)
                }
            }
            .frame(width: 56, height: 56)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text(song.title).font(.subheadline.bold()).lineLimit(2)
                Text(song.artistName).font(.caption).foregroundStyle(.secondary).lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .contentShape(Rectangle())
    }
}

private struct RecordMusicSearchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase
    @State private var query = ""
    @State private var songs: [RecordSong] = []
    @State private var isLoading = false
    @State private var message: String?
    @State private var needsSettings = false
    @State private var retryID = 0
    let onSelect: (RecordSong) -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
                    TextField("노래 제목 또는 아티스트", text: $query)
                        .autocorrectionDisabled()
                        .submitLabel(.search)
                    if !query.isEmpty {
                        Button { query = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                        .accessibilityLabel("검색어 지우기")
                    }
                }
                .padding(14)
                .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 14))
                .padding()

                if isLoading {
                    Spacer()
                    ProgressView("노래를 찾고 있어요")
                    Spacer()
                } else if let message {
                    Spacer()
                    ContentUnavailableView {
                        Label("노래 검색", systemImage: "music.note")
                    } description: {
                        Text(message)
                    } actions: {
                        if needsSettings, let url = URL(string: UIApplication.openSettingsURLString) {
                            Link("설정 열기", destination: url)
                        } else {
                            Button("다시 시도") { retryID += 1 }
                        }
                    }
                    Spacer()
                } else if query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView("어떤 노래에 빠졌나요?", systemImage: "music.note",
                                           description: Text("Apple Music에서 한 곡을 찾아 기록에 담아보세요."))
                } else if songs.isEmpty {
                    ContentUnavailableView.search(text: query)
                } else {
                    List(songs) { song in
                        Button {
                            onSelect(song)
                            dismiss()
                        } label: {
                            RecordSongRow(song: song)
                                .foregroundStyle(.primary)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("노래 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("닫기") { dismiss() }
                }
            }
        }
        .task(id: SearchID(query: query, retry: retryID)) { await search() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active, needsSettings { retryID += 1 }
        }
    }

    private struct SearchID: Equatable {
        let query: String
        let retry: Int
    }

    @MainActor
    private func search() async {
        let term = query.trimmingCharacters(in: .whitespacesAndNewlines)
        songs = []
        message = nil
        needsSettings = false
        isLoading = !term.isEmpty
        guard !term.isEmpty else { return }

        do {
            try await Task.sleep(for: .milliseconds(350))
            let status = await MusicAuthorization.request()
            try Task.checkCancellation()
            guard status == .authorized else {
                needsSettings = status == .denied
                message = status == .restricted
                    ? "이 기기에서는 Apple Music 접근이 제한되어 있어요."
                    : "노래를 검색하려면 설정에서 Apple Music 접근을 허용해 주세요."
                isLoading = false
                return
            }

            var request = MusicCatalogSearchRequest(term: term, types: [Song.self])
            request.limit = 25
            let response = try await request.response()
            try Task.checkCancellation()
            songs = response.songs.map {
                RecordSong(id: $0.id.rawValue, title: $0.title, artistName: $0.artistName,
                           artworkURL: $0.artwork?.url(width: 200, height: 200), url: $0.url)
            }
            isLoading = false
        } catch {
            guard !Task.isCancelled else { return }
            message = "노래를 불러오지 못했어요. 연결 상태를 확인하고 다시 시도해 주세요."
            isLoading = false
        }
    }
}
