import { router } from '@kit.ArkUI';
import { Todo, TodoCommands, Start, StartMode, LifecycleStatus } from '../model/domain';
import { appStore, todayStr, tomorrowStr } from '../model/app';
import { TodoRow } from '../components/TodoRow';
import { ExpandedTodo } from '../components/ExpandedTodo';
import { WhenPicker } from '../components/WhenPicker';
import { DeadlinePicker } from '../components/DeadlinePicker';
import { TagPicker } from '../components/TagPicker';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_ACCENT, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_SPACE_SM, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

const store = appStore;

function deadlineLabel(t: Todo): string {
  if (t.deadline === '') { return ''; }
  return t.deadline === todayStr() ? '今天' : t.deadline;
}
function secondaryLabel(t: Todo): string {
  if (t.directTags.length > 0) { return t.directTags[0]; }
  return '';
}

// Today page: a Projection (working set), not a parent; Checkbox -> Command; row tap -> expand.
// Multi-select is a UI Interaction Mode (SelectionController), never a Domain field.
// Overlays (H08) are page-level. Magic Plus quick-captures.
@Entry
@Component
struct Today {
  @State items: Todo[] = [];
  @State expandedId: string = '';
  @State activeOverlay: string = '';           // '' | 'when' | 'deadline' | 'tags'
  @State activeOverlayTargetId: string = '';
  @State selectionMode: boolean = false;
  @State selectedIds: string[] = [];
  @State version: number = 0;

  aboutToAppear(): void { this.refresh(); }

  refresh(): void { this.items = store.today(todayStr()); }

