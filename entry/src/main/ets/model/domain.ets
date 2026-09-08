// Domain model skeleton (per spec 02.2 / 02.6 / 02.7).
// One source of truth for product facts. Projection/Command/UI-State separation:
//  - Domain holds stable facts (no page/picker/selection/expanded state).
//  - Pages derive Projections (Today/Upcoming/Anytime/Someday/...) via queries.
//  - Mutations go through Commands (not entity.field = value).
// This is an in-memory scaffold; real persistence comes later (E-level).

export enum LifecycleStatus {
  OPEN = 0,
  COMPLETED = 1,
  CANCELED = 2
}

export enum StartMode {
  ON_DATE = 0,
  ANYTIME = 1,
  SOMEDAY = 2
}

export class Start {
  mode: StartMode = StartMode.ANYTIME;
  date: string = '';        // yyyy-MM-dd when ON_DATE
  evening: boolean = false; // only meaningful when mode===ON_DATE && date===today
  constructor(mode: StartMode = StartMode.ANYTIME, date: string = '', evening: boolean = false) {
    this.mode = mode;
    this.date = date;
    this.evening = evening;
  }
}

export class ChecklistItem {
  id: string;
  title: string;
  completed: boolean = false;
  rank: number = 0;
  constructor(id: string, title: string, completed: boolean = false, rank: number = 0) {
    this.id = id;
    this.title = title;
    this.completed = completed;
    this.rank = rank;
  }
}

// Todo: the atomic actionable unit. Parent is a Domain relation (not presentation).
export class Todo {
  id: string;
  title: string;
  notes: string = '';
  lifecycle: LifecycleStatus = LifecycleStatus.OPEN;
  start: Start = new Start();
  deadline: string = '';        // yyyy-MM-dd or ''
  parentProjectId: string = '';
  parentAreaId: string = '';
  headingId: string = '';
  directTags: string[] = [];
  isRepeatCopy: boolean = false;
  checklist: ChecklistItem[] = [];
  constructor(id: string, title: string, start: Start = new Start()) {
    this.id = id;
    this.title = title;
    this.start = start;
  }
}

export class Project {
  id: string;
  title: string;
  lifecycle: LifecycleStatus = LifecycleStatus.OPEN;
  parentAreaId: string = '';
  constructor(id: string, title: string) {
    this.id = id;
    this.title = title;
  }
}

export class Area {
  id: string;
  title: string;
  constructor(id: string, title: string) {
    this.id = id;
    this.title = title;
  }
}

// Commands (scaffold subset). UI never mutates entities directly.
// A persistence hook (onMutate) is set by the host so any domain mutation can be saved.
export class TodoCommands {
  static onMutate: () => void = () => {};

  static complete(t: Todo): void {
    if (t.lifecycle === LifecycleStatus.OPEN) {
      t.lifecycle = LifecycleStatus.COMPLETED;
    }
    TodoCommands.onMutate();
  }
  static uncomplete(t: Todo): void {
    if (t.lifecycle === LifecycleStatus.COMPLETED) {
      t.lifecycle = LifecycleStatus.OPEN;
    }
    TodoCommands.onMutate();
  }
  static setStart(t: Todo, start: Start): void {
    // Start is a separate dimension; does not touch deadline/lifecycle.
    t.start = start;
    TodoCommands.onMutate();
  }
  static setDeadline(t: Todo, deadline: string): void {
    // Deadline is orthogonal to Start.
    t.deadline = deadline;
    TodoCommands.onMutate();
  }
  static setTags(t: Todo, tags: string[]): void {
    // Only direct tags are edited here; inherited/effective tags are computed (never copied in).
    t.directTags = tags.slice();
    TodoCommands.onMutate();
  }
  static updateTitle(t: Todo, title: string): void {
    t.title = title;
    TodoCommands.onMutate();
  }
  static updateNotes(t: Todo, notes: string): void {
    t.notes = notes;
    TodoCommands.onMutate();
  }
  static toggleChecklist(t: Todo, itemId: string): void {
    for (let i = 0; i < t.checklist.length; i++) {
      if (t.checklist[i].id === itemId) {
        t.checklist[i].completed = !t.checklist[i].completed;
      }
    }
    TodoCommands.onMutate();
  }
  static addChecklistItem(t: Todo, title: string): void {
    const id = 'c' + (t.checklist.length + 1) + '-' + Date.now().toString();
    t.checklist.push(new ChecklistItem(id, title, false, t.checklist.length));
    TodoCommands.onMutate();
  }
  static reorderChecklist(t: Todo, itemId: string, step: number): void {
    let idx = -1;
    for (let i = 0; i < t.checklist.length; i++) { if (t.checklist[i].id === itemId) { idx = i; } }
    if (idx < 0) { return; }
    const to = idx + step;
    if (to < 0 || to >= t.checklist.length) { return; }
    const tmp = t.checklist[idx];
    t.checklist[idx] = t.checklist[to];
    t.checklist[to] = tmp;
    for (let i = 0; i < t.checklist.length; i++) { t.checklist[i].rank = i; }
    TodoCommands.onMutate();
  }
}

