import Foundation
import HMRCExchangeRate

public enum ResourcesLoader: HMRCExchangeRate.ResourcesLoader {
  public static var resources: [URL] {
    Bundle.module.urls(forResourcesWithExtension: "xml", subdirectory: nil) ?? []
  }
}
