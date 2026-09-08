import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_ACCENT, THINGS_COLOR_CHECKBOX_STROKE, THINGS_SPACE_MD, THINGS_SPACE_SM, THINGS_FONT_BODY, THINGS_FONT_METADATA, THINGS_RADIUS_MD } from '../theme/tokens';

const AVAILABLE_TAGS: string[] = ['每日健身', '工作', '生活', '高保真复刻'];

// H08-F TagPicker — edits directTags only. inherited/effective tags are computed at query
// time and must never be written back as direct tags (spec 02.4). Rendered as a bottom sheet.
@Component
export struct TagPicker {
  @Prop current: string[] = [];
  @State selection: string[] = [];
  onApply: (tags: string[]) => void = (_t: string[]) => {};
  onDismiss: () => void = () => {};

  aboutToAppear(): void {
    this.selection = this.current.slice();
  }

  toggle(tag: string): void {
    const has = this.selection.indexOf(tag) >= 0;
    if (has) {
      this.selection = this.selection.filter((x: string) => x !== tag);
    } else {
      this.selection = this.selection.concat([tag]);
    }
  }

  build() {
    Column({ space: 0 }) {
      Text('Tags')
        .fontSize(THINGS_FONT_BODY)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .padding({ top: 18, bottom: 8 })

      ForEach(AVAILABLE_TAGS, (tag: string) => {
        Row({ space: 12 }) {
          Text(tag)
            .fontSize(THINGS_FONT_BODY)
            .fontColor(THINGS_COLOR_TEXT_PRIMARY)
            .layoutWeight(1)
          Row()
            .width(20)
            .height(20)
            .borderRadius(10)
            .border({
              width: 1.5,
              color: this.selection.indexOf(tag) >= 0 ? THINGS_COLOR_ACCENT : THINGS_COLOR_CHECKBOX_STROKE
            })
            .backgroundColor(this.selection.indexOf(tag) >= 0 ? THINGS_COLOR_ACCENT : Color.Transparent)
        }
        .width('100%')
        .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 14, bottom: 14 })
        .onClick(() => this.toggle(tag))
      }, (tag: string) => tag)

      Row() {
        Text('完成')
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_ACCENT)
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 12, bottom: 6 })
      .onClick(() => this.onApply(this.selection))

      Row() {
        Text('取消')
          .fontSize(THINGS_FONT_METADATA)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          .layoutWeight(1)
      }
      .width('100%')
      .padding({ left: THINGS_SPACE_MD, right: THINGS_SPACE_MD, top: 8, bottom: 18 })
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
