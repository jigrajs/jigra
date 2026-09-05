import { logFatal, resolveNode, runTask } from '../common';
import { Config } from '../config';
import { copy } from 'fs-extra';
import { join } from 'path';

export async function copyWeb(config: Config) {
  if (config.app.bundledWebRuntime) {
    const runtimePath = resolveNode(config, '@jigra/core', 'dist', 'jigra.js');
    if (!runtimePath) {
      logFatal(`Unable to find node_modules/@jigra/core/dist/jigra.js. Are you sure`,
        '@jigra/core is installed? This file is required for Jigra to function');
      return;
    }

    return runTask(`Copying jigra.js to web dir`, () => {
      return copy(runtimePath, join(config.app.webDirAbs, 'jigra.js'));
    });
  }
}
