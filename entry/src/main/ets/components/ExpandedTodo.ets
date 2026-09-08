import { ChecklistItem } from '../model/domain';
import { ChecklistContainer } from './ChecklistContainer';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_RADIUS_MD, THINGS_SPACE_MD, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA } from '../theme/tokens';

// H05 ExpandedTodo — the SAME Todo object expanded in place (NOT a detail route).
// Slots: Title / Notes / Checklist / ActionBar(H05-D).
// Presentation state (expanded) belongs to UI, not to the Domain Todo.
// Action bar only emits presentation intents (OpenWhenPicker etc.), per H05-D.
@Component
export struct ExpandedTodo {
  @Prop title: string = '';
  @Prop notes: string = '';
  @Prop checklist: ChecklistItem[] = [];
  @State draftNotes: string = '';
  onCollapse: () => void = () => {};
  onToggleChecklist: (itemId: string) => void = (_: string) => {};
  onAddChecklist: (title: string) => void = (_: string) => {};
  onOpenWhen: () => void = () => {};
  onOpenDeadline: () => void = () => {};
  onOpenTags: () => void = () => {};

  build() {
    Column({ space: THINGS_SPACE_MD }) {
      Text(this.title)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)

      TextArea({ placeholder: '备注', text: this.draftNotes })
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .onChange((v: string) => { this.draftNotes = v; })
        .width('100%')
        .height(72)

      ChecklistContainer({
        items: this.checklist,
        onToggle: (itemId: string) => this.onToggleChecklist(itemId),
        onAdd: (title: string) => this.onAddChecklist(title)
      })

      // Action bar (H05-D): low-weight linear actions; only emit intents.
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
