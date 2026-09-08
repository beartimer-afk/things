import { Project } from '../model/domain';
import { ProjectRow } from './ProjectRow';
import { THINGS_COLOR_TEXT_PRIMARY, THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_SM, THINGS_FONT_BODY } from '../theme/tokens';

// H07-B AreaRow — long-term responsibility container; NO completion/cancel lifecycle,
// NO progress pie. Collapse is a Presentation preference, never written to Domain.
// chevron toggles; title/body opens the Area page. Child Projects are rendered below.
@Component
export struct AreaRow {
  @Prop title: string = '';
  @Prop expanded: boolean = false;
  @Prop children: Project[] = [];
  onToggle: () => void = () => {};
  onOpen: () => void = () => {};

  build() {
    Column({ space: 0 }) {
      Row({ space: 12 }) {
        Text(this.expanded ? '▾' : '▸')
          .fontSize(14)
          .fontColor(THINGS_COLOR_TEXT_SECONDARY)
          .onClick(() => this.onToggle())
        Text(this.title)
          .fontSize(THINGS_FONT_BODY)
          .fontWeight(FontWeight.Medium)
          .fontColor(THINGS_COLOR_TEXT_PRIMARY)
          .layoutWeight(1)
          .onClick(() => this.onOpen())
      }
      .width('100%')
      .padding({ left: THINGS_SPACE_SM, right: THINGS_SPACE_SM, top: 12, bottom: 12 })
      .alignItems(VerticalAlign.Center)

      if (this.expanded) {
        Column() {
          ForEach(this.children, (p: Project) => {
            ProjectRow({
              title: p.title,
              onOpen: () => {}
            })
          }, (p: Project) => p.id)
        }
        .width('100%')
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
