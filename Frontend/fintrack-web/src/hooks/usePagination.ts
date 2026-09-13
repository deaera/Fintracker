import { useMemo, useState } from "react";
import type { TablePaginationProps } from "@mui/material";

export function usePagination<T>(items: T[], initialRowsPerPage = 10) {
  const [page, setPage] = useState(0);
  const [rowsPerPage, setRowsPerPage] = useState(initialRowsPerPage);
  const [prevItems, setPrevItems] = useState(items);

  if (items !== prevItems) {
    setPrevItems(items);
    setPage(0);
  }

  const lastPage = Math.max(0, Math.ceil(items.length / rowsPerPage) - 1);
  const safePage = Math.min(page, lastPage);

  const slice = useMemo(
    () => items.slice(safePage * rowsPerPage, safePage * rowsPerPage + rowsPerPage),
    [items, safePage, rowsPerPage],
  );

  const paginationProps: TablePaginationProps = {
    component: "div",
    count: items.length,
    page: safePage,
    rowsPerPage,
    rowsPerPageOptions: [10, 25, 50, 100],
    onPageChange: (_event, newPage) => setPage(newPage),
    onRowsPerPageChange: (event) => {
      setRowsPerPage(parseInt(event.target.value, 10));
      setPage(0);
    },
  };

  return { slice, paginationProps, count: items.length, rowsPerPage };
}