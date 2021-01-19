import UIKit
import AVKit

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

final class VideoPlayerDelegateCompositor: VideoPlayerDelegate {
    private let delegate: [VideoPlayerDelegate]
    
    init(delegate: [VideoPlayerDelegate]) {
        self.delegate = delegate
    }
    
    func load() {
        delegate.forEach({$0.load()})
    }
    
    func unload() {
        delegate.forEach({$0.unload()})

    }
    
    func destroy() {
        delegate.forEach({$0.destroy()})

    }
    
    func play() {
        delegate.forEach({$0.play()})

    }
    
    func pause() {
        delegate.forEach({$0.pause()})
    }
}

struct VideoPlayerComposer {
    static func compose(streamURL: URL,
                        publisher: EventBusPublisher,
                        listeningManager: EventBusListenerManager)
    -> (Player) {
        
        return VideoPlayer(eventBusListenerManager: listeningManager,
                            eventBusPublisher: publisher)
    }
}


