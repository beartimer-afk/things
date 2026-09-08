import { Todo } from '../model/domain';
import { TodoRow } from './TodoRow';
import { THINGS_COLOR_TEXT_SECONDARY, THINGS_SPACE_SM, THINGS_FONT_METADATA } from '../theme/tokens';

// H07-C HeadingBlock = HeadingHeader + continuous child Todo segment.
// Heading is a stable Project-scoped entity; NOT Todo.isHeading.
// Here a simple title + child TodoRows; full duplicate/convert/archive/delete added later.
@Component
export struct HeadingBlock {
  @Prop title: string = '';
  @Prop todos: Todo[] = [];
  onToggleCompletion: (t: Todo, completed: boolean) => void = (_t: Todo, _c: boolean) => {};
  onOpen: (t: Todo) => void = (_t: Todo) => {};

  build() {
    Column({ space: 0 }) {
      Text(this.title)
        .fontSize(THINGS_FONT_METADATA)
        .fontWeight(FontWeight.Medium)
        .fontColor(THINGS_COLOR_TEXT_SECONDARY)
        .padding({ top: 12, bottom: 6 })

      ForEach(this.todos, (t: Todo) => {
        TodoRow({
          title: t.title,
          checked: t.lifecycle === 1,
          repeat: t.isRepeatCopy,
          onToggleCompletion: (v: boolean) => this.onToggleCompletion(t, v),
          onOpen: () => this.onOpen(t)
        })
      }, (t: Todo) => t.id)
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }
}
