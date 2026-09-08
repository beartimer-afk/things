import { THINGS_COLOR_ACCENT, THINGS_COLOR_CHECKBOX_STROKE, THINGS_HIT_TARGET, THINGS_CHECKBOX_VISUAL } from '../theme/tokens';

// H02 TodoCheckbox.
// Per spec:
//  - custom vector checkmark (Path), NOT a unicode glyph.
//  - visual circle (18vp) vs hit target (48vp) separated.
//  - onToggleCompletion only emits a completion intent (a domain Command upstream);
//    it must NOT trigger Row expand (event isolation).
//  - 'checked' is a one-way @Prop from the parent/domain; this component does not
//    flip it locally, so the completed state is domain-driven.
//  - Visual + token values remain PROVISIONAL until simulator/Geometry calibration.
@Component
export struct TodoCheckbox {
  @Prop checked: boolean = false;
  onToggleCompletion: (completed: boolean) => void = (_: boolean) => {};
  @State pressed: boolean = false;

  build() {
    Column() {
      Stack() {
        // visual circle
        Column()
          .width(THINGS_CHECKBOX_VISUAL)
          .height(THINGS_CHECKBOX_VISUAL)
          .borderRadius(THINGS_CHECKBOX_VISUAL / 2)
          .border({
            width: this.checked ? 0 : 1.5,
            color: this.checked ? THINGS_COLOR_ACCENT : THINGS_COLOR_CHECKBOX_STROKE
          })
          .backgroundColor(this.checked ? THINGS_COLOR_ACCENT : Color.Transparent)
        // custom checkmark vector (only when completed)
        if (this.checked) {
          Path()
            .width(11)
            .height(8)
            .commands('M1 4 L4 7 L10 1')
            .stroke(Color.White)
            .strokeWidth(2)
            .fillOpacity(0)
            .strokeLineCap(LineCapStyle.Round)
        }
      }
      .width(THINGS_CHECKBOX_VISUAL)
      .height(THINGS_CHECKBOX_VISUAL)
    }
    .width(THINGS_HIT_TARGET)
    .height(THINGS_HIT_TARGET)
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor(this.pressed ? '#1A000000' : Color.Transparent)
    .onTouch((e: TouchEvent) => {
      if (e.type === TouchType.Down) {
        this.pressed = true;
      } else if (e.type === TouchType.Up || e.type === TouchType.Cancel) {
        this.pressed = false;
      }
    })
    .onClick(() => {
      // H02: emit completion intent; domain decides the actual mutation.
      this.onToggleCompletion(!this.checked);
    })
  }
}
