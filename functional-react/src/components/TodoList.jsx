import { useRef } from 'react';
import { ACTIONS } from '../state/todoReducer';
import TodoItem from './TodoItem';

/**
 * Renders the ordered list of todos and manages HTML5 drag-and-drop reordering.
 * The drag ref holds transient drag state; it is NOT React state because it
 * does not need to trigger a re-render on its own.
 *
 * @param {{ todos: import('../state/todoReducer').Todo[], dispatch: function }} props
 */
const TodoList = ({ todos, dispatch }) => {
  // Mutable ref for drag state – intentionally not useState so it doesn't
  // cause extra renders mid-drag.
  const dragRef = useRef({ fromIndex: null, overIndex: null });

  const handleDragStart = (_e, index) => {
    dragRef.current = { fromIndex: index, overIndex: index };
  };

  const handleDragOver = (e, index) => {
    e.preventDefault(); // required to allow drop
    dragRef.current = { ...dragRef.current, overIndex: index };
  };

  const handleDrop = () => {
    const { fromIndex, overIndex } = dragRef.current;
    if (fromIndex !== null && fromIndex !== overIndex) {
      dispatch({ type: ACTIONS.REORDER, payload: { fromIndex, toIndex: overIndex } });
    }
    dragRef.current = { fromIndex: null, overIndex: null };
  };

  if (todos.length === 0) {
    return <p className="todo-list__empty">No todos yet — add one above!</p>;
  }

  return (
    <ul className="todo-list">
      {todos.map((todo, index) => (
        <TodoItem
          key={todo.id}
          todo={todo}
          index={index}
          dispatch={dispatch}
          onDragStart={handleDragStart}
          onDragOver={handleDragOver}
          onDrop={handleDrop}
        />
      ))}
    </ul>
  );
};

export default TodoList;
