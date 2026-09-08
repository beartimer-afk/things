import { Todo, TodoCommands, Project, LifecycleStatus } from '../model/domain';
import { appStore } from '../model/app';
import { ProjectRow } from '../components/ProjectRow';
import { TodoRow } from '../components/TodoRow';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_SPACE_SM, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

const AREA_ID = 'ar1';
const AREA_TITLE = '生活';

// Area page — a long-term responsibility container. Child Projects + direct Todos.
// Area has no completion/cancel lifecycle; Delete is a structural destructive command later.
@Entry
@Component
struct Area {
  go(url: string): void {
    try { this.getUIContext().getRouter().pushUrl({ url: url }); } catch (e) { /* non-fatal */ }
  }

  toggle(t: Todo, completed: boolean): void {
    if (completed) { TodoCommands.complete(t); } else { TodoCommands.uncomplete(t); }
  }

  build() {
    Scroll() {
      Column({ space: THINGS_SPACE_MD }) {
        Row({ space: THINGS_SPACE_SM }) {
          Text('‹').fontSize(22).fontColor(THINGS_COLOR_TEXT_PRIMARY)
            .onClick(() => this.getUIContext().getRouter().back())
          Text(AREA_TITLE).fontSize(THINGS_FONT_TITLE).fontWeight(FontWeight.Bold).fontColor(THINGS_COLOR_TEXT_PRIMARY)
        }
        Text('Area · 长期责任范围（非可完成目标，无进度环）')
          .fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_SECONDARY)

        ForEach(appStore.getProjects().filter((p: Project) => p.parentAreaId === AREA_ID), (p: Project) => {
          ProjectRow({
            title: p.title,
            onOpen: () => this.go('pages/Project')
          })
        }, (p: Project) => p.id)

        ForEach(appStore.getAll().filter((t: Todo) => t.parentAreaId === AREA_ID && t.headingId === ''), (t: Todo) => {
          TodoRow({
            title: t.title,
            checked: t.lifecycle === LifecycleStatus.COMPLETED,
            repeat: t.isRepeatCopy,
            secondary: t.directTags.length > 0 ? t.directTags[0] : '',
            deadline: t.deadline,
            onToggleCompletion: (v: boolean) => this.toggle(t, v),
            onOpen: () => {}
          })
        }, (t: Todo) => t.id)
      }
      .width('100%')
      .padding(THINGS_SPACE_LG)
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .height('100%')
    .backgroundColor(THINGS_COLOR_BG_PRIMARY)
  }
}
