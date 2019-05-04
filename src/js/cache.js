const { localStorage } = window;

const Workout = "workout"
const Exercises = "exercises"

export function getExercises() {
  return getItem(Exercises);
}

export function setExercises(exercises) {
  return setItem(Exercises, exercises);
}

export function setWorkout(workout) {
  return setItem(Workout, workout);
}

export function getWorkout() {
  return getItem(Workout);
}

export function removeWorkout() {
  return deleteItem(Workout);
}

// Utils

function getItem(key) {
  return safeParse(localStorage.getItem(key));
}

function setItem(key, item) {
  return typeof item !== "object"
    ? localStorage.setItem(key, item)
    : localStorage.setItem(key, JSON.stringify(item))
}

function deleteItem(key) {
  return localStorage.removeItem(key)
}

function safeParse(object) {
  try {
    return JSON.parse(object);
  } catch (e) {
    return null;
  }
}
