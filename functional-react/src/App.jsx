import { useReducer } from 'react';
import { todoReducer } from './state/todoReducer';
import AddTodoForm from './components/AddTodoForm';
import TodoList from './components/TodoList';
import './App.css';

const INITIAL_TODOS = [];

/**
 * Root application component.
 * Single source of truth: the todo list lives here as plain state derived
 * from a pure reducer.  No external state management library is needed.
 */
const App = () => {
  const [todos, dispatch] = useReducer(todoReducer, INITIAL_TODOS);

  const pending = todos.filter((t) => !t.completed).length;

  return (
    <div className="app">
      <header className="app__header">
        <h1 className="app__title">Todo List</h1>
        {todos.length > 0 && (
          <span className="app__count">
            {pending} of {todos.length} remaining
          </span>
        )}
      </header>

      <AddTodoForm dispatch={dispatch} />
      <TodoList todos={todos} dispatch={dispatch} />
    </div>
  );
};

export default App;
