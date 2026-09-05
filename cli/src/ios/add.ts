import { checkCocoaPods } from './common';
import { CheckFunction, TaskInfoProvider, copyTemplate, getCLIVersion, installDeps, resolveNode, runTask } from '../common';
import { Config } from '../config';

export const addIOSChecks: CheckFunction[] = [checkCocoaPods];

export async function addIOS(config: Config) {
  await runTask(`Installing iOS dependencies`, async (info: TaskInfoProvider) => {
    if (resolveNode(config, '@jigra/ios')) {
      info('Skipping: already installed');
      return;
    }
    const cliVersion = await getCLIVersion(config);
    return installDeps(config.app.rootDir, [`@jigra/ios@${cliVersion}`], config);
  });
  await runTask(`Adding native xcode project in: ${config.ios.platformDir}`, () => {
    return copyTemplate(config.ios.assets.templateDir, config.ios.platformDir);
  });
}
