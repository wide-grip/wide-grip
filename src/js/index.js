import * as cache from "./cache.js";
import { Interop } from "./interop.js";
import { exercises } from "../../exercises.json";
const { Elm } = window;

cache.setExercises(exercises)

const app = Elm.Main.init({
  flags: {
    now: Date.now(),
    exercises: cache.getExercises()
  }
});

const interop = Interop(app);
interop.init();
