import Foundation

extension Double {
    var celsiusText: String {
        formatted(.number.precision(.fractionLength(1))) + " °C"
    }

    var percentText: String {
        formatted(.number.precision(.fractionLength(0))) + "%"
    }
}
