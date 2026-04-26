import { ACTIONS } from '../state/todoReducer';

/**
 * Single todo card.
 * Drag-and-drop is handled via HTML5 draggable attributes; the parent list
 * owns the reorder logic so this component stays pure / side-effect-free.
 *
 * @param {{
 *   todo: import('../state/todoReducer').Todo,
 *   index: number,
 *   dispatch: function,
 *   onDragStart: function,
 *   onDragOver: function,
 *   onDrop: function,
 * }} props
 */
const TodoItem = ({ todo, index, dispatch, onDragStart, onDragOver, onDrop }) => {
  const handleToggle = () =>
    dispatch({ type: ACTIONS.TOGGLE_COMPLETE, payload: { id: todo.id } });

  const handleRemove = () =>
    dispatch({ type: ACTIONS.REMOVE, payload: { id: todo.id } });

  const formattedDeadline = todo.deadline
    ? new Intl.DateTimeFormat(undefined, { dateStyle: 'medium' }).format(
        new Date(`${todo.deadline}T00:00:00`),
      )
    : null;

  return (
    <li
      className={`todo-item${todo.completed ? ' todo-item--completed' : ''}`}
      draggable
      onDragStart={(e) => onDragStart(e, index)}
      onDragOver={(e) => onDragOver(e, index)}
      onDrop={onDrop}
    >
      <span className="todo-item__drag-handle" aria-hidden="true">⠿</span>

      <button
        className="todo-item__toggle"
        type="button"
        onClick={handleToggle}
        aria-label={todo.completed ? 'Mark as incomplete' : 'Mark as complete'}
      >
        {todo.completed ? '✓' : '○'}
      </button>

      <div className="todo-item__body">
        <span className="todo-item__description">{todo.description}</span>
        {formattedDeadline && (
          <span className="todo-item__deadline">Due: {formattedDeadline}</span>
        )}
      </div>

      <button
        className="todo-item__remove"
        type="button"
        onClick={handleRemove}
        aria-label="Remove todo"
      >
        ✕
      </button>
    </li>
  );
};

export default TodoItem;
