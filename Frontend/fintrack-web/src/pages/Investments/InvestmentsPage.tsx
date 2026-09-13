import { useState } from "react";
import { Box, Tab, Tabs, Typography } from "@mui/material";
import OverviewTab from "./OverviewTab";
import HoldingsTab from "./HoldingsTab";
import TransactionsTab from "./TransactionsTab";
import DividendsTab from "./DividendsTab";
import AccountsTab from "./AccountsTab";

export default function InvestmentsPage() {
  const [tab, setTab] = useState(0);

  return (
    <Box sx={{ width: "100%" }}>
      <Box
        sx={{
          display: "flex",
          justifyContent: "space-between",
          alignItems: "center",
          flexWrap: "wrap",
          gap: 2,
          mb: 2,
        }}
      >
        <Box>
          <Typography variant="h5" sx={{ fontWeight: 700 }}>
            Investments
          </Typography>
          <Typography variant="body2" color="text.secondary">
            Holdings, portfolio performance and broker accounts
          </Typography>
        </Box>
      </Box>

      <Tabs
        value={tab}
        onChange={(_, value) => setTab(value)}
        sx={{
          mb: 3,
          borderBottom: 1,
          borderColor: "divider",
          "& .MuiTab-root": { minWidth: 110 },
        }}
      >
        <Tab label="Overview" />
        <Tab label="Holdings" />
        <Tab label="Transactions" />
        <Tab label="Dividends" />
        <Tab label="Accounts" />
      </Tabs>

      {tab === 0 && <OverviewTab />}
      {tab === 1 && <HoldingsTab />}
      {tab === 2 && <TransactionsTab />}
      {tab === 3 && <DividendsTab />}
      {tab === 4 && <AccountsTab />}
    </Box>
  );
}