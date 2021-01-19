import UIKit
import AVKit

private final class VideoPlayerDelegateCompositor: VideoPlayerDelegate {
    private let delegates: [VideoPlayerDelegate]
    
    init(delegates: [VideoPlayerDelegate]) {
        self.delegates = delegates
    }
    
    func load() {
        delegates.forEach({$0.load()})
    }
    
    func unload() {
        delegates.forEach({$0.unload()})
    }
    
    func destroy() {
        delegates.forEach({$0.destroy()})
    }
    
    func play() {
        delegates.forEach({$0.play()})
    }
    
    func pause() {
        delegates.forEach({$0.pause()})
    }
}

struct VideoPlayerComposer {
    static func compose(publisher: EventBusPublisher,
                        listeningManager: EventBusManager)
    -> (Player) {
        
        // Ideally we should observe the changes from player and publish them into event bus
        return VideoPlayer(
            eventBusListenerManager: listeningManager,
            delegate: VideoPlayerDelegateCompositor(
                delegates: [FakePlayer(),
                PlayerPublisher(publisher: publisher
                )]
            )
        )
    }
}


