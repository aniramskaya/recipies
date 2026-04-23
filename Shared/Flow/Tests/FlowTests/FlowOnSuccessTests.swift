import Testing
@testable import Flow

struct FlowOnSuccessTests {
    @Test func onSuccessCalledWithCorrectValue() async throws {
        let received = Box<Int?>(nil)
        let flow = Flow { 99 }.onSuccess { await received.set($0) }

        _ = try await flow.run()
        #expect(await received.value == 99)
    }

    @Test func onSuccessPropagatesOriginalValue() async throws {
        let flow = Flow { 7 }.onSuccess { _ in }
        let result = try await flow.run()
        #expect(result == 7)
    }

    @Test func onSuccessNotCalledOnError() async throws {
        let actionCalled = Box(false)
        let flow = Flow<Int> { throw TestError.stub }.onSuccess { _ in await actionCalled.set(true) }

        _ = try? await flow.run()
        #expect(await actionCalled.value == false)
    }

    @Test func onSuccessPropagatesError() async throws {
        let expected = TestError.stub
        let flow = Flow<Int> { throw expected }.onSuccess { _ in }

        do {
            _ = try await flow.run()
            #expect(Bool(false), "Expected to throw but got value instead")
        } catch {
            #expect(error as? TestError == expected)
        }
    }
}
