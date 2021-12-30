// From https://github.com/apple/swift-argument-parser/issues/326

import ArgumentParser
import Foundation

protocol AsyncParsableCommand: ParsableCommand {
  mutating func run() async throws
}

extension ParsableCommand {
  static func main(_ arguments: [String]? = nil) async throws {
    do {
      var command = try parseAsRoot(arguments)
      if var asyncCommand = command as? AsyncParsableCommand {
        try await asyncCommand.run()
      } else {
        try command.run()
      }
    } catch {
      exit(withError: error)
    }
  }
}
