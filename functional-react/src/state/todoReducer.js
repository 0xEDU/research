// Pure reducer – all state transitions live here.
// No side-effects, no mutations: every case returns a new array/object.

export const ACTIONS = Object.freeze({
  ADD: 'ADD',
  REMOVE: 'REMOVE',
  TOGGLE_COMPLETE: 'TOGGLE_COMPLETE',
  REORDER: 'REORDER',
});

/**
 * @typedef {{ id: string, description: string, deadline: string|null, completed: boolean }} Todo
 */

/**
 * Creates a fresh Todo object.
 * @param {string} description
 * @param {string|null} deadline  ISO date string or null
 * @returns {Todo}
 */
export const createTodo = (description, deadline) => ({
  id: crypto.randomUUID(),
  description,
  deadline: deadline || null,
  completed: false,
});

/**
 * Pure reducer for the todo list.
 * @param {Todo[]} todos
 * @param {{ type: string, payload: * }} action
 * @returns {Todo[]}
 */
export const todoReducer = (todos, action) => {
  switch (action.type) {
    case ACTIONS.ADD:
      return [...todos, createTodo(action.payload.description, action.payload.deadline)];

    case ACTIONS.REMOVE:
      return todos.filter((todo) => todo.id !== action.payload.id);

    case ACTIONS.TOGGLE_COMPLETE:
      return todos.map((todo) =>
        todo.id === action.payload.id ? { ...todo, completed: !todo.completed } : todo,
      );

    case ACTIONS.REORDER: {
      const { fromIndex, toIndex } = action.payload;
      if (fromIndex === toIndex) return todos;
      const next = [...todos];
      const [moved] = next.splice(fromIndex, 1);
      next.splice(toIndex, 0, moved);
      return next;
    }

    default:
      return todos;
  }
};
