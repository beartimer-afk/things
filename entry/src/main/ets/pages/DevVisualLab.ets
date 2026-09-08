import { TodoRow } from '../components/TodoRow';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

// H00 DevVisualLab — fixed fixtures render components independently of real data.
// Each state is opened by a fixed Fixture; later each gets a Golden screenshot.
// All visual values are PROVISIONAL until simulator/Geometry calibration.
@Entry
@Component
struct DevVisualLab {
  @State normalChecked: boolean = false;
  @State doneChecked: boolean = true;

  build() {
    Column({ space: THINGS_SPACE_MD }) {
      Text('DevVisualLab · H00')
        .fontSize(THINGS_FONT_TITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
      Text('TodoRow states (PROVISIONAL)')
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_SECONDARY)

      // F01 normal short
      TodoRow({
        title: '买一本测试用的书',
        checked: this.normalChecked,
        deadline: '今天',
        onToggleCompletion: (v: boolean) => { this.normalChecked = v; }
      })
      // F02 normal + repeat + secondary
      TodoRow({
        title: '今晚健身半小时',
        checked: false,
        repeat: true,
        secondary: '每日健身'
      })
      // F03 long title + metadata
      TodoRow({
        title: '完成 Things 高保真复刻的 H04 元数据与截止排布，并验证长标题下的行压缩与 trailing 稳定',
        checked: false,
        secondary: '项目·高保真复刻',
        deadline: '明天'
      })
      // F04 completed
      TodoRow({
        title: '已完成的复刻里程碑',
        checked: this.doneChecked,
        secondary: '项目·高保真复刻',
        onToggleCompletion: (v: boolean) => { this.doneChecked = v; }
      })
    }
    .width('100%')
    .height('100%')
    .padding(THINGS_SPACE_LG)
    .backgroundColor(THINGS_COLOR_BG_PRIMARY)
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}
