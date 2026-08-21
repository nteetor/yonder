// Client-side checks run before a batch starts. Two purposes: fail fast,
// so a doomed batch costs no round trip, and cover the paths where files
// arrive without the picker's filtering — drag-drop and paste bypass
// `accept` and `multiple` entirely. Not security: the server re-enforces
// the size limit on every upload regardless.
//
// Pure functions over File metadata, so they are testable without a DOM.

// 'multiple' and 'count' are gesture-level — a multi-file gesture on a
// single-file input, a gesture past the file-count cap — recorded by
// the component against every file in the gesture so the failure
// record stays per-file.
type RejectReason =
  | { kind: 'size'; limit: number }
  | { kind: 'accept' }
  | { kind: 'directory' }
  | { kind: 'multiple' }
  | { kind: 'count'; limit: number };

interface Rejection {
  name: string;
  reason: RejectReason;
}

interface Validation {
  accepted: File[];
  rejected: Rejection[];
}

interface ValidateOptions {
  // The `accept` attribute verbatim; an empty string accepts anything.
  accept: string;
  // The render-time mirror of shiny.maxRequestSize, or null when unknown.
  maxSize: number | null;
}

// Does a file satisfy one `accept` token? Three token forms, per the HTML
// spec: an extension (".csv"), a MIME wildcard ("image/*"), or an exact
// MIME type ("text/csv").
function matchesToken(file: File, token: string): boolean {
  const type = file.type.toLowerCase();

  if (token.startsWith('.')) {
    return file.name.toLowerCase().endsWith(token);
  }

  // File.type is extension-sniffed by the browser and is often empty
  // (.parquet, .rds, …). Nothing MIME-shaped can match a blank type, so
  // such files rely on an extension token being present.
  if (type === '') {
    return false;
  }

  if (token.endsWith('/*')) {
    return type.startsWith(token.slice(0, -1));
  }

  return type === token;
}

function isAccepted(file: File, accept: string): boolean {
  const tokens = accept
    .split(',')
    .map((token) => token.trim().toLowerCase())
    .filter((token) => token !== '');

  if (tokens.length === 0) {
    return true;
  }

  return tokens.some((token) => matchesToken(file, token));
}

// Per-file checks. Batch-level rules (`multiple`, dropped directories)
// depend on how the files arrived and are enforced by the component.
function validateFiles(files: File[], options: ValidateOptions): Validation {
  const accepted: File[] = [];
  const rejected: Rejection[] = [];

  for (const file of files) {
    if (options.maxSize !== null && file.size > options.maxSize) {
      // The server rejects the whole batch when any one file is oversize,
      // so naming the file beats waiting for the generic batch error.
      rejected.push({
        name: file.name,
        reason: { kind: 'size', limit: options.maxSize },
      });
      continue;
    }

    if (!isAccepted(file, options.accept)) {
      rejected.push({ name: file.name, reason: { kind: 'accept' } });
      continue;
    }

    accepted.push(file);
  }

  return { accepted, rejected };
}

export { isAccepted, validateFiles };
export type { Rejection, RejectReason, Validation, ValidateOptions };
