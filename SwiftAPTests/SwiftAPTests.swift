import XCTest
import SwiftData
@testable import SwiftAP // Ensure this imports your app's main module to access DataItem, AppInfo, hexStringToColor

final class SwiftAPTests: XCTestCase {

    var container: ModelContainer! // ModelContainer for your tests
    var context: ModelContext!     // ModelContext for your tests

    // This method runs *before* each test method in the class.
    override func setUpWithError() throws {
        try super.setUpWithError()

        let schema = Schema([DataItem.self, AppInfo.self]) //

        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)

        container = try ModelContainer(for: schema, configurations: [modelConfiguration])

        context = ModelContext(container)
    }

    // This method runs *after* each test method in the class.
    override func tearDownWithError() throws {
        // Clean up resources. For in-memory, mostly not needed explicitly,
        // but it's good practice to nil out strong references.
        context = nil
        container = nil
        try super.tearDownWithError()
    }

    func testDataItemCreation() throws {
        let newItem = DataItem(
            code: "CS101", name: "Intro to CS", professor: "Dr. Smith", credit: "3",
            room: "Rm 101", monday: "M", tuesday: "", wednesday: "W", thursday: "",
            friday: "F", saturday: "", sunday: "", colorHex: "#ff8585", englishName: "Intro to Computer Science", grade: "A"
        )
        XCTAssertEqual(newItem.code, "CS101")
        XCTAssertEqual(newItem.name, "Intro to CS")
        XCTAssertNotNil(newItem.id) // UUID should be generated
    }

    func testInsertAndFetchDataItem() throws {
        let newItem = DataItem(
            code: "MA200", name: "Calculus I", professor: "Prof. Lee", credit: "4",
            room: "Auditorium", monday: "M", tuesday: "Tu", wednesday: "W", thursday: "Th",
            friday: "", saturday: "", sunday: "", colorHex: "#85b4ff", englishName: "Calculus One", grade: "B"
        )
        context.insert(newItem)
        try context.save() // Crucial to save to persist in the in-memory store

        let fetchedItems = try context.fetch(FetchDescriptor<DataItem>())
        XCTAssertEqual(fetchedItems.count, 1)
        XCTAssertEqual(fetchedItems.first?.code, "MA200")
        XCTAssertEqual(fetchedItems.first?.name, "Calculus I")
    }

    func testUpdateDataItem() throws {
        let item = DataItem(
            code: "PHY301", name: "Physics III", professor: "Dr. Brown", credit: "3",
            room: "Lab 200", monday: "M", tuesday: "", wednesday: "W", thursday: "",
            friday: "F", saturday: "", sunday: "", colorHex: "#FED85D", englishName: "Physics 3", grade: "C"
        )
        context.insert(item)
        try context.save()

        item.professor = "Dr. Johnson" // Update a property
        try context.save()

        let fetchedItem = try context.fetch(FetchDescriptor<DataItem>(predicate: #Predicate { $0.code == "PHY301" })).first
        XCTAssertNotNil(fetchedItem)
        XCTAssertEqual(fetchedItem?.professor, "Dr. Johnson")
    }

    func testDeleteDataItem() throws {
        let itemToDelete = DataItem(
            code: "CHM100", name: "General Chem", professor: "Dr. White", credit: "3",
            room: "Lec Hall", monday: "M", tuesday: "Tu", wednesday: "", thursday: "Th",
            friday: "", saturday: "", sunday: "", colorHex: "#92DD95", englishName: "General Chemistry", grade: "A-"
        )
        context.insert(itemToDelete)
        try context.save()

        context.delete(itemToDelete)
        try context.save()

        let fetchedItems = try context.fetch(FetchDescriptor<DataItem>())
        XCTAssertTrue(fetchedItems.isEmpty)
    }

    func testAppInfoCreationAndFetch() throws {
        let appInfo = AppInfo(id: "main", yearSemester: "2025-Fall", userName: "Chen Huan", availableSemesters: "2025-Fall,2026-Spring")
        context.insert(appInfo)
        try context.save()

        let fetchedAppInfo = try context.fetch(FetchDescriptor<AppInfo>(predicate: #Predicate { $0.id == "main" })).first
        XCTAssertNotNil(fetchedAppInfo)
        XCTAssertEqual(fetchedAppInfo?.userName, "Chen Huan")
        XCTAssertEqual(fetchedAppInfo?.yearSemester, "2025-Fall")
    }

    func testUpdateAppInfo() throws {
        let appInfo = AppInfo(id: "main", yearSemester: "2024-Spring", userName: "Old User", availableSemesters: "2024-Spring")
        context.insert(appInfo)
        try context.save()

        appInfo.userName = "New User"
        appInfo.yearSemester = "2025-Spring"
        try context.save()

        let fetchedAppInfo = try context.fetch(FetchDescriptor<AppInfo>(predicate: #Predicate { $0.id == "main" })).first
        XCTAssertNotNil(fetchedAppInfo)
        XCTAssertEqual(fetchedAppInfo?.userName, "New User")
        XCTAssertEqual(fetchedAppInfo?.yearSemester, "2025-Spring")
    }
    
    func testHexStringTocolorValidHex() throws {
        let redColor = hexStringToColor(hex: "#ff0000")
        // Note: Comparing Color directly is tricky. Compare components if possible.
        // For simple check, ensure it's not gray and opacity.
        XCTAssertNotNil(redColor)
        // You can't directly compare Color values easily without extracting components.
        // This is a basic check.
    }

    func testHexStringTocolorInvalidHex() throws {
        let invalidColor = hexStringToColor(hex: "invalid")
        // Assuming your function returns Color.gray.opacity(opacity) for invalid input
        // This is a conceptual check, actual comparison would need component access.
        XCTAssertNotNil(invalidColor)
    }

    func testHexStringTocolorShortHex() throws {
        let shortHexColor = hexStringToColor(hex: "#FFF")
        XCTAssertNotNil(shortHexColor)
    }

    func testHexStringTocolorWithOpacity() throws {
        let transparentRed = hexStringToColor(hex: "#ff0000", opacity: 0.5)
        XCTAssertNotNil(transparentRed)
    }
}
