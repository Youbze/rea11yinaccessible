import { get, type Writable } from "svelte/store";
import { writableSession } from "./PersistentStore";
import { onMount } from "svelte";


let countdownStore: Writable<string> | undefined = undefined
const formatter = new Intl.DateTimeFormat("en", {
  hour12: false,
  minute: "2-digit",
  second: "2-digit"
});

export const getCountdown = () => {
  if (countdownStore) {
    return Number(get(countdownStore))
  }
  return 0
}

export const getFormatedCountdown = (time: number) => {
  if (countdownStore) {
    return formatter.format(Number(get(countdownStore)))
  }
  return "00:00"
}

export const setCountdown = (value: number) => {
  if (countdownStore && value) {
    return countdownStore.set(value.toString())
  }
  return undefined
}

export const initCountdownStore = (countdown: number) => {
  countdownStore = writableSession("countdown", countdown.toString())
  return countdownStore
}
