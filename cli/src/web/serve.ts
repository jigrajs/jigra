import { runCommand, runTask } from '../common';
import { Config } from '../config';

export async function serveWeb(config: Config) {
  await runTask(`Serving web content in: ${config.app.webDir}`, () => {
    return runCommand(`npx @rindo/core@1.8.12 serve --open --root ${config.app.webDir}`);
  });
}
