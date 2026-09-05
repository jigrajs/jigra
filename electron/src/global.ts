import {Jigra as _Jigra} from '@jigra/core/dist/esm/definitions';

declare var window: any;

import { JigraElectron } from './runtime';

// Create our default Jigra instance, which will be
// overridden on native platforms
// @ts-ignore
var Jigra: _Jigra = new JigraElectron();

Jigra = window.Jigra || Jigra;

// Export window.Jigra if not available already (ex: web)
if (!window.Jigra) {
  window.Jigra = Jigra;
}

const Plugins = Jigra.Plugins;

export { Jigra, Plugins };
