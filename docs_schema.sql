-- Proposed relational schema equivalent for analytics/reporting or SQL backends.

CREATE TABLE Users (
  id TEXT PRIMARY KEY,
  display_name TEXT,
  age INTEGER,
  height_cm INTEGER,
  created_at TIMESTAMP
);

CREATE TABLE Phases (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  phase_name TEXT NOT NULL,
  started_at TIMESTAMP,
  completed_at TIMESTAMP,
  manual_confirmed BOOLEAN DEFAULT FALSE,
  FOREIGN KEY(user_id) REFERENCES Users(id)
);

CREATE TABLE DailyLogs (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  phase_id TEXT NOT NULL,
  log_date DATE NOT NULL,
  day_color TEXT NOT NULL,
  walking_minutes INTEGER DEFAULT 0,
  strength_done BOOLEAN DEFAULT FALSE,
  mobility_done BOOLEAN DEFAULT FALSE,
  protein_included BOOLEAN DEFAULT FALSE,
  junk_consumed BOOLEAN DEFAULT FALSE,
  sleep_hours REAL,
  mood TEXT,
  blood_pressure TEXT,
  FOREIGN KEY(user_id) REFERENCES Users(id),
  FOREIGN KEY(phase_id) REFERENCES Phases(id)
);

CREATE TABLE WeeklyScores (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  week_start DATE NOT NULL,
  score REAL NOT NULL,
  label TEXT NOT NULL,
  adaptive BOOLEAN DEFAULT FALSE,
  floor_violation BOOLEAN DEFAULT FALSE,
  ceiling_violation BOOLEAN DEFAULT FALSE,
  FOREIGN KEY(user_id) REFERENCES Users(id)
);

CREATE TABLE Credits (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  total_credits INTEGER DEFAULT 0,
  redeemed_credits INTEGER DEFAULT 0,
  total_kg_lost REAL DEFAULT 0,
  FOREIGN KEY(user_id) REFERENCES Users(id)
);

CREATE TABLE StreakData (
  user_id TEXT PRIMARY KEY,
  integrity_streak_weeks INTEGER DEFAULT 0,
  consecutive_correction_weeks INTEGER DEFAULT 0,
  FOREIGN KEY(user_id) REFERENCES Users(id)
);

CREATE TABLE Measurements (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  measured_at DATE NOT NULL,
  weight_kg REAL,
  waist_cm REAL,
  note TEXT,
  FOREIGN KEY(user_id) REFERENCES Users(id)
);

CREATE TABLE RewardsUnlocked (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  phase_name TEXT,
  reward_name TEXT,
  unlocked_at TIMESTAMP,
  redeemed_at TIMESTAMP,
  FOREIGN KEY(user_id) REFERENCES Users(id)
);
