import { Grid, Skeleton, Stack } from "@mui/material";

export default function LoadingSkeleton() {
  return (
    <Stack spacing={3}>
      <Skeleton variant="text" width={240} height={44} sx={{ mt: 1 }} />
      <Grid container spacing={2}>
        {Array.from({ length: 6 }).map((_, i) => (
          <Grid key={i} size={{ xs: 12, sm: 6, md: 2 }}>
            <Skeleton variant="rounded" height={126} />
          </Grid>
        ))}
      </Grid>
      <Grid container spacing={2}>
        <Grid size={{ xs: 12, md: 6 }}>
          <Skeleton variant="rounded" height={320} />
        </Grid>
        <Grid size={{ xs: 12, md: 6 }}>
          <Skeleton variant="rounded" height={320} />
        </Grid>
      </Grid>
      <Skeleton variant="rounded" height={220} />
    </Stack>
  );
}