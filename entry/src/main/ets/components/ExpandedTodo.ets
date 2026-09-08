import { ChecklistItem } from '../model/domain';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_ACCENT, THINGS_COLOR_CHECKBOX_STROKE, THINGS_RADIUS_MD, THINGS_SPACE_MD, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA } from '../theme/tokens';

// H05 ExpandedTodo — the SAME Todo object expanded in place (NOT a detail route).
// Slots: Title / Notes / Checklist / (ActionBar later H05-D).
// Presentation state (expanded) belongs to UI, not to the Domain Todo.
// This is a scaffold container; H05-B/C editors + H05-D action bar are refined later.
@Component
export struct ExpandedTodo {
  @Prop title: string = '';
  @Prop notes: string = '';
  @Prop checklist: ChecklistItem[] = [];
  @State draftNotes: string = '';
  onCollapse: () => void = () => {};
  onToggleChecklist: (itemId: string) => void = (_: string) => {};

  build() {
    Column({ space: THINGS_SPACE_MD }) {
      // Title slot (H05-B will be a multi-line editor; scaffold shows title)
      Text(this.title)
        .fontSize(17)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
      // Notes slot (H05-C editor; scaffold = placeholder text area)
      TextArea({ placeholder: '备注', text: this.draftNotes })
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .onChange((v: string) => { this.draftNotes = v; })
        .width('100%')
        .height(80)
      // Checklist slot (H06)
      if (this.checklist.length > 0) {
        Column({ space: THINGS_SPACE_SM }) {
          ForEach(this.checklist, (item: ChecklistItem) => {
            Row({ space: THINGS_SPACE_SM }) {
              Row()
                .width(16)
                .height(16)
                .borderRadius(8)
                .border({ width: 1.5, color: item.completed ? THINGS_COLOR_ACCENT : THINGS_COLOR_CHECKBOX_STROKE })
                .backgroundColor(item.completed ? THINGS_COLOR_ACCENT : Color.Transparent)
                .onClick(() => this.onToggleChecklist(item.id))
              Text(item.title)
                .fontSize(THINGS_FONT_BODY)
                .fontColor(item.completed ? THINGS_COLOR_TEXT_SECONDARY : THINGS_COLOR_TEXT_PRIMARY)
            }
            .width('100%')
            .alignItems(VerticalAlign.Center)
          }, (item: ChecklistItem) => item.id)
        }
      }
      // collapse affordance
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
