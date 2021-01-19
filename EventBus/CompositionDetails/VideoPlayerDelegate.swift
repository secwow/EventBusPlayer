import Foundation

protocol VideoPlayerDelegate {
    func load()
    
    func unload()
    
    func destroy()
    
    func play()
    
    func pause()
}

class FakePlayer: VideoPlayerDelegate {
    private var lastEvent: PlayerEvents? {
        didSet {
            print(lastEvent as Any)
        }
    }
    
    func load() {
        lastEvent = .onLoaded
    }
    
    func unload() {
        lastEvent = .onUnloaded
    }
    
    func destroy() {
        lastEvent = nil
    }
    
    func play() {
        lastEvent = .onPlay
    }
    
    func pause() {
        lastEvent = .onPause
    }
}

class PlayerPublisher: VideoPlayerDelegate {
    private let publisher: EventBusPublisher
    
    init(publisher: EventBusPublisher) {
        self.publisher = publisher
    }
    
    func load() {
        publisher.publish(event: .onLoaded)
    }
    
    func unload() {
        publisher.publish(event: .onUnloaded)
    }
    
    func destroy() {
        publisher.publish(event: .onPlaybackFinished)
    }
    
    func play() {
        publisher.publish(event: .onPlay)
    }
    
    func pause() {
        publisher.publish(event: .onPause)
    }
}
