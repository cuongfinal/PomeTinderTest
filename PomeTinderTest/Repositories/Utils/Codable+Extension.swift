//
//  Codable+Extension.swift
//  PomeTinderTest
//
//  Created by Le Quang Tuan Cuong(CuongLQT) on 10/10/2024.
//

import Foundation
import Combine

extension Data {
    var prettyJSONString: NSString? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: .mutableContainers),
              let prettyPrintedData = try? JSONSerialization.data(withJSONObject: object, options: .prettyPrinted)
        else { return nil }
        
        return NSString(data: prettyPrintedData, encoding: String.Encoding.utf8.rawValue)
    }
}


extension Encodable {
    var jsonData: Data? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        return try? encoder.encode(self)
    }
    
    var jsonString: String {
        if let data = self.jsonData, let string = String(data: data, encoding: .utf8) {
            return string
        }
        return "can not convert to json string"
    }
    var asDictionary: [String: Any] {
        jsonString.asDictionary()
    }
}

extension String {
    func asDictionary() -> [String: Any] {
        guard let data = data(using: .utf8),
              let dic = try? JSONSerialization.jsonObject(with: data, options: []) as? Parameters else { return [:] }
        return dic
    }

    var toURL: URL? { URL(string: self) }
    
    var isEmptyConvertToNil: Self? {
        isEmpty ? nil : self
    }
    var removeNewLines: Self {
        trimmingCharacters(in: .newlines)
    }
    
    var asBool: Bool {
        return (self as NSString).boolValue
    }
    
    func toDate() -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            print("Invalid date string")
            return nil
        }
    }
}

extension Publisher {
    func sinkToResult(_ result: @escaping (Result<Output, Failure>) -> Void) -> AnyCancellable {
        return sink(receiveCompletion: { completion in
            switch completion {
            case let .failure(error):
                result(.failure(error))
            default:
                break
            }
        }, receiveValue: { value in
            result(.success(value))
        })
    }
   
    /// Check internet connection
    func extractUnderlyingError() -> Publishers.MapError<Self, Failure> {
        mapError {
            ($0.underlyingError as? Failure) ?? $0
        }
    }
    
    /// Holds the downstream delivery of output until the specified time interval passed after the subscription
    /// Does not hold the output if it arrives later than the time threshold
    ///
    /// - Parameters:
    ///   - interval: The minimum time interval that should elapse after the subscription.
    /// - Returns: A publisher that optionally delays delivery of elements to the downstream receiver.
    
    func ensureTimeSpan(_ interval: TimeInterval) -> AnyPublisher<Output, Failure> {
        let timer = Just<Void>(())
            .delay(for: .seconds(interval), scheduler: RunLoop.main)
            .setFailureType(to: Failure.self)
        return zip(timer)
            .map { $0.0 }
            .eraseToAnyPublisher()
    }
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        if nsError.domain == NSURLErrorDomain, nsError.code == -1009 {
            // "The Internet connection appears to be offline."
            return self
        }
        return nsError.userInfo[NSUnderlyingErrorKey] as? Error
    }
}

extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toISO8601String() -> String {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.string(from: self)
    }
    
    public func calculateDiff(to targetDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: self, to: targetDate)
        return ageComponents.year!
    }

}
