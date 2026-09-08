import { ChecklistItem } from '../model/domain';
import { THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_ACCENT, THINGS_COLOR_CHECKBOX_STROKE, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA } from '../theme/tokens';

// H06 Checklist: sub-entity system of a Todo (not a mini Todo, not a Notes task list).
// Item = left completion circle + title + right drag grip. Order is Todo-scoped (rank),
// NOT the global Project/Today ContextOrder. ChecklistItem is its own Domain entity.
// H06-B: a new item first lives as a Presentation Draft (local), committed via Command.
// For the scaffold we keep a local @State copy (sync-on-appear) so add/toggle reflect
// immediately; each mutation also emits the domain Command.
@Component
export struct ChecklistContainer {
  @Prop items: ChecklistItem[] = [];
  @State internalItems: ChecklistItem[] = [];
  @State newTitle: string = '';
  onToggle: (itemId: string) => void = (_: string) => {};
  onAdd: (title: string) => void = (_: string) => {};
  onMove: (itemId: string, step: number) => void = (_i: string, _s: number) => {};

  aboutToAppear(): void {
    this.internalItems = this.items.slice();
  }

  toggleLocal(itemId: string): void {
    for (let i = 0; i < this.internalItems.length; i++) {
      if (this.internalItems[i].id === itemId) {
        this.internalItems[i].completed = !this.internalItems[i].completed;
      }
    }
    this.onToggle(itemId);
  }

  addLocal(): void {
    if (this.newTitle === '') { return; }
    const fresh = new ChecklistItem('local-' + Date.now().toString(), this.newTitle, false, this.internalItems.length);
    this.internalItems = this.internalItems.concat([fresh]);
    this.onAdd(this.newTitle);
    this.newTitle = '';
  }

  moveLocal(itemId: string, step: number): void {
    let idx = -1;
    for (let i = 0; i < this.internalItems.length; i++) { if (this.internalItems[i].id === itemId) { idx = i; } }
    const to = idx + step;
    if (idx < 0 || to < 0 || to >= this.internalItems.length) { return; }
    const copy = this.internalItems.slice();
    const tmp = copy[idx];
    copy[idx] = copy[to];
    copy[to] = tmp;
    this.internalItems = copy;
    this.onMove(itemId, step);
  }

  build() {
    Column({ space: THINGS_SPACE_SM }) {
      ForEach(this.internalItems, (item: ChecklistItem) => {
        Row({ space: THINGS_SPACE_SM }) {
          Row()
            .width(16)
            .height(16)
            .borderRadius(8)
            .border({ width: 1.5, color: item.completed ? THINGS_COLOR_ACCENT : THINGS_COLOR_CHECKBOX_STROKE })
            .backgroundColor(item.completed ? THINGS_COLOR_ACCENT : Color.Transparent)
            .onClick(() => this.toggleLocal(item.id))
          Text(item.title)
            .fontSize(THINGS_FONT_BODY)
            .fontColor(item.completed ? THINGS_COLOR_TEXT_SECONDARY : THINGS_COLOR_TEXT_PRIMARY)
            .layoutWeight(1)
          // drag grip (H06-C: only the grip long-presses to reorder; scaffold placeholder)
          Text('≡')
            .fontSize(THINGS_FONT_METADATA)
            .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          // Todo-scoped reorder (rank); demonstrate reorder-only-within-this-todo
          Column() {
            Text('▲').fontSize(10).fontColor(THINGS_COLOR_TEXT_SECONDARY).onClick(() => this.moveLocal(item.id, -1))
            Text('▼').fontSize(10).fontColor(THINGS_COLOR_TEXT_SECONDARY).onClick(() => this.moveLocal(item.id, 1))
          }
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)
      }, (item: ChecklistItem) => item.id)

      Row({ space: THINGS_SPACE_SM }) {
        TextInput({ placeholder: '添加清单项', text: this.newTitle })
          .onChange((v: string) => { this.newTitle = v; })
          .layoutWeight(1)
          .height(32)
        Text('添加')
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_ACCENT)
          .onClick(() => this.addLocal())
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
