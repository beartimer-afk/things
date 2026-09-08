import { AbilityConstant, UIAbility, Want } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { appStore } from '../model/app';
import { TodoCommands } from '../model/domain';
import { PREF_NAME, saveTodos, loadTodos } from '../model/persistence';

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, 'Things', '%{public}s', 'Ability onCreate');
    this.initPersistence();
  }

  // Load persisted todos (if any) into the shared store, and hook Command mutations to save.
  private initPersistence(): void {
    try {
      const prefs = preferences.getPreferencesSync(this.context, { name: PREF_NAME });
      const loaded = loadTodos(prefs);
      if (loaded.length > 0) {
        appStore.setTodos(loaded);
      }
      TodoCommands.onMutate = () => {
        try { saveTodos(prefs, appStore.getAll()); } catch (e) { /* ignore */ }
      };
    } catch (e) {
      hilog.error(DOMAIN, 'Things', 'Persistence init failed: %{public}s', JSON.stringify(e));
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, 'Things', '%{public}s', 'Ability onWindowStageCreate');
    windowStage.loadContent('pages/MainLists', (err) => {
      if (err.code) {
        hilog.error(DOMAIN, 'Things', 'Failed to load the content. Cause: %{public}s', JSON.stringify(err));
        return;
      }
      hilog.info(DOMAIN, 'Things', '%{public}s', 'Succeeded in loading the content.');
    });
  }

  onDestroy(): void {
    hilog.info(DOMAIN, 'Things', '%{public}s', 'Ability onDestroy');
  }

  onWindowStageDestroy(): void {
    hilog.info(DOMAIN, 'Things', '%{public}s', 'Ability onWindowStageDestroy');
  }

  onForeground(): void {
    hilog.info(DOMAIN, 'Things', '%{public}s', 'Ability onForeground');
  }

  onBackground(): void {
    hilog.info(DOMAIN, 'Things', '%{public}s', 'Ability onBackground');
  }
}
