import { router } from '@kit.ArkUI';
import { Todo, TodoCommands, LifecycleStatus } from '../model/domain';
import { appStore, todayStr } from '../model/app';
import { TodoRow } from '../components/TodoRow';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_SPACE_SM, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

@Entry
@Component
struct Upcoming {
  @State items: Todo[] = [];

  aboutToAppear(): void { this.items = appStore.upcoming(todayStr()); }

  toggle(t: Todo, completed: boolean): void {
    if (completed) { TodoCommands.complete(t); } else { TodoCommands.uncomplete(t); }
    this.items = appStore.upcoming(todayStr());
  }

  build() {
    Column({ space: THINGS_SPACE_MD }) {
      Row({ space: THINGS_SPACE_SM }) {
        Text('‹').fontSize(22).fontColor(THINGS_COLOR_TEXT_PRIMARY).onClick(() => router.back())
        Text('Upcoming').fontSize(THINGS_FONT_TITLE).fontWeight(FontWeight.Bold).fontColor(THINGS_COLOR_TEXT_PRIMARY)
      }
      Text('未来承诺时间线（非可 Move 进入的 Folder）')
        .fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_SECONDARY)
      List({ space: 0 }) {
        ForEach(this.items, (t: Todo) => {
          ListItem() {
            TodoRow({
              title: t.title,
              checked: t.lifecycle === LifecycleStatus.COMPLETED,
              secondary: t.directTags.length > 0 ? t.directTags[0] : '',
              deadline: t.deadline,
              onToggleCompletion: (v: boolean) => this.toggle(t, v),
              onOpen: () => {}
            })
          }
        }, (t: Todo) => t.id)
      }
      .width('100%').layoutWeight(1)
    }
    .width('100%').height('100%').padding(THINGS_SPACE_LG)
    .backgroundColor(THINGS_COLOR_BG_PRIMARY).alignItems(HorizontalAlign.Start)
  }
}
