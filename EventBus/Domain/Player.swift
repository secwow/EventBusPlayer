import Foundation

protocol Player {
    func addListener(listener: AnyHashable,
                     onEvent: PlayerEvents,
                     completion: @escaping (PlayerEvents) -> (),
                     priority: Priority)
    func removeListener(listener: AnyHashable)
    func load()
    func unload()
    func destroy()
    func play()
    func pause()
}
