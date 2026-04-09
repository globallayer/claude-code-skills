---
name: expo-deployment
description: "Deploy Expo apps to production"
risk: safe
source: "https://github.com/expo/skills/tree/main/plugins/expo-deployment"
date_added: "2026-02-27"
---

# Expo Deployment

## Overview

Deploy Expo applications to production environments, including app stores and over-the-air updates.

## When to Use This Skill

Use this skill when you need to deploy Expo apps to production.

Use this skill when:
- Deploying Expo apps to production
- Publishing to app stores (iOS App Store, Google Play)
- Setting up over-the-air (OTA) updates
- Configuring production build settings
- Managing release channels and versions

## Instructions

This skill provides guidance for deploying Expo apps:

1. **Build Configuration**: Set up production build settings
2. **App Store Submission**: Prepare and submit to app stores
3. **OTA Updates**: Configure over-the-air update channels
4. **Release Management**: Manage versions and release channels
5. **Production Optimization**: Optimize apps for production

## Deployment Workflow

### Pre-Deployment

1. Ensure all tests pass
2. Update version numbers
3. Configure production environment variables
4. Review and optimize app bundle size
5. Test production builds locally

### App Store Deployment

1. Build production binaries (iOS/Android)
2. Configure app store metadata
3. Submit to App Store Connect / Google Play Console
4. Manage app store listings and screenshots
5. Handle app review process

### OTA Updates

1. Configure update channels (production, staging, etc.)
2. Build and publish updates
3. Manage rollout strategies
4. Monitor update adoption
5. Handle rollbacks if needed

## Best Practices

- Use EAS Build for reliable production builds
- Test production builds before submission
- Implement proper error tracking and analytics
- Use release channels for staged rollouts
- Keep app store metadata up to date
- Monitor app performance in production

## Gotchas

### EAS Build

1. **eas.json profile names matter**
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

2. **Build credentials are environment-specific**
   ```bash
   # iOS credentials stored per profile
   eas credentials --platform ios

   # Android keystore is shared across profiles by default
   # Use different keystores for different apps!
   ```

3. **Native code changes require new build**
   - Changes to `app.json`/`app.config.js` native settings
   - Adding/removing native modules
   - Updating Expo SDK version
   - OTA updates CANNOT change native code

### OTA Updates

4. **Updates only work for JS/assets changes**
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

5. **Runtime version must match**
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

6. **Update channels for staged rollouts**
   ```bash
   # Publish to staging channel
   eas update --branch staging --message "Test update"

   # Point builds to channels in eas.json
   "preview": {
     "channel": "staging"
   }
   ```

### App Store Submission

7. **iOS requires many assets**
   - App icon: 1024x1024 (no alpha/transparency!)
   - Screenshots: Multiple sizes per device
   - Privacy policy URL (required)
   - App Store description (4000 char max)

8. **Android signing key is PERMANENT**
   ```bash
   # Lost keystore = cannot update app
   # ALWAYS backup your keystore!
   eas credentials --platform android
   # Download and store securely
   ```

9. **Apple review common rejections**
   - Crash on launch (test on real device!)
   - Login required without demo account
   - Incomplete metadata
   - Guideline 4.2 - minimum functionality

10. **Google Play review delays**
    - First submission: 7+ days typical
    - Updates: Usually 1-3 days
    - Policy violations can suspend without warning

### Environment & Config

11. **Environment variables in EAS**
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

12. **app.json vs app.config.js**
    - Use `app.config.js` for dynamic values (env vars)
    - `app.json` is static only
    - Can't mix both in same project

### Common Errors

13. **"Standalone app is not signed correctly"**
    - iOS: Provisioning profile mismatch
    - Run `eas credentials` and recreate

14. **"Version code X has already been used"**
    - Android requires incrementing `versionCode` every build
    - Auto-increment: `"autoIncrement": true` in eas.json

15. **"Expo SDK version mismatch"**
    - Build was made with different SDK than update
    - Rebuild app or match runtimeVersion

16. **Assets not loading in production**
    - Check asset is in `assets` folder
    - Verify `assetBundlePatterns` in app.json
    - Test with `npx expo export` locally

## Resources

For more information, see the [source repository](https://github.com/expo/skills/tree/main/plugins/expo-deployment).
