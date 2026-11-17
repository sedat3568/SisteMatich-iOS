#if !os(watchOS)
import WidgetKit

public extension WidgetFamily {
    static var extraLarges: [WidgetFamily] {
        return [.systemExtraLarge]
    }
}
#endif
