import { useCallback, useEffect, useReducer, useRef, useState } from "react";

interface ApiState<T> {
  data: T | null;
  loading: boolean;
  error: boolean;
}

type ApiAction<T> =
  | { type: "start" }
  | { type: "done"; data: T }
  | { type: "fail" };

function apiReducer<T>(state: ApiState<T>, action: ApiAction<T>): ApiState<T> {
  switch (action.type) {
    case "start":
      return { ...state, loading: true, error: false };
    case "done":
      return { data: action.data, loading: false, error: false };
    case "fail":
      return { ...state, loading: false, error: true };
  }
}

export function useApiData<T>(fetcher: () => Promise<T>, refreshKey: unknown) {
  const [state, dispatch] = useReducer(apiReducer<T>, {
    data: null,
    loading: true,
    error: false,
  });
  const fetcherRef = useRef(fetcher);

  useEffect(() => {
    fetcherRef.current = fetcher;
  });

  const [reloadCount, setReloadCount] = useState(0);
  const reload = useCallback(() => setReloadCount((count) => count + 1), []);

  useEffect(() => {
    let active = true;
    dispatch({ type: "start" });
    fetcherRef
      .current()
      .then((data) => {
        if (active) dispatch({ type: "done", data });
      })
      .catch(() => {
        if (active) dispatch({ type: "fail" });
      });
    return () => {
      active = false;
    };
  }, [refreshKey, reloadCount]);

  return { ...state, reload };
}