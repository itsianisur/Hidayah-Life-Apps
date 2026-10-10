# Hidayah Life Download Page (Part C)

This folder contains the Next.js 14 (App Router) download landing page files for the main website (`hidayahlife.com/download`).

## Files Included

1. **`lib/app-download.ts`** (or `src/lib/app-download.ts`):
   - Centralized configuration containing GitHub repository owner (`GITHUB_OWNER`), repository name (`REPO_NAME`), current version (`1.0.0`), and stable latest download URLs.
2. **`app/[locale]/download/page.tsx`** (or `src/app/[locale]/download/page.tsx`):
   - Full Next.js client component with:
     - Hero section with title and Bangla pitch
     - 3 prominent OS download buttons (macOS, Windows, Android) with native inline SVG logos
     - Visitor OS auto-detection (`userAgent`) with visual "আপনার জন্য" highlight badge
     - iPhone PWA "Add to Home Screen" instructions info box
     - Step-by-step numbered install & security bypass guide for macOS Gatekeeper, Windows SmartScreen, and Android Unknown Apps
     - System requirements and killer feature highlight (Native Bangla prayer time alerts)
     - Bangla FAQ section
     - Deep emerald (`#041A13`, `#0B3D2E`) and gold (`#E8B85A`) luxury Islamic design system

## Deployment to Website Project
In your website project (`Hidayah Life`), these files are mapped to:
- `lib/app-download.ts` → `src/lib/app-download.ts`
- `app/[locale]/download/page.tsx` → `src/app/[locale]/download/page.tsx`
