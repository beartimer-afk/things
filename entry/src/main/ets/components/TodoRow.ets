import { TodoCheckbox } from './TodoCheckbox';
import { THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_DEADLINE, THINGS_COLOR_ACCENT, THINGS_SPACE_SM, THINGS_SPACE_XS, THINGS_FONT_BODY, THINGS_FONT_METADATA } from '../theme/tokens';

// H03 TodoRow + H04 metadata slots.
// Layout per spec:
//   CheckboxSlot [H02] | ContentColumn(TitleLine + SecondaryLine) | Trailing
//   TitleLine = Title + InlineSuffix (repeat indicator)     [H04]
//   SecondaryLine = parent/reminder (weak)                  [H04-B3]
//   Trailing = deadline (high priority, must not be squeezed) [H04-B1]
// Visual: no Card / no Divider / no Shadow; whitespace + rhythm carry the hierarchy.
// Event isolation: Checkbox click => onToggleCompletion (NOT onOpen);
// Row tap => onOpen (inline expand, NOT a detail route).
@Component
export struct TodoRow {
  @Prop title: string = '';
  @Prop checked: boolean = false;
  @Prop repeat: boolean = false;      // InlineSuffix (H04-B2; custom vector later)
  @Prop secondary: string = '';       // SecondaryLine (H04-B3)
  @Prop deadline: string = '';        // Trailing (H04-B1)
  onToggleCompletion: (completed: boolean) => void = (_: boolean) => {};
  onOpen: () => void = () => {};

  build() {
    Row({ space: THINGS_SPACE_XS }) {
      TodoCheckbox({
        checked: this.checked,
        onToggleCompletion: (v: boolean) => this.onToggleCompletion(v)
      })

      Column({ space: THINGS_SPACE_XS }) {
        Row({ space: 6 }) {
          Text(this.title)
            .fontSize(THINGS_FONT_BODY)
            .fontColor(this.checked ? THINGS_COLOR_TEXT_SECONDARY : THINGS_COLOR_TEXT_PRIMARY)
          if (this.repeat) {
            // repeat indicator placeholder; replace with custom repeat vector (H04-B2)
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

      if (this.deadline !== '') {
        Text(this.deadline)
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_DEADLINE)
      }
    }
    .width('100%')
    .padding({ left: THINGS_SPACE_SM, right: THINGS_SPACE_SM, top: 10, bottom: 10 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => this.onOpen())
  }
}
