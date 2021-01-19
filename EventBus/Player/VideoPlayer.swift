import UIKit

class VideoPlayer: Player {

    private let eventBus: EventBus<PlayerEvents>
    
    init(with eventBus: EventBus<PlayerEvents>) {
        self.eventBus = eventBus
    }
    
    func addListener(listener: AnyHashable,
                     onEvent: PlayerEvents,
                     completion: @escaping (PlayerEvents) -> (),
                     priority: Priority) {
        eventBus.register(event: onEvent, for: completion, for: listener, priority: priority)
    }
    
    func removeListener(listener: AnyHashable) {
        eventBus.unregister(object: listener)
    }
    
    func load() {
        eventBus.publish(event: .onLoaded)
    }
    
    func unload() {
        eventBus.publish(event: .onUnloaded)
    }
    
    func destroy() {
        eventBus.publish(event: .onPlaybackFinished)
        eventBus.publish(event: .onUnloaded)
    }
    
    func play() {
        eventBus.publish(event: .onPlay)

    }
    
    func pause() {
        eventBus.publish(event: .onPause)
    }
}
