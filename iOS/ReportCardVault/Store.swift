import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [ReportCard] = []
    @Published var isPro: Bool = false

    static let freeLimit = 200

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("reportcardvault_items.json")
        load()
    }

    var isAtFreeLimit: Bool {
        !isPro && items.count >= Store.freeLimit
    }

    func add(_ item: ReportCard) -> Bool {
        guard !isAtFreeLimit else { return false }
        items.insert(item, at: 0)
        save()
        return true
    }

    func update(_ item: ReportCard) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: ReportCard) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        guard let data = try? Data(contentsOf: fileURL),
              let decoded = try? JSONDecoder().decode([ReportCard].self, from: data) else {
            items = [
        ReportCard(childName: "Sample Childname 1", term: "Sample Term 1", subject: "Sample Subject 1", grade: "Sample Grade 1", year: 2020),
        ReportCard(childName: "Sample Childname 2", term: "Sample Term 2", subject: "Sample Subject 2", grade: "Sample Grade 2", year: 2021),
        ReportCard(childName: "Sample Childname 3", term: "Sample Term 3", subject: "Sample Subject 3", grade: "Sample Grade 3", year: 2022)
            ]
            save()
            return
        }
        items = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
