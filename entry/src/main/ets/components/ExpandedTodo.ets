import { ChecklistItem } from '../model/domain';
import { ChecklistContainer } from './ChecklistContainer';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_RADIUS_MD, THINGS_SPACE_MD, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA } from '../theme/tokens';

// H05 ExpandedTodo — the SAME Todo object expanded in place (NOT a detail route).
// Slots: Title(TextArea, H05-B) / Notes(TextArea, H05-C1) / Checklist(H06) / ActionBar(H05-D).
// Editing uses a local Presentation Draft; commit (on blur) goes through a Command.
// Presentation state (expanded) belongs to UI, not to the Domain Todo.
@Component
export struct ExpandedTodo {
  @Prop title: string = '';
  @Prop notes: string = '';
  @Prop checklist: ChecklistItem[] = [];
  @State draftTitle: string = '';
  @State draftNotes: string = '';
  onCollapse: () => void = () => {};
  onToggleChecklist: (itemId: string) => void = (_: string) => {};
  onAddChecklist: (title: string) => void = (_: string) => {};
  onMoveChecklist: (itemId: string, step: number) => void = (_i: string, _s: number) => {};
  onOpenWhen: () => void = () => {};
  onOpenDeadline: () => void = () => {};
  onOpenTags: () => void = () => {};
  onTitleCommit: (title: string) => void = (_t: string) => {};
  onNotesCommit: (notes: string) => void = (_n: string) => {};

  aboutToAppear(): void {
    this.draftTitle = this.title;
    this.draftNotes = this.notes;
  }

  build() {
    Column({ space: THINGS_SPACE_MD }) {
      TextArea({ placeholder: '任务标题', text: this.draftTitle })
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .onChange((v: string) => { this.draftTitle = v; })
        .onBlur(() => this.onTitleCommit(this.draftTitle))

      TextArea({ placeholder: '备注', text: this.draftNotes })
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .onChange((v: string) => { this.draftNotes = v; })
        .onBlur(() => this.onNotesCommit(this.draftNotes))
        .width('100%')
        .height(72)

      ChecklistContainer({
        items: this.checklist,
        onToggle: (itemId: string) => this.onToggleChecklist(itemId),
        onAdd: (title: string) => this.onAddChecklist(title),
        onMove: (itemId: string, step: number) => this.onMoveChecklist(itemId, step)
      })

      Row({ space: THINGS_SPACE_MD }) {
        Text('When')
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          .onClick(() => this.onOpenWhen())
        Text('Tags')
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          .onClick(() => this.onOpenTags())
        Text('Checklist').fontSize(THINGS_FONT_METADATA).fontColor(THINGS_COLOR_TEXT_SECONDARY)
        Text('Deadline')
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          .onClick(() => this.onOpenDeadline())
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Text('收起')
        .fontSize(THINGS_FONT_METADATA)
        .fontColor(THINGS_COLOR_TEXT_SECONDARY)
        .onClick(() => this.onCollapse())
    }
    .width('100%')
    .padding(THINGS_SPACE_MD)
    .borderRadius(THINGS_RADIUS_MD)
    .backgroundColor(THINGS_COLOR_BG_PRIMARY)
    .shadow({ radius: 12, color: '#14000000', offsetY: 2 })
    .alignItems(HorizontalAlign.Start)
  }
}
