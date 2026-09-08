import { router } from '@kit.ArkUI';
import { Todo, TodoStore, TodoCommands, Start, StartMode, LifecycleStatus, ChecklistItem } from '../model/domain';
import { TodoRow } from '../components/TodoRow';
import { ExpandedTodo } from '../components/ExpandedTodo';
import { WhenPicker } from '../components/WhenPicker';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_SPACE_SM, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

function todayStr(): string {
  const d = new Date();
  const m = ((d.getMonth() + 1) < 10 ? '0' : '') + String(d.getMonth() + 1);
  const day = (d.getDate() < 10 ? '0' : '') + String(d.getDate());
  return String(d.getFullYear()) + '-' + m + '-' + day;
}

const store = (() => {
  const s = new TodoStore();
  const today = todayStr();
  const t1 = new Todo('t1', '买一本测试用的书', new Start(StartMode.ON_DATE, today));
  t1.deadline = today;
  t1.checklist = [
    new ChecklistItem('c1', '挑出版社', false, 0),
    new ChecklistItem('c2', '下单', false, 1)
  ];
  const t2 = new Todo('t2', '今晚健身半小时', new Start(StartMode.ON_DATE, today, true));
  t2.isRepeatCopy = true;
  t2.directTags = ['每日健身'];
  const t3 = new Todo('t3', '完成 Things 复刻 H05', new Start(StartMode.ANYTIME));
  t3.deadline = today;
  s.setTodos([t1, t2, t3]);
  return s;
})();

function deadlineLabel(t: Todo): string {
  if (t.deadline === '') { return ''; }
  return t.deadline === todayStr() ? '今天' : t.deadline;
}

function secondaryLabel(t: Todo): string {
  if (t.directTags.length > 0) { return t.directTags[0]; }
  return '';
}

// Today page: a Projection (working set), not a parent. Checkbox -> domain command;
// row tap -> inline expand (ExpandedTodo). WhenPicker is a page-level Overlay (H08).
@Entry
@Component
struct Today {
  @State items: Todo[] = [];
  @State expandedId: string = '';
  @State showWhen: boolean = false;
  @State whenTodoId: string = '';
  @State version: number = 0;

  aboutToAppear(): void {
    this.refresh();
  }

  refresh(): void {
    this.items = store.today(todayStr());
  }

  findTodo(id: string): Todo | undefined {
    const all = store.getAll();
    for (let i = 0; i < all.length; i++) {
      if (all[i].id === id) { return all[i]; }
    }
    return undefined;
  }

  toggle(t: Todo, completed: boolean): void {
    if (completed) { TodoCommands.complete(t); } else { TodoCommands.uncomplete(t); }
    this.refresh();
  }

  toggleChecklist(t: Todo, itemId: string): void {
    TodoCommands.toggleChecklist(t, itemId);
    this.version = this.version + 1;
  }

  addChecklist(t: Todo, title: string): void {
    TodoCommands.addChecklistItem(t, title);
    this.version = this.version + 1;
  }

  applyWhen(s: Start): void {
    const t = this.findTodo(this.whenTodoId);
    if (t !== undefined) { TodoCommands.setStart(t, s); }
    this.showWhen = false;
    this.refresh();
  }

  build() {
    Stack() {
      Column({ space: THINGS_SPACE_MD }) {
        Row({ space: THINGS_SPACE_SM }) {
          Text('‹')
            .fontSize(22)
            .fontColor(THINGS_COLOR_TEXT_PRIMARY)
            .onClick(() => router.back())
          Text('Today')
            .fontSize(THINGS_FONT_TITLE)
            .fontWeight(FontWeight.Bold)
            .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        }
        Text('注意力工作集 · Projection（非 Parent）')
          .fontSize(THINGS_FONT_BODY)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)

        List({ space: 0 }) {
          ForEach(this.items, (t: Todo) => {
            ListItem() {
              if (this.expandedId === t.id) {
                ExpandedTodo({
                  title: t.title,
                  notes: t.notes,
                  checklist: t.checklist,
                  onCollapse: () => { this.expandedId = ''; },
                  onToggleChecklist: (itemId: string) => this.toggleChecklist(t, itemId),
                  onAddChecklist: (title: string) => this.addChecklist(t, title),
                  onOpenWhen: () => { this.whenTodoId = t.id; this.showWhen = true; }
                })
              } else {
                TodoRow({
                  title: t.title,
                  checked: t.lifecycle === LifecycleStatus.COMPLETED,
                  repeat: t.isRepeatCopy,
                  secondary: secondaryLabel(t),
                  deadline: deadlineLabel(t),
                  onToggleCompletion: (v: boolean) => this.toggle(t, v),
                  onOpen: () => { this.expandedId = t.id; }
                })
              }
            }
          }, (t: Todo) => t.id)
        }
        .width('100%')
        .layoutWeight(1)
      }
      .width('100%')
      .height('100%')
      .padding(THINGS_SPACE_LG)
      .backgroundColor(THINGS_COLOR_BG_PRIMARY)
      .alignItems(HorizontalAlign.Start)

      // H08 page-level overlay: scrim + bottom sheet
      if (this.showWhen) {
        Column() {
          Blank()
          WhenPicker({
            todayStr: todayStr(),
            onSelect: (s: Start) => this.applyWhen(s),
            onDismiss: () => { this.showWhen = false; }
          })
        }
        .width('100%')
        .height('100%')
        .backgroundColor('#55000000')
        .onClick(() => { this.showWhen = false; })
      }
    }
    .width('100%')
    .height('100%')
  }
}
