# Creme - Angular Project Folder Structure

## Current Structure (Professional Angular Naming)

```
src/
├── app/                          # Main application folder
│   ├── core/                     # Core module - singletons, services, guards
│   ├── shared/                   # Shared components, directives, pipes
│   ├── features/                 # Feature modules (lazy-loaded)
│   │   └── home/                 # Home feature
│   ├── assets/                   # ⚠️ TEMPORARY - Move to src/assets/
│   │   └── fonts/                # Font files (move to src/assets/fonts/)
│   ├── app.config.ts
│   ├── app.html
│   ├── app.routes.ts
│   ├── app.scss
│   └── app.ts
├── assets/                       # ✅ CORRECT LOCATION for static assets
│   ├── fonts/                    # Font files (WOFF2)
│   │   ├── LibreBaskerville-Regular.woff2
│   │   ├── LibreBaskerville-Medium.woff2
│   │   └── LibreBaskerville-Bold.woff2
│   └── images/                   # Images
│       └── creme-placeholder.jpg
├── core/                         # Core utilities (if needed at root)
├── shared/                        # Shared utilities (if needed at root)
├── styles.scss                   # Global styles
├── index.html
└── main.ts
```

## Action Required

**Move fonts from:** `src/app/assets/fonts/`  
**To:** `src/assets/fonts/`

The fonts are currently in the wrong location. They should be at `src/assets/fonts/` (not inside `app/` folder).

## Future Structure (When Adding Transloco)

```
src/
├── app/
│   ├── core/
│   │   ├── guards/
│   │   ├── interceptors/
│   │   └── services/
│   ├── shared/
│   │   ├── components/
│   │   ├── directives/
│   │   └── pipes/
│   └── features/
│       ├── home/
│       └── [other-features]/
├── assets/
│   ├── fonts/
│   ├── images/
│   └── i18n/                    # Transloco translation files
│       ├── en.json
│       └── ka.json              # Georgian translations (future)
└── ...
```

## Notes

- **Core**: Singletons, services used app-wide (auth, API, etc.)
- **Shared**: Reusable components, directives, pipes
- **Features**: Feature modules (home, products, etc.) - can be lazy-loaded
- **Assets**: Static files (fonts, images, i18n files)



