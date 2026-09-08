import { Todo, TodoStore, Start, StartMode, LifecycleStatus, ChecklistItem, Project, Area } from './domain';

export function fmtDate(d: Date): string {
  const m = ((d.getMonth() + 1) < 10 ? '0' : '') + String(d.getMonth() + 1);
  const day = (d.getDate() < 10 ? '0' : '') + String(d.getDate());
  return String(d.getFullYear()) + '-' + m + '-' + day;
}
export function todayStr(): string { return fmtDate(new Date()); }
export function tomorrowStr(): string { const d = new Date(); d.setDate(d.getDate() + 1); return fmtDate(d); }
export function plusDaysStr(n: number): string { const d = new Date(); d.setDate(d.getDate() + n); return fmtDate(d); }

// Single source of truth for the scaffold. Persistence (preferences) is a later concern;
// for now a deterministic in-memory seed covering all projection windows.
export const appStore = (() => {
  const s = new TodoStore();
  const today = todayStr();
  s.setAreas([new Area('ar1', '生活')]);
  s.setProjects([new Project('p1', '高保真复刻')]);
  s.getProjects()[0].parentAreaId = 'ar1';

  const mk = (id: string, title: string, start: Start): Todo => new Todo(id, title, start);

  const t1 = mk('t1', '买一本测试用的书', new Start(StartMode.ON_DATE, today));
  t1.deadline = today;
  t1.checklist = [new ChecklistItem('c1', '挑出版社', false, 0), new ChecklistItem('c2', '下单', false, 1)];

  const t2 = mk('t2', '今晚健身半小时', new Start(StartMode.ON_DATE, today, true));
  t2.isRepeatCopy = true;
  t2.directTags = ['每日健身'];

  const t3 = mk('t3', '完成 Things 复刻 H06', new Start(StartMode.ANYTIME));
  t3.deadline = today;

  // Inbox (unorganized)
  const i1 = mk('i1', '随手记一条想法', new Start(StartMode.ANYTIME));
  const i2 = mk('i2', '给朋友发消息', new Start(StartMode.ANYTIME));

  // Upcoming
  const u1 = mk('u1', '下周会议准备', new Start(StartMode.ON_DATE, plusDaysStr(3)));

  // Someday
  const d1 = mk('d1', '学一门新语言', new Start(StartMode.SOMEDAY));

  // Project todos (heading h1/h2)
  const a1 = mk('a1', '搭建 HarmonyOS 工程', new Start(StartMode.ANYTIME));
  a1.parentProjectId = 'p1';
  a1.headingId = 'h1';
  const a2 = mk('a2', '实现 TodoRow', new Start(StartMode.ANYTIME));
  a2.parentProjectId = 'p1';
  a2.headingId = 'h1';
  const b1 = mk('b1', '实现 Checklist', new Start(StartMode.ANYTIME));
  b1.parentProjectId = 'p1';
  b1.headingId = 'h2';
  const l1 = mk('l1', '写 README', new Start(StartMode.ANYTIME));
  l1.parentProjectId = 'p1';

  // Completed (logbook)
  const done = mk('done1', '已完成的里程碑', new Start(StartMode.ON_DATE, today));
  done.lifecycle = LifecycleStatus.COMPLETED;

  s.setTodos([t1, t2, t3, i1, i2, u1, d1, a1, a2, b1, l1, done]);
  return s;
})();
