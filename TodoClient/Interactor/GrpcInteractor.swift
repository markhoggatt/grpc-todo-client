//
//  GrpcInteractor.swift
//  TodoClient
//
//  Created by Mark Hoggatt on 28/05/2023.
//

import Foundation
import GRPC

struct GrpcInteractor
{
	func retrieveTodos() async -> [Todo]
	{
		let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
		defer
		{
			do
			{
				try group.syncShutdownGracefully()
			}
			catch
			{
				print("Failed to shut down the event loop: \(error.localizedDescription)")
			}
		}

		do
		{
			let channel: GRPCChannel = try GRPCChannelPool.with(target: .hostAndPort("localhost", 1234),
												   transportSecurity: .plaintext,
												   eventLoopGroup: group)

			let todoClient = Todos_TodoServiceAsyncClient(channel: channel)

			let todos: Todos_TodoList = try await todoClient.fetchTodos(Todos_Empty())

			return todos.todos.map { Todo(id: UUID(uuidString: $0.todoID) ?? UUID(), title: $0.title) }
		}
		catch
		{
			print("Retrieve todos failed: \(error.localizedDescription)")
		}

		return []
	}
}
