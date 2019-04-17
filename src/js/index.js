import * as cache from "./cache.js";
import { Interop } from "./interop.js";
const { Elm } = window;

const app = Elm.Main.init({
  flags: {
    now: Date.now(),
    exercises: cache.getExercises()
  }
});

const interop = Interop(app)
interop.init()
