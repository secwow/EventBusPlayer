import Foundation

enum PlayerEvents: Int, Hashable {
    case onLoaded
    case onUnloaded
    case onReady
    case onPlay
    case onTimeChanged
    case onPause
    case onPlaybackFinished
    case onError
}
