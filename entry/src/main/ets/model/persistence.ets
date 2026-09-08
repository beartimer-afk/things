import { preferences } from '@kit.ArkData';
import { Todo, TodoStore } from './domain';

export const PREF_NAME = 'things_store';
const KEY_TODOS = 'todos';

export function saveTodos(prefs: preferences.Preferences, todos: Todo[]): void {
  try {
    prefs.putSync(KEY_TODOS, JSON.stringify(todos));
    prefs.flush();
  } catch (e) {
    // preferences can throw; persistence is best-effort, never fatal to the UI
  }
}

export function loadTodos(prefs: preferences.Preferences): Todo[] {
  let raw = '[]';
  try {
    raw = prefs.getSync(KEY_TODOS, '[]') as string;
  } catch (e) {
    raw = '[]';
  }
  if (raw === '') { return []; }
  try {
    const arr = JSON.parse(raw) as Todo[];
    return arr;
  } catch (e) {
    return [];
  }
}

export function saveStore(prefs: preferences.Preferences, store: TodoStore): void {
  saveTodos(prefs, store.getAll());
}
