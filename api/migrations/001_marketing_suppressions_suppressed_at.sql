-- Make marketing suppressions time-aware.
--
-- Before: a guest consent with a suppressed address deleted the suppression row,
-- lifting the opt-out for that address in every account, on a self-asserted email.
-- After: the row is never deleted on consent. suppressed_at (the latest unsubscribe,
-- refreshed on every unsubscribe) withdraws every consent recorded at or before it;
-- a consent recorded later counts for its own guest row only.
--
-- Existing rows get suppressed_at = the migration time (now() is evaluated once for
-- the ALTER). Every existing consent predates it, so every guest that is suppressed
-- today stays suppressed.
ALTER TABLE marketing_suppressions
    ADD COLUMN suppressed_at TIMESTAMPTZ NOT NULL DEFAULT now();
