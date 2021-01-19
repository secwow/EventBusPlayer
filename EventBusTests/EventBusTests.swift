import XCTest
@testable import EventBus

class ProjectPlayerTests: XCTestCase {
    enum PlayerEvent {
        case play, stop
    }
    
    class SomeListener: NSObject {}
    
    func test_bus_doesntEmitAnyEventsWithoutPublish()  {
        let bus = EventBus<PlayerEvent>()
        let listener = SomeListener()
        bus.register(event: .play, for: { (event) in
            XCTFail("Should not emit any event")
        }, for: listener)
    }

    func test_bus_shouldDeliverEventAfterRegister()  {
        let bus = EventBus<PlayerEvent>()
        let listener = SomeListener()
        let eventToPublish = PlayerEvent.play
        
        bus.register(event: .play, for: { (event) in
            XCTAssertEqual(event, eventToPublish)
        }, for: listener)
        
        bus.publish(event: eventToPublish)
    }
    
    func test_bus_shouldNotRegisterTheSameListenerTwice()  {
        let bus = EventBus<PlayerEvent>()
        let listener = SomeListener()
        let eventToPublish = PlayerEvent.play
        
        bus.register(event: .play, for: { (event) in
            XCTAssertEqual(event, eventToPublish)
        }, for: listener)
        
        bus.register(event: .play, for: { (event) in
            XCTFail("Should not deliver event after repeatetive subscription")
        }, for: listener)
        
        bus.publish(event: eventToPublish)
    }
    
    func test_bus_shouldDeliverEventAccordingToPriorities()  {
        let bus = EventBus<PlayerEvent>()
        let eventToPublish = PlayerEvent.play
        

        let expect = expectation(description: "Waiting for event")
        expect.expectedFulfillmentCount = 7
        
        var order = [Priority]()
        
        let sequence = [Priority.low, .high, .medium, .medium, .low, .low, .high]
        for orderNumber in 1...7 {
            let priority = sequence[orderNumber]
            bus.register(event: .play, for: { (event) in
                order.append(priority)
                expect.fulfill()
            }, for: "\(orderNumber)",
            priority: priority)
        }
        
        bus.publish(event: eventToPublish)
        waitForExpectations(timeout: 1.0, handler: nil)
        XCTAssertEqual(order, [.high, .high, .medium, .medium, .low, .low, .low])
    }
    
    func test_register_shouldBeThreadSafe()  {
        let bus = EventBus<PlayerEvent>()
        let eventToPublish = PlayerEvent.play
        let iterations = 1000
        let expect = expectation(description: "Waiting for event")
        expect.expectedFulfillmentCount = iterations
        
        DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
            bus.register(event: .play, for: { (event) in
                XCTAssertEqual(event, eventToPublish)
                print("1")
                expect.fulfill()
            }, for: "\(iteration)",
            priority: .low)
        }
        
        bus.publish(event: .play)
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_register_publishShouldBeThreadSafe()  {
        let bus = EventBus<PlayerEvent>()
        let eventToPublish = PlayerEvent.play
        let iterations = 1000
        let expect = expectation(description: "Waiting for event")
        expect.expectedFulfillmentCount = iterations
        
        bus.register(event: .play, for: { (event) in
            XCTAssertEqual(event, eventToPublish)
            print("1")
            expect.fulfill()
        }, for: "\(1)",
        priority: .low)
        
        DispatchQueue.concurrentPerform(iterations: iterations) { iteration in
            bus.publish(event: .play)
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
}
