import Foundation

struct VideoPlayerComposer {
    static func compose(streamURL: URL) -> (Player, UIViewController) {
        return (VideoPlayer(with: EventBus<PlayerEvents>()), UIViewController())
    }
}
