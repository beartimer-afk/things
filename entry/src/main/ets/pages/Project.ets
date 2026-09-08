import { Todo, TodoStore, TodoCommands, Start, StartMode, LifecycleStatus } from '../model/domain';
import { TodoRow } from '../components/TodoRow';
import { HeadingBlock } from '../components/HeadingBlock';
import { ExpandedTodo } from '../components/ExpandedTodo';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

const PROJECT_TITLE = '高保真复刻';

class HeadingMeta {
  id: string;
  title: string;
  constructor(id: string, title: string) {
    this.id = id;
    this.title = title;
  }
}

const HEADINGS: HeadingMeta[] = [
  new HeadingMeta('h1', '实施'),
  new HeadingMeta('h2', '交互')
];

const store = (() => {
  const s = new TodoStore();
  const mk = (id: string, title: string, headingId: string): Todo => {
    const t = new Todo(id, title, new Start(StartMode.ANYTIME));
    t.headingId = headingId;
    return t;
  };
  s.setTodos([
    mk('a1', '搭建 HarmonyOS 工程', 'h1'),
    mk('a2', '实现 TodoRow', 'h1'),
    mk('b1', '实现 Checklist', 'h2'),
    mk('b2', '实现 Overlay', 'h2'),
    mk('l1', '写 README', ''),
    mk('l2', '推送到远端', '')
  ]);
  return s;
})();

// H07 organization page: a Project is a result container with Headings (structure)
// and loose Todo children. Heading is a stable Project-scoped entity.
@Entry
@Component
struct Project {
  @State expandedId: string = '';
  @State version: number = 0;

  toggle(t: Todo, completed: boolean): void {
    if (completed) { TodoCommands.complete(t); } else { TodoCommands.uncomplete(t); }
    this.version = this.version + 1;
  }

  toggleFromHeading(t: Todo, completed: boolean): void {
    this.toggle(t, completed);
  }

  build() {
    Scroll() {
      Column({ space: THINGS_SPACE_MD }) {
        Text(PROJECT_TITLE)
          .fontSize(THINGS_FONT_TITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        Text('Project 页面 · 组织结构（Heading + loose Todo）')
          .fontSize(THINGS_FONT_BODY)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)

        // loose todos (no heading)
        ForEach(store.getAll().filter((t: Todo) => t.headingId === ''), (t: Todo) => {
          if (this.expandedId === t.id) {
            ExpandedTodo({
              title: t.title,
              notes: t.notes,
              checklist: t.checklist,
              onCollapse: () => { this.expandedId = ''; }
            })
          } else {
            TodoRow({
              title: t.title,
              checked: t.lifecycle === LifecycleStatus.COMPLETED,
              repeat: t.isRepeatCopy,
              secondary: t.directTags.length > 0 ? t.directTags[0] : '',
              deadline: t.deadline,
              onToggleCompletion: (v: boolean) => this.toggle(t, v),
              onOpen: () => { this.expandedId = t.id; }
            })
          }
        }, (t: Todo) => t.id)

        // heading blocks grouped by stable heading id
        ForEach(HEADINGS, (h: HeadingMeta) => {
          HeadingBlock({
            title: h.title,
            todos: store.getAll().filter((t: Todo) => t.headingId === h.id),
            onToggleCompletion: (t: Todo, v: boolean) => this.toggleFromHeading(t, v),
            onOpen: (t: Todo) => { this.expandedId = t.id; }
          })
        }, (h: HeadingMeta) => h.id)
      }
      .width('100%')
      .padding(THINGS_SPACE_LG)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(THINGS_COLOR_BG_PRIMARY)
  }
}
