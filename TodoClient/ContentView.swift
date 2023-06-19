//
//  ContentView.swift
//  TodoClient
//
//  Created by Mark Hoggatt on 28/05/2023.
//

import SwiftUI

struct ContentView: View
{
	@State fileprivate var todos: [Todo] = []
	@State fileprivate var shouldShowAdd: Bool = false
	@State fileprivate var newTitle: String = ""

	var body: some View
	{
		VStack
		{
			Image(systemName: "globe")
				.imageScale(.large)
				.foregroundColor(.accentColor)

			VStack(alignment: .leading)
			{
				ForEach(todos)
				{
					Text($0.title)
						.padding(10)
				}
			}

			Button(action:
			{
				shouldShowAdd = true
			}, label:
			{
				Image(systemName: "plus")
			})

			if shouldShowAdd
			{
				TextField("Title", text: $newTitle)
					.padding()

				Button(action:
				{
					shouldShowAdd = false
					let grpc = GrpcInteractor()
					let todo = Todo(title: newTitle)

					Task
					{
						let savedTodo: Todo = await grpc.createTodo(from: todo)
						if let _ = savedTodo.id
						{
							todos.append(savedTodo)
						}
					}
				}, label:
				{
					Text("Update")
				})
			}
		}
		.task
		{
			let grpc = GrpcInteractor()
			todos = await grpc.retrieveTodos()
		}
	}
}

struct ContentView_Previews: PreviewProvider
{
	static var previews: some View
	{
		ContentView()
	}
}
