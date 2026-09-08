import { Start, StartMode } from '../model/domain';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA, THINGS_RADIUS_MD } from '../theme/tokens';

// H08-C WhenPicker — edits Start only (never Deadline).
// StartMode = ON_DATE | ANYTIME | SOMEDAY; evening only for OnDate(today).
// Rendered inside a page-level OverlayHost (scrim + bottom sheet); this component is the panel.
@Component
export struct WhenPicker {
  todayStr: string = '';
  onSelect: (s: Start) => void = (_s: Start) => {};
  onDismiss: () => void = () => {};

  @Builder
  option(label: string, sel: Start) {
    Row() {
      Text(label)
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 14, bottom: 14 })
    .onClick(() => this.onSelect(sel))
  }

  build() {
    Column({ space: 0 }) {
      Text('When')
        .fontSize(THINGS_FONT_BODY)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .padding({ top: 18, bottom: 8 })

      this.option('今天', new Start(StartMode.ON_DATE, this.todayStr))
      this.option('今晚', new Start(StartMode.ON_DATE, this.todayStr, true))
      this.option('Anytime', new Start(StartMode.ANYTIME))
      this.option('Someday', new Start(StartMode.SOMEDAY))

      Row() {
        Text('取消')
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 14, bottom: 18 })
      .onClick(() => this.onDismiss())
    }
    .width('100%')
    .borderRadius({ topLeft: THINGS_RADIUS_MD, topRight: THINGS_RADIUS_MD })
    .backgroundColor(THINGS_COLOR_BG_PRIMARY)
    .shadow({ radius: 16, color: '#22000000', offsetY: -2 })
    .alignItems(HorizontalAlign.Start)
    .onClick(() => { /* consume sheet-background taps so they don't dismiss via scrim */ })
  }
}
