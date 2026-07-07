import Foundation

struct ReportCard: Identifiable, Codable, Equatable {
    let id: UUID
    var childName: String
    var term: String
    var subject: String
    var grade: String
    var year: Int

    init(id: UUID = UUID(), childName: String = "", term: String = "", subject: String = "", grade: String = "", year: Int = 0) {
        self.id = id
        self.childName = childName
        self.term = term
        self.subject = subject
        self.grade = grade
        self.year = year
    }
}
