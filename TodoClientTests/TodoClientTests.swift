//
//  TodoClientTests.swift
//  TodoClientTests
//
//  Created by Mark Hoggatt on 28/05/2023.
//

import XCTest
@testable import TodoClient

final class TodoClientTests: XCTestCase
{
	override func setUpWithError() throws
	{
		// Put setup code here. This method is called before the invocation of each test method in the class.
	}

	override func tearDownWithError() throws
	{
		// Put teardown code here. This method is called after the invocation of each test method in the class.
	}

	func testCanGetTodos() async throws
	{
		let grpc = GrpcInteractor()
		let todos = await grpc.retrieveTodos()
		XCTAssertFalse(todos.isEmpty)
	}

	func testPerformanceExample() throws
	{
		// This is an example of a performance test case.
		self.measure
		{
			// Put the code you want to measure the time of here.
		}
	}
}
