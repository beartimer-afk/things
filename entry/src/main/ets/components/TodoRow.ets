import { TodoCheckbox } from './TodoCheckbox';
import { THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_DEADLINE, THINGS_COLOR_ACCENT, THINGS_COLOR_CHECKBOX_STROKE, THINGS_COLOR_SELECTED_BG, THINGS_HIT_TARGET, THINGS_SPACE_SM, THINGS_SPACE_XS, THINGS_FONT_BODY, THINGS_FONT_METADATA } from '../theme/tokens';

// H03 TodoRow + H04 metadata slots + multi-select presentation (H05.3).
//   CheckboxSlot | ContentColumn(TitleLine + SecondaryLine) | Trailing
// In selection mode the checkbox is replaced by a right-side selection control and a
// light-blue selected background; tapping toggles selection (NOT expand).
// Event isolation: checkbox click => onToggleCompletion (NOT onOpen);
// row tap => onOpen (inline expand) normally, onToggleSelect in selection mode.
@Component
export struct TodoRow {
  @Prop title: string = '';
  @Prop checked: boolean = false;
  @Prop repeat: boolean = false;
  @Prop secondary: string = '';
  @Prop deadline: string = '';
  @Prop selectionMode: boolean = false;
  @Prop selected: boolean = false;
  onToggleCompletion: (completed: boolean) => void = (_: boolean) => {};
  onOpen: () => void = () => {};
  onToggleSelect: () => void = () => {};

  build() {
    Row({ space: THINGS_SPACE_XS }) {
      if (this.selectionMode) {
        // keep left anchor stable while in selection mode
        Column()
          .width(THINGS_HIT_TARGET)
          .height(THINGS_HIT_TARGET)
      } else {
        TodoCheckbox({
          checked: this.checked,
          onToggleCompletion: (v: boolean) => this.onToggleCompletion(v)
        })
      }

      Column({ space: THINGS_SPACE_XS }) {
        Row({ space: 6 }) {
          Text(this.title)
            .fontSize(THINGS_FONT_BODY)
            .fontColor(this.checked ? THINGS_COLOR_TEXT_SECONDARY : THINGS_COLOR_TEXT_PRIMARY)
          if (this.repeat) {
            Text('repeat')
              .fontSize(THINGS_FONT_METADATA)
              .fontColor(THINGS_COLOR_ACCENT)
          }
        }
        .alignItems(VerticalAlign.Center)

        if (this.secondary !== '') {
          Text(this.secondary)
            .fontSize(THINGS_FONT_METADATA)
            .fontColor(THINGS_COLOR_TEXT_SECONDARY)
        }
      }
      .layoutWeight(1)
      .alignItems(HorizontalAlign.Start)

      if (this.selectionMode) {
        Row()
          .width(22)
          .height(22)
          .borderRadius(11)
          .border({ width: 1.5, color: this.selected ? THINGS_COLOR_ACCENT : THINGS_COLOR_CHECKBOX_STROKE })
          .backgroundColor(this.selected ? THINGS_COLOR_ACCENT : Color.Transparent)
          .margin({ left: 8 })
      } else if (this.deadline !== '') {
        Text(this.deadline)
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_DEADLINE)
      }
    }
    .width('100%')
    .padding({ left: THINGS_SPACE_SM, right: THINGS_SPACE_SM, top: 10, bottom: 10 })
    .backgroundColor(this.selectionMode && this.selected ? THINGS_COLOR_SELECTED_BG : Color.Transparent)
    .alignItems(VerticalAlign.Center)
    .onClick(() => {
      if (this.selectionMode) {
        this.onToggleSelect();
      } else {
        this.onOpen();
      }
    })
  }
}
