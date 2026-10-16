import Testing
@testable import RoomComfort

struct ComfortReportTests {
    @Test(arguments: [
        (21.0, 50.0, "Comfortable", ComfortReport.Concern.comfortable),
        (15.0, 70.0, "Cold and damp air", .cold),
        (17.0, 50.0, "Cool", .cold),
        (25.0, 35.0, "Warm and dry air", .warm),
        (29.0, 50.0, "Hot", .warm),
        (21.0, 75.0, "Damp air", .humidity),
        (21.0, 30.0, "Dry air", .humidity),
    ])
    func headlineAndConcern(temperature: Double, humidity: Double, headline: String, concern: ComfortReport.Concern) {
        let report = ComfortReport(reading: RoomReading(temperature: temperature, humidity: humidity))
        #expect(report.headline == headline)
        #expect(report.concern == concern)
    }

    @Test func comfortableRoomHasNoTips() {
        let report = ComfortReport(reading: RoomReading(temperature: 21, humidity: 50))
        #expect(report.tips.isEmpty)
        #expect(report.detail == "Temperature and humidity are both in a comfortable range.")
    }

    @Test func tipsCoverTemperatureBeforeHumidity() {
        let report = ComfortReport(reading: RoomReading(temperature: 15, humidity: 70))
        #expect(report.tips == [TemperatureBand.cold.tip, HumidityBand.damp.tip].compactMap { $0 })
        #expect(report.detail == "Aim for 18 to 24 °C and 40 to 60% humidity.")
    }

    @Test func humidityOnlyProblemGivesOneTip() {
        let report = ComfortReport(reading: RoomReading(temperature: 20, humidity: 65))
        #expect(report.tips.count == 1)
        #expect(report.tips.first == HumidityBand.damp.tip)
    }
}
