import { router } from '@kit.ArkUI';
import { ProjectRow } from '../components/ProjectRow';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_SPACE_SM, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

// Main Lists = global entry / organization overview (NOT a "all tasks" database page).
// System list entries are Projections (queries); Area/Project rows go to their pages.
// Kept low-chrome: whitespace rhythm, no Card / Divider / per-row background blocks.
@Entry
@Component
struct MainLists {
  go(url: string): void {
    try {
      router.pushUrl({ url: url });
    } catch (e) {
      // navigation failure is non-fatal for the scaffold
    }
  }

  @Builder
  navRow(label: string, url: string) {
    Row() {
      Text(label)
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        .layoutWeight(1)
    }
    .width('100%')
    .padding({ left: THINGS_SPACE_SM, right: THINGS_SPACE_SM, top: 12, bottom: 12 })
    .onClick(() => this.go(url))
  }

  build() {
    Column({ space: THINGS_SPACE_MD }) {
      Text('Things')
        .fontSize(THINGS_FONT_TITLE)
        .fontWeight(FontWeight.Bold)
        .fontColor(THINGS_COLOR_TEXT_PRIMARY)
      Text('Main Lists · 全局入口（非数据库页）')
        .fontSize(THINGS_FONT_BODY)
        .fontColor(THINGS_COLOR_TEXT_SECONDARY)

      this.navRow('Inbox', 'pages/Today')
      this.navRow('Today', 'pages/Today')
      this.navRow('Upcoming', 'pages/Today')

      ProjectRow({
        title: '高保真复刻',
        progressText: '3/8',
        onOpen: () => this.go('pages/Project')
      })
    }
    .width('100%')
    .height('100%')
    .padding(THINGS_SPACE_LG)
    .backgroundColor(THINGS_COLOR_BG_PRIMARY)
    .alignItems(HorizontalAlign.Start)
  }
}