// In-memory fact store (single source of truth). Persistence/sync is E-level and later.
export class TodoStore {
  private todos: Todo[] = [];
  private projects: Project[] = [];
  private areas: Area[] = [];

  setTodos(items: Todo[]): void {
    this.todos = items;
  }
  addTodo(t: Todo): void {
    this.todos.push(t);
  }
  remove(id: string): void {
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      if (this.todos[i].id !== id) { out.push(this.todos[i]); }
    }
    this.todos = out;
  }
  getAll(): Todo[] {
    return this.todos;
  }
  setProjects(items: Project[]): void {
    this.projects = items;
  }
  setAreas(items: Area[]): void {
    this.areas = items;
  }
  getProjects(): Project[] {
    return this.projects;
  }
  getAreas(): Area[] {
    return this.areas;
  }

  // Projection: Today is a working set, NOT a parent.
  // Membership (simplified scaffold; the real ProjectionEngine centralizes this):
  //   active (OPEN) AND (start is OnDate(today) OR deadline === today)
  // This evening is a sub-bucket within Today (start.evening === true).
  today(todayStr: string): Todo[] {
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      const t = this.todos[i];
      if (t.lifecycle !== LifecycleStatus.OPEN) { continue; }
      const inToday = (t.start.mode === StartMode.ON_DATE && t.start.date === todayStr) ||
        (t.deadline !== '' && t.deadline === todayStr);
      if (inToday) { out.push(t); }
    }
    return out;
  }

  upcoming(todayStr: string): Todo[] {
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      const t = this.todos[i];
      if (t.lifecycle !== LifecycleStatus.OPEN) { continue; }
      const inFuture = (t.start.mode === StartMode.ON_DATE && t.start.date !== '' && t.start.date > todayStr) ||
        (t.deadline !== '' && t.deadline > todayStr);
      if (inFuture) { out.push(t); }
    }
    return out;
  }

  anytime(): Todo[] {
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      const t = this.todos[i];
      if (t.lifecycle === LifecycleStatus.OPEN && t.start.mode === StartMode.ANYTIME) { out.push(t); }
    }
    return out;
  }

  someday(): Todo[] {
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      const t = this.todos[i];
      if (t.lifecycle === LifecycleStatus.OPEN && t.start.mode === StartMode.SOMEDAY) { out.push(t); }
    }
    return out;
  }

  // Inbox is an organizational dimension (captured, not yet placed), NOT a StartMode.
  inbox(): Todo[] {
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      const t = this.todos[i];
      if (t.lifecycle === LifecycleStatus.OPEN && t.parentProjectId === '' && t.parentAreaId === '') { out.push(t); }
    }
    return out;
  }

  logbook(): Todo[] {
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      const t = this.todos[i];
      if (t.lifecycle !== LifecycleStatus.OPEN) { out.push(t); }
    }
    return out;
  }

  search(q: string): Todo[] {
    const needle = q.toLowerCase();
    const out: Todo[] = [];
    for (let i = 0; i < this.todos.length; i++) {
      if (this.todos[i].title.toLowerCase().indexOf(needle) >= 0) { out.push(this.todos[i]); }
    }
    return out;
  }
}
