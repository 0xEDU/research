# functional-react

A todo-list frontend written in **functional React** — pure functions, no classes,
no external state-management or UI libraries.

## Philosophy

Follows the [Thinking in React](https://react.dev/learn/thinking-in-react) and
[Rules of React](https://react.dev/reference/rules) guidelines:

- All components are plain functions; zero class components.
- A single **pure reducer** (`src/state/todoReducer.js`) owns every state
  transition. It is a pure function: same input → same output, no side effects.
- `useReducer` is the only state primitive at the app level; local UI state
  uses `useState` only where absolutely necessary (the add-form inputs).
- Drag-and-drop reordering uses the **HTML5 Drag and Drop API** directly — no
  external library required.

## Features

| Feature | How |
|---|---|
| Add a todo | Form with description (required) and optional deadline date |
| Remove a todo | ✕ button on the card |
| Mark as complete | ○ toggle button; completed items stay in the list with a strikethrough |
| Reorder | Drag cards by their ⠿ handle |

## Project structure

```
src/
  state/
    todoReducer.js     # Pure reducer + action types + createTodo factory
  components/
    AddTodoForm.jsx    # Controlled form → dispatches ADD
    TodoList.jsx       # Renders list, owns drag-and-drop logic
    TodoItem.jsx       # Single todo card (display + TOGGLE / REMOVE)
  App.jsx              # Root: useReducer, passes dispatch down
  App.css              # Component styles
  index.css            # Global reset + body layout
```

## Getting started

```bash
npm install
npm run dev      # dev server at http://localhost:5173
npm run build    # production build to dist/
```
