import AVKit

class VideoPlayer: Player {
    private let eventBusListenerManager: EventBusManager
    private let delegate: VideoPlayerDelegate

    init(eventBusListenerManager: EventBusManager,
         delegate: VideoPlayerDelegate) {
        self.eventBusListenerManager = eventBusListenerManager
        self.delegate = delegate
    }
    
    func addListener(listener: AnyHashable,
                     onEvent: PlayerEvents,
                     completion: @escaping (PlayerEvents) -> (),
                     priority: Priority) {
        eventBusListenerManager.register(event: onEvent, for: completion, for: listener, priority: priority)
    }
    
    func removeListener(listener: AnyHashable) {
        eventBusListenerManager.unregister(object: listener)
    }
    
    func load() {
        delegate.load()
    }
    
    func unload() {
        delegate.unload()
    }
    
    func destroy() {
        delegate.destroy()
    }
    
    func play() {
        delegate.play()
    }
    
    func pause() {
        delegate.pause()
    }
}
