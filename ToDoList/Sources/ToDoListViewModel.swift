import SwiftUI

final class ToDoListViewModel: ObservableObject {
    // MARK: - Private properties

    private let repository: ToDoListRepositoryType
    var currentFilterIndex: Int = 0

    // MARK: - Init

    init(repository: ToDoListRepositoryType) {
        self.repository = repository
        self.filteredToDoItems = repository.loadToDoItems()
        self.toDoItems = filteredToDoItems
        applyFilter(at: currentFilterIndex)
    }

    // MARK: - Outputs

    /// Publisher for the list of to-do items.
    @Published var toDoItems: [ToDoItem] = [] {
        didSet {
            repository.saveToDoItems(toDoItems)
        }
    }

    @Published var filteredToDoItems: [ToDoItem] = []
    // MARK: - Inputs

    // Add a new to-do item with priority and category
    func add(item: ToDoItem) {
        filteredToDoItems.append(item)
        toDoItems = filteredToDoItems
        applyFilter(at: currentFilterIndex)
    }

    /// Toggles the completion status of a to-do item.
    func toggleTodoItemCompletion(_ item: ToDoItem) {
        if let index = filteredToDoItems.firstIndex(where: { $0.id == item.id }) {
            filteredToDoItems[index].isDone.toggle()
            applyFilter(at: currentFilterIndex)
        }
    }

    /// Removes a to-do item from the list.
    func removeTodoItem(_ item: ToDoItem) {
        filteredToDoItems.removeAll { $0.id == item.id }
        applyFilter(at: currentFilterIndex)
    }

    /// Apply the filter to update the list.
    func applyFilter(at index: Int) {
        // allows to filter the tasks according to their level of completion or display all of them
        currentFilterIndex = index
        
       switch index {
           case 0:
           toDoItems = filteredToDoItems
           case 1:
           toDoItems = filteredToDoItems.filter { $0.isDone }
           case 2:
           toDoItems = filteredToDoItems.filter { !$0.isDone }
       default:
           break
        }
    }
}
