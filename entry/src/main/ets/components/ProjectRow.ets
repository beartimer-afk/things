import { THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_ACCENT, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA } from '../theme/tokens';

// H07-A ProjectRow — Project summary/navigation row (NOT ProjectHeader).
// It is a separate component from the Project page header; do not merge them.
// Progress is computed by Presenter (Row does not traverse children).
// No Card / Shadow / Material Progress; Progress circle is a placeholder (ProjectProgressPie later).
@Component
export struct ProjectRow {
  @Prop title: string = '';
  @Prop progressText: string = '';
  @Prop completed: boolean = false;
  onOpen: () => void = () => {};

  build() {
    Row({ space: 12 }) {
      // ProjectProgressPie placeholder (custom pie added later; not a completion button)
      Row()
        .width(20)
        .height(20)
        .borderRadius(10)
        .border({ width: 2, color: this.completed ? THINGS_COLOR_ACCENT : THINGS_COLOR_TEXT_SECONDARY })
        .backgroundColor(this.completed ? THINGS_COLOR_ACCENT : Color.Transparent)

      Text(this.title)
        .fontSize(THINGS_FONT_BODY)
        .fontWeight(FontWeight.Medium)
        .fontColor(this.completed ? THINGS_COLOR_TEXT_SECONDARY : THINGS_COLOR_TEXT_PRIMARY)
        .layoutWeight(1)

      if (this.progressText !== '') {
        Text(this.progressText)
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
      }
    }
    .width('100%')
    .padding({ left: THINGS_SPACE_SM, right: THINGS_SPACE_SM, top: 10, bottom: 10 })
    .alignItems(VerticalAlign.Center)
    .onClick(() => this.onOpen())
  }
}
