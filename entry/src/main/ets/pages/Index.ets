import { TodoCheckbox } from '../components/TodoCheckbox';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_FONT_TITLE, THINGS_FONT_BODY, THINGS_SPACE_MD, THINGS_SPACE_SM, THINGS_SPACE_LG } from '../theme/tokens';

// Main entry page (scaffold). Will become the Main Lists / Today shell per spec 03.
@Entry
@Component
struct Index {
  build() {
    Column({ space: THINGS_SPACE_MD }) {
      Text('Things')
        .fontSize(THINGS_FONT_TITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
      Text('高保真复刻 · HarmonyOS · 工程骨架')
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_SECONDARY)
      Row({ space: THINGS_SPACE_SM }) {
        TodoCheckbox()
      }
      Text('H00–H02 骨架：DevVisualLab + Foundation Tokens + TodoCheckbox')
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_SECONDARY)
    }
    .width('100%')
    .height('100%')
    .padding(THINGS_SPACE_LG)
    .backgroundColor(THINGS_COLOR_BG_PRIMARY)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}
