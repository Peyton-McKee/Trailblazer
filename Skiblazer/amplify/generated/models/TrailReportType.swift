// swiftlint:disable all
import Amplify
import Foundation

public enum TrailReportType: String, EnumPersistable, CaseIterable {
    case moguls = "MOGULS"
    case icy = "ICY"
    case powder = "POWDER"
    case thinCover = "THIN_COVER"
}
