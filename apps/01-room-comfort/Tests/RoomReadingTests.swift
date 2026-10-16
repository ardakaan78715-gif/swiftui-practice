import Testing
@testable import RoomComfort

struct RoomReadingTests {
    @Test(arguments: [
        (15.9, TemperatureBand.cold),
        (16.0, .cool),
        (17.9, .cool),
        (18.0, .comfortable),
        (24.0, .comfortable),
        (24.5, .warm),
        (27.0, .warm),
        (27.5, .hot),
    ])
    func temperatureBands(celsius: Double, band: TemperatureBand) {
        #expect(TemperatureBand(celsius: celsius) == band)
    }

    @Test(arguments: [
        (39.0, HumidityBand.dry),
        (40.0, .comfortable),
        (60.0, .comfortable),
        (61.0, .damp),
    ])
    func humidityBands(percent: Double, band: HumidityBand) {
        #expect(HumidityBand(percent: percent) == band)
    }

    @Test(arguments: [
        (20.0, 50.0, 9.3),
        (25.0, 60.0, 16.7),
        (10.0, 80.0, 6.7),
    ])
    func dewPointMatchesReferenceValues(temperature: Double, humidity: Double, expected: Double) {
        let reading = RoomReading(temperature: temperature, humidity: humidity)
        #expect(abs(reading.dewPoint - expected) < 0.1)
    }

    @Test func dewPointEqualsTemperatureWhenSaturated() {
        let reading = RoomReading(temperature: 21, humidity: 100)
        #expect(abs(reading.dewPoint - 21) < 0.0001)
    }

    @Test func humidityIsClampedToAUsableRange() {
        #expect(RoomReading(temperature: 20, humidity: 0).humidity == 1)
        #expect(RoomReading(temperature: 20, humidity: 140).humidity == 100)
        #expect(RoomReading(temperature: 20, humidity: 0).dewPoint.isFinite)
    }
}
