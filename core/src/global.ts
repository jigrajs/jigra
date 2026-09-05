import { Jigra as _Jigra } from './definitions';
import { JigraWeb } from './web-runtime';


// Create our default Jigra instance, which will be
// overridden on native platforms
const Jigra = ((globalThis: any): _Jigra => {
  // Create a new JigraWeb instance if one doesn't already exist on globalThis
  // Ensure the global is assigned the same Jigra instance,
  // then export Jigra so it can be imported in other modules
  return globalThis.Jigra = (globalThis.Jigra || new JigraWeb());
})(
  // figure out the current globalThis, such as "window", "self" or "global"
  // ensure errors are not thrown in an node SSR environment or web worker
  typeof self !== 'undefined' ? self : typeof window !== 'undefined' ? window : typeof global !== 'undefined' ? global : {}
);


const Plugins = Jigra.Plugins;

export { Jigra, Plugins };
