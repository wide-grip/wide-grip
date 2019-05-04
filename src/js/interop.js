import * as cache from "./cache.js";

export function Interop(app) {
  const { ports } = app;

  function init() {
    subscribeRestoreWorkout();
    subscribeCacheWorkout();
    subscribeWorkoutInProgress();
  }

  function subscribeRestoreWorkout() {
    ports.restoreWorkoutFromCache.subscribe(() => {
      ports.receiveWorkoutFromCache.send(cache.getWorkout());
    });
  }

  function subscribeCacheWorkout() {
    ports.cacheWorkout.subscribe(workout => {
      cache.setWorkout(workout);
    });
  }

  function subscribeWorkoutInProgress() {
    ports.workoutInProgress.subscribe(() => {
      cache.getWorkout()
        ? ports.receiveWorkoutInProgress.send(true)
        : ports.receiveWorkoutInProgress.send(false);
    });
  }

  return { init };
}
