DROP TABLE IF EXISTS reading_progress;
CREATE TABLE reading_progress (
  book_id TEXT PRIMARY KEY,
  chapter_index INTEGER NOT NULL,
  cfi TEXT, 
  anchor_text TEXT,
  percentage REAL,
  device_id TEXT,
  updated_at INTEGER NOT NULL
);

DROP TABLE IF EXISTS books;
CREATE TABLE books (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  cover_url TEXT,
  file_key TEXT NOT NULL,
  file_size INTEGER,
  format TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL
);

CREATE INDEX idx_progress_updated ON reading_progress(updated_at);
CREATE INDEX idx_books_updated ON books(updated_at);







