import { THINGS_COLOR_ACCENT, THINGS_COLOR_CHECKBOX_STROKE, THINGS_HIT_TARGET, THINGS_CHECKBOX_VISUAL } from '../theme/tokens';

// H02 TodoCheckbox — scaffold milestone.
// NOTE: This is a minimal compilable skeleton. The full H02 spec requires:
//  - custom vector checkmark (path), NOT a unicode glyph
//  - visual circle vs hit-target separation (visual 18vp / hit 48vp)
//  - only emit onToggleCompletion(todoId); must NOT trigger Row expand
//  - state: open / completed / pressed; completion must be a domain Command
// These are implemented in the actual H02 task, not here.
@Component
export struct TodoCheckbox {
  @State checked: boolean = false;
  onToggle: (checked: boolean) => void = (_: boolean) => {};

  build() {
    Column() {
      Column()
        .width(THINGS_CHECKBOX_VISUAL)
        .height(THINGS_CHECKBOX_VISUAL)
        .borderRadius(THINGS_CHECKBOX_VISUAL / 2)
        .border({
          width: this.checked ? 0 : 1.5,
          color: this.checked ? THINGS_COLOR_ACCENT : THINGS_COLOR_CHECKBOX_STROKE
        })
        .backgroundColor(this.checked ? THINGS_COLOR_ACCENT : Color.Transparent)
    }
    .width(THINGS_HIT_TARGET)
    .height(THINGS_HIT_TARGET)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.checked = !this.checked;
      this.onToggle(this.checked);
    })
  }
}
