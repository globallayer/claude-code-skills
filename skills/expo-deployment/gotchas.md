# Expo Deployment Gotchas

Common mistakes and pitfalls when deploying Expo apps.

---

## EAS Build

### 1. eas.json profile names matter

```json
{
  "build": {
    "development": { ... },  // eas build --profile development
    "preview": { ... },      // eas build --profile preview
    "production": { ... }    // eas build --profile production
  }
}
```

- Default profile is `production` if not specified
- `development` builds include dev client
- Profile names are case-sensitive

### 2. Build credentials are environment-specific

```bash
# iOS credentials stored per profile
eas credentials --platform ios

# Android keystore is shared across profiles by default
# Use different keystores for different apps!
```

### 3. Native code changes require new build

These changes CANNOT be deployed via OTA:
- Changes to `app.json`/`app.config.js` native settings
- Adding/removing native modules
- Updating Expo SDK version
- Changing iOS/Android permissions

---

## OTA Updates

### 4. Updates only work for JS/assets changes

```
CAN update via OTA:
✓ JavaScript code
✓ Images, fonts, assets
✓ app.json non-native fields (name, icon, splash)

CANNOT update via OTA (requires new build):
✗ Native modules
✗ iOS/Android permissions
✗ app.json native fields (bundleIdentifier, package)
✗ Expo SDK version
```

### 5. Runtime version must match

```json
// app.json
{
  "expo": {
    "runtimeVersion": {
      "policy": "sdkVersion"  // or "appVersion" or custom
    }
  }
}
```

- Updates only apply to builds with matching runtimeVersion
- Mismatched versions = update silently ignored
- Use `"policy": "appVersion"` for explicit control

### 6. Update channels for staged rollouts

```bash
# Publish to staging channel
eas update --branch staging --message "Test update"

# Point builds to channels in eas.json
"preview": {
  "channel": "staging"
}
```

---

## App Store Submission

### 7. iOS requires many assets

| Asset | Requirements |
|-------|--------------|
| App icon | 1024x1024 (no alpha/transparency!) |
| Screenshots | Multiple sizes per device |
| Privacy policy | URL required |
| Description | 4000 char max |

### 8. Android signing key is PERMANENT

```bash
# Lost keystore = cannot update app
# ALWAYS backup your keystore!
eas credentials --platform android
# Download and store securely
```

### 9. Apple review common rejections

| Rejection | Fix |
|-----------|-----|
| Crash on launch | Test on real device |
| Login required | Provide demo account |
| Incomplete metadata | Fill all fields |
| Guideline 4.2 | Add more functionality |

### 10. Google Play review delays

- First submission: 7+ days typical
- Updates: Usually 1-3 days
- Policy violations can suspend without warning

---

## Environment & Config

### 11. Environment variables in EAS

```bash
# Set secrets (not in source control)
eas secret:create --name API_KEY --value xxx

# Access in app.config.js
export default {
  extra: {
    apiKey: process.env.API_KEY
  }
}

# Access in code
import Constants from 'expo-constants';
Constants.expoConfig.extra.apiKey
```

### 12. app.json vs app.config.js

| File | Use Case |
|------|----------|
| `app.json` | Static values only |
| `app.config.js` | Dynamic values (env vars) |

- Can't mix both in same project
- Use `app.config.js` for any environment-based config

---

## Common Errors

### 13. "Standalone app is not signed correctly"

- iOS: Provisioning profile mismatch
- Fix: Run `eas credentials` and recreate

### 14. "Version code X has already been used"

- Android requires incrementing `versionCode` every build
- Fix: Auto-increment in eas.json:
```json
{
  "build": {
    "production": {
      "android": {
        "autoIncrement": true
      }
    }
  }
}
```

### 15. "Expo SDK version mismatch"

- Build was made with different SDK than update
- Fix: Rebuild app or match runtimeVersion

### 16. Assets not loading in production

- Check asset is in `assets` folder
- Verify `assetBundlePatterns` in app.json
- Test with `npx expo export` locally
