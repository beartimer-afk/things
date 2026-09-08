import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA, THINGS_RADIUS_MD } from '../theme/tokens';

// H08-D DeadlinePicker — edits Deadline only (DeadlineValue = LocalDate | None).
// Never edits Start / Evening / Reminder. Deadline is orthogonal to Start.
// Rendered inside a page-level OverlayHost (scrim + bottom sheet).
@Component
export struct DeadlinePicker {
  todayStr: string = '';
  tomorrowStr: string = '';
  onSelect: (date: string) => void = (_d: string) => {};
  onClear: () => void = () => {};
  onDismiss: () => void = () => {};

  build() {
    Column({ space: 0 }) {
      Text('Deadline')
        .fontSize(THINGS_FONT_BODY)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .padding({ top: 18, bottom: 8 })

      Row() {
        Text('今天').fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_PRIMARY).layoutWeight(1)
      }
      .width('100%')
      .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 14, bottom: 14 })
      .onClick(() => this.onSelect(this.todayStr))

      Row() {
        Text('明天').fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_PRIMARY).layoutWeight(1)
      }
      .width('100%')
      .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 14, bottom: 14 })
      .onClick(() => this.onSelect(this.tomorrowStr))

      Row() {
        Text('清除').fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_PRIMARY).layoutWeight(1)
      }
      .width('100%')
      .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 14, bottom: 14 })
      .onClick(() => this.onClear())

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
