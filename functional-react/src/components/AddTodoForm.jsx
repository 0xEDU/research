import { useState } from 'react';
import { ACTIONS } from '../state/todoReducer';

const EMPTY_FORM = { description: '', deadline: '' };

/**
 * Controlled form that dispatches an ADD action.
 * @param {{ dispatch: function }} props
 */
const AddTodoForm = ({ dispatch }) => {
  const [form, setForm] = useState(EMPTY_FORM);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm((prev) => ({ ...prev, [name]: value }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    const trimmed = form.description.trim();
    if (!trimmed) return;
    dispatch({
      type: ACTIONS.ADD,
      payload: { description: trimmed, deadline: form.deadline || null },
    });
    setForm(EMPTY_FORM);
  };

  return (
    <form className="add-form" onSubmit={handleSubmit}>
      <input
        className="add-form__input"
        type="text"
        name="description"
        placeholder="What needs to be done?"
        value={form.description}
        onChange={handleChange}
        required
      />
      <input
        className="add-form__date"
        type="date"
        name="deadline"
        value={form.deadline}
        onChange={handleChange}
      />
      <button className="add-form__submit" type="submit">
        Add
      </button>
    </form>
  );
};

export default AddTodoForm;