  findTodo(id: string): Todo | undefined {
    const all = store.getAll();
    for (let i = 0; i < all.length; i++) { if (all[i].id === id) { return all[i]; } }
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

  // --- multi-select (SelectionController) ---
  toggleSelect(id: string): void {
    if (this.selectedIds.indexOf(id) >= 0) {
      this.selectedIds = this.selectedIds.filter((x: string) => x !== id);
    } else {
      this.selectedIds = this.selectedIds.concat([id]);
    }
  }
  batchComplete(): void {
    const all = store.getAll();
    for (let i = 0; i < all.length; i++) {
      if (this.selectedIds.indexOf(all[i].id) >= 0) { TodoCommands.complete(all[i]); }
    }
    this.selectedIds = []; this.selectionMode = false; this.refresh();
  }
  batchDelete(): void {
    for (let i = 0; i < this.selectedIds.length; i++) { store.remove(this.selectedIds[i]); }
    this.selectedIds = []; this.selectionMode = false; this.refresh();
  }

  // --- commands via overlays ---
  applyWhen(s: Start): void {
    const all = store.getAll();
    if (this.selectionMode) {
      for (let i = 0; i < all.length; i++) {
        if (this.selectedIds.indexOf(all[i].id) >= 0) { TodoCommands.setStart(all[i], s); }
      }
    } else {
      const t = this.findTodo(this.activeOverlayTargetId);
      if (t !== undefined) { TodoCommands.setStart(t, s); }
    }
    this.activeOverlay = ''; this.refresh();
  }
  applyDeadline(date: string): void {
    const all = store.getAll();
    if (this.selectionMode) {
      for (let i = 0; i < all.length; i++) {
        if (this.selectedIds.indexOf(all[i].id) >= 0) { TodoCommands.setDeadline(all[i], date); }
      }
    } else {
      const t = this.findTodo(this.activeOverlayTargetId);
      if (t !== undefined) { TodoCommands.setDeadline(t, date); }
    }
    this.activeOverlay = ''; this.refresh();
  }
  applyTags(tags: string[]): void {
    const all = store.getAll();
    if (this.selectionMode) {
      for (let i = 0; i < all.length; i++) {
        if (this.selectedIds.indexOf(all[i].id) >= 0) { TodoCommands.setTags(all[i], tags); }
      }
    } else {
      const t = this.findTodo(this.activeOverlayTargetId);
      if (t !== undefined) { TodoCommands.setTags(t, tags); }
    }
    this.activeOverlay = ''; this.refresh();
  }

  quickAdd(): void {
    const t = new Todo('t' + Date.now().toString(), '新任务', new Start(StartMode.ANYTIME));
    store.addTodo(t);
    this.expandedId = t.id;
    this.refresh();
  }

  build() {
    Stack() {
      Column({ space: THINGS_SPACE_MD }) {
        Row() {
          Text('‹')
            .fontSize(22)
            .fontColor(THINGS_COLOR_TEXT_PRIMARY)
            .onClick(() => router.back())
          Text('Today')
            .fontSize(THINGS_FONT_TITLE)
            .fontWeight(FontWeight.Bold)
            .fontColor(THINGS_COLOR_TEXT_PRIMARY)
            .layoutWeight(1)
          Text(this.selectionMode ? '完成' : '选择')
            .fontSize(THINGS_FONT_BODY)
            .fontColor(THINGS_COLOR_ACCENT)
            .onClick(() => { this.selectionMode = !this.selectionMode; this.selectedIds = []; })
        }
        Text('注意力工作集 · Projection（非 Parent）')
          .fontSize(THINGS_FONT_BODY)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)

        List({ space: 0 }) {
          ForEach(this.items, (t: Todo) => {
            ListItem() {
              if (!this.selectionMode && this.expandedId === t.id) {
                ExpandedTodo({
                  title: t.title,
                  notes: t.notes,
                  checklist: t.checklist,
                  onCollapse: () => { this.expandedId = ''; },
                  onToggleChecklist: (itemId: string) => this.toggleChecklist(t, itemId),
                  onAddChecklist: (title: string) => this.addChecklist(t, title),
                  onOpenWhen: () => { this.activeOverlayTargetId = t.id; this.activeOverlay = 'when'; },
                  onOpenDeadline: () => { this.activeOverlayTargetId = t.id; this.activeOverlay = 'deadline'; },
                  onOpenTags: () => { this.activeOverlayTargetId = t.id; this.activeOverlay = 'tags'; }
                })
              } else {
                TodoRow({
                  title: t.title,
                  checked: t.lifecycle === LifecycleStatus.COMPLETED,
                  repeat: t.isRepeatCopy,
                  secondary: secondaryLabel(t),
                  deadline: deadlineLabel(t),
                  selectionMode: this.selectionMode,
                  selected: this.selectedIds.indexOf(t.id) >= 0,
                  onToggleCompletion: (v: boolean) => this.toggle(t, v),
                  onOpen: () => { this.expandedId = t.id; },
                  onToggleSelect: () => this.toggleSelect(t.id)
                })
              }
            }
          }, (t: Todo) => t.id)
        }
        .width('100%')
        .layoutWeight(1)

        if (this.selectionMode) {
          Row({ space: THINGS_SPACE_MD }) {
            Text('完成').fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_SECONDARY)
              .onClick(() => this.batchComplete())
            Text('删除').fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_PRIMARY)
              .onClick(() => this.batchDelete())
            Text('When').fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_PRIMARY)
              .onClick(() => { this.activeOverlay = 'when'; })
            Text('取消').fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_SECONDARY)
              .onClick(() => { this.selectionMode = false; this.selectedIds = []; })
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
          .justifyContent(FlexAlign.SpaceBetween)
        } else {
          Row() {
            Text('＋ 新建任务')
              .fontSize(THINGS_FONT_BODY)
              .fontColor(THINGS_COLOR_ACCENT)
              .onClick(() => this.quickAdd())
          }
          .width('100%')
          .padding({ top: 8, bottom: 8 })
        }
      }
      .width('100%')
      .height('100%')
      .padding(THINGS_SPACE_LG)
      .backgroundColor(THINGS_COLOR_BG_PRIMARY)
      .alignItems(HorizontalAlign.Start)

      if (this.activeOverlay === 'when') {
        Column() {
          Blank()
          WhenPicker({
            todayStr: todayStr(),
            onSelect: (s: Start) => this.applyWhen(s),
            onDismiss: () => { this.activeOverlay = ''; }
          })
        }
        .width('100%').height('100%').backgroundColor('#55000000')
        .onClick(() => { this.activeOverlay = ''; })
      } else if (this.activeOverlay === 'deadline') {
        Column() {
          Blank()
          DeadlinePicker({
            todayStr: todayStr(), tomorrowStr: tomorrowStr(),
            onSelect: (d: string) => this.applyDeadline(d),
            onClear: () => this.applyDeadline(''),
            onDismiss: () => { this.activeOverlay = ''; }
          })
        }
        .width('100%').height('100%').backgroundColor('#55000000')
        .onClick(() => { this.activeOverlay = ''; })
      } else if (this.activeOverlay === 'tags') {
        Column() {
          Blank()
          TagPicker({
            current: this.selectionMode ? [] : (this.findTodo(this.activeOverlayTargetId)?.directTags ?? []),
            onApply: (tags: string[]) => this.applyTags(tags),
            onDismiss: () => { this.activeOverlay = ''; }
          })
        }
        .width('100%').height('100%').backgroundColor('#55000000')
        .onClick(() => { this.activeOverlay = ''; })
      }
    }
    .width('100%')
    .height('100%')
  }
}
