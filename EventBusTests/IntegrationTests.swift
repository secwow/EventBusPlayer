import XCTest
@testable import EventBus

class IntegrationTests: XCTestCase {
    class EventBusPublisherSpy: EventBusPublisher {
        var publishedEvents: [PlayerEvents] = []
        
        func publish(event: PlayerEvents) {
            publishedEvents.append(event)
        }
    }
    
    class EventBusListenerManagerSpy: EventBusManager {
        var registeredHashable: [AnyHashable] = []
        
        func register(event: PlayerEvents, for listener: @escaping (PlayerEvents) -> (), for object: AnyHashable, priority: Priority) {
            registeredHashable.append(object)
        }
        
        func unregister(object: AnyHashable) {
            registeredHashable = registeredHashable.filter({$0 == object })
        }
    }
    
    func test_player_playback() {
        let (sut, publisherSpy, manager) = makeSUT()
        let registeredObject = "1"
        
        XCTAssertEqual(manager.registeredHashable, [])
        
        sut.addListener(listener: registeredObject, onEvent: .onPlay, completion: { (event) in
        }, priority: .high)
        
        XCTAssertEqual(manager.registeredHashable, [registeredObject])

        XCTAssertEqual(publisherSpy.publishedEvents, [])
        
        sut.play()
        
        XCTAssertEqual(publisherSpy.publishedEvents,
                       
                       [.onPlay])
    }
    
    func test_player_eventSequence() {
        let (sut, publisherSpy, _) = makeSUT()
        
        sut.addListener(listener: "1", onEvent: .onPlay, completion: { (event) in
        }, priority: .high)
        
        XCTAssertEqual(publisherSpy.publishedEvents, [])
        sut.play()
        sut.pause()
        sut.load()
        sut.unload()
        sut.destroy()

        XCTAssertEqual(publisherSpy.publishedEvents, [.onPlay,
                                                      .onPause,
                                                      .onLoaded,
                                                      .onUnloaded,
                                                      .onPlaybackFinished])
    }
    
    func test_player_callRemoveWhenItNeeded() {
        let (sut, publisherSpy, manager) = makeSUT()
        let registeredListener = "1"
        sut.addListener(listener: registeredListener, onEvent: .onPlay, completion: { (event) in
        }, priority: .high)
        
        XCTAssertEqual(manager.registeredHashable, [registeredListener])
        sut.removeListener(listener: registeredListener)
        XCTAssertEqual(manager.registeredHashable, [registeredListener])
    }
    
    func makeSUT() -> (Player, EventBusPublisherSpy, EventBusListenerManagerSpy) {
        let publisherSpy = EventBusPublisherSpy()
        let managerSpy = EventBusListenerManagerSpy()
        let sut = VideoPlayerComposer.compose(publisher: publisherSpy, listeningManager: managerSpy)
        trackForMemoryLeaks(publisherSpy)
        trackForMemoryLeaks(managerSpy)
        trackForMemoryLeaks(sut as AnyObject)

        return (sut, publisherSpy, managerSpy)
    }
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
