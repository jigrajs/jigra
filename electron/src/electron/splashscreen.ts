import {
  WebPlugin, SplashScreenPlugin,
  SplashScreenHideOptions, SplashScreenShowOptions
} from "@jigra/core";

export class SplashScreenPluginElectron extends WebPlugin implements SplashScreenPlugin {

  ipc:any = null;

  constructor() {
    super({
      name: 'SplashScreen',
      platforms: ['electron']
    });

    this.ipc = require('electron').ipcRenderer;

  }

  async show(options?: SplashScreenShowOptions, callback?: Function) {
    this.ipc.send('showJigraSplashScreen', {...options});
    if (callback) {
      callback();
    }
  }

  async hide(options?: SplashScreenHideOptions, callback?: Function) {
    this.ipc.send('hideJigraSplashScreen', {...options});
    if (callback) {
      callback();
    }
  }

}

const SplashScreen = new SplashScreenPluginElectron();

export { SplashScreen };
