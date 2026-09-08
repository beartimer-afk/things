import { Todo, Project, Area } from '../model/domain';
import { appStore } from '../model/app';
import { TodoRow } from '../components/TodoRow';
import { AreaRow } from '../components/AreaRow';
import { THINGS_COLOR_BG_PRIMARY, THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_COLOR_ACCENT, THINGS_SPACE_MD, THINGS_SPACE_LG, THINGS_SPACE_SM, THINGS_FONT_TITLE, THINGS_FONT_BODY } from '../theme/tokens';

// Main Lists = global entry / organization overview (NOT a "all tasks" database page).
// System list entries are Projections (queries). Quick Find is a global overlay (navigation + deep search).
@Entry
@Component
struct MainLists {
  @State quickFind: boolean = false;
  @State query: string = '';
  @State results: Todo[] = [];
  @State areaExpanded: boolean = true;

  go(url: string): void {
    try { this.getUIContext().getRouter().pushUrl({ url: url }); } catch (e) { /* non-fatal */ }
  }

  updateSearch(q: string): void {
    this.query = q;
    this.results = appStore.search(q);
  }

  @Builder
  navRow(label: string, url: string) {
    Row() {
      Text(label).fontSize(THINGS_FONT_BODY).fontColor(THINGS_COLOR_TEXT_PRIMARY).layoutWeight(1)
    }
    .width('100%')
    .padding({ left: THINGS_SPACE_SM, right: THINGS_SPACE_SM, top: 12, bottom: 12 })
    .onClick(() => this.go(url))
  }

  build() {
    Stack() {
      Column({ space: THINGS_SPACE_MD }) {
        Text('Things')
          .fontSize(THINGS_FONT_TITLE)
          .fontWeight(FontWeight.Bold)
          .fontColor(THINGS_COLOR_TEXT_PRIMARY)
        Text('Main Lists · 全局入口（非数据库页）')
          .fontSize(THINGS_FONT_BODY)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)

        // Quick Find entry
        Text('搜索 …')
          .fontSize(THINGS_FONT_BODY)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          .onClick(() => { this.quickFind = true; this.query = ''; this.results = []; })

        this.navRow('Inbox', 'pages/Inbox')
        this.navRow('Today', 'pages/Today')
        this.navRow('Upcoming', 'pages/Upcoming')
        this.navRow('Anytime', 'pages/Anytime')
        this.navRow('Someday', 'pages/Someday')
        this.navRow('Logbook', 'pages/Logbook')

        // Areas (long-term responsibility; collapsible, children projects)
        ForEach(appStore.getAreas(), (ar: Area) => {
          AreaRow({
            title: ar.title,
            expanded: this.areaExpanded,
            children: appStore.getProjects().filter((p: Project) => p.parentAreaId === ar.id),
            onToggle: () => { this.areaExpanded = !this.areaExpanded; },
            onOpen: () => this.go('pages/Area')
          })
        }, (ar: Area) => ar.id)
      }
      .width('100%')
      .height('100%')
      .padding(THINGS_SPACE_LG)
      .backgroundColor(THINGS_COLOR_BG_PRIMARY)
      .alignItems(HorizontalAlign.Start)

      if (this.quickFind) {
        Column({ space: THINGS_SPACE_MD }) {
          Row({ space: THINGS_SPACE_SM }) {
            Text('‹').fontSize(22).fontColor(THINGS_COLOR_TEXT_PRIMARY)
              .onClick(() => { this.quickFind = false; })
            TextInput({ placeholder: '搜索任务 / 项目…', text: this.query })
              .onChange((v: string) => this.updateSearch(v))
              .layoutWeight(1)
              .height(36)
          }
          .width('100%')

          List({ space: 0 }) {
            ForEach(this.results, (t: Todo) => {
              ListItem() {
                TodoRow({
                  title: t.title,
                  secondary: t.directTags.length > 0 ? t.directTags[0] : '',
                  onToggleCompletion: () => {},
                  onOpen: () => { this.go('pages/Today'); }
                })
              }
            }, (t: Todo) => t.id)
          }
          .width('100%')
          .layoutWeight(1)
        }
        .width('100%')
        .height('100%')
        .padding(THINGS_SPACE_LG)
        .backgroundColor(THINGS_COLOR_BG_PRIMARY)
      }
    }
    .width('100%')
    .height('100%')
  }
}
