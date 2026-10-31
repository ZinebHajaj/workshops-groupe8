# decode-uri-component remediation

- Date: 2026-10-31
- Owner: Ouzziki Lhoussaine
- Code commit: ab8c121
- Status: locally validated; integrated Dependency-Check verification pending.

## Finding and affected chain

The original chain was:

download@8.0.0 → got@8.3.2 → cacheable-request@2.1.4 → normalize-url@2.0.1 → query-string@5.1.1 → decode-uri-component@0.2.2

The original Dependency-Check report lists two advisories:

- GHSA-qr28-fpjm-wq7f / CVE-2026-118664: affected versions <=0.5.0; patched in 0.5.1.
- GHSA-vcc3-ghjq-m6fr / CVE-2026-45822: affected versions <=0.4.2; patched in 0.5.0.

## Remediation decision

A direct decode-uri-component@0.5.1 override was rejected. query-string@5.1.1 uses CommonJS require() and directly calls the imported value, while version 0.5.1 is ESM-only with a default export.

Instead, normalize-url was overridden to 3.3.0 only within cacheable-request@2.1.4. The existing basic-ftp@6.2.1 override remains unchanged.

The resolved chain now ends at normalize-url@3.3.0 overridden. query-string and decode-uri-component have been removed.

Exactly five lockfile entries changed: normalize-url was updated, while decode-uri-component, query-string, sort-keys, and strict-uri-encode were removed.

## Validation

- Clean root and frontend installations completed using the documented compatibility procedure.
- Actual local HTTP download and normalized cache reuse passed.
- Server utils tests: 55/55 passed, with no failures or skips.
- Server TypeScript and Angular production builds passed.
- Frontend SBOM generation passed.
- Both original decode-uri-component advisories are absent from the fresh npm audit.
- npm audit exited 1 because unrelated vulnerabilities remain.

Raw evidence is preserved under reports/critical-remediation/, including before/after chains, runtime results, tests, builds, audit JSON, installation logs, lockfile comparison, and focused diff.

## Limitations

This remediation does not claim a vulnerability-free project, overall vulnerability reduction, green CI, or a successful post-change Dependency-Check gate.

The pre-existing frontend Stylelint peer conflict remains separate. No suppression, continue-on-error, or change to --failOnCVSS 9 was introduced.

A new integrated Workshop3 run must provide the Dependency-Check artifact required to establish the honest post-change gate status. Other vulnerable packages remain separate decisions.
