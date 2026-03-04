# Local Signing Configuration Setup

This guide explains how to set up your local development environment to work with the project without causing signing conflicts when pushing to the repository.

---

## Problem This Solves

When multiple developers work on the same Xcode project, each person has different:
- **Development Team ID** (Apple Developer account)
- **Provisioning profiles**
- **Code signing settings**

These settings get saved in `project.pbxproj` and cause merge conflicts every time someone pushes.

---

## Quick Setup (TL;DR)

```bash
# 1. Pull the branch
git fetch origin
git checkout feature/local-signing-config

# 2. Create your local config
cp Config/Local.xcconfig.template Config/Local.xcconfig

# 3. Edit Config/Local.xcconfig with your Team ID
# DEVELOPMENT_TEAM = YOUR_TEAM_ID_HERE

# 4. Tell git to ignore your local signing changes
git update-index --skip-worktree adeste.xcodeproj/project.pbxproj
git update-index --skip-worktree adeste.entitlements
git update-index --skip-worktree ActivityReport/ActivityReport.entitlements
git update-index --skip-worktree DeviceActivityMonitor/DeviceActivityMonitor.entitlements

# 5. Open Xcode and build!
```

---

## Detailed Step-by-Step Instructions

### Step 1: Pull the Test Branch

```bash
cd /path/to/adeste
git fetch origin
git checkout feature/local-signing-config
```

### Step 2: Create Your Local Configuration File

The `Local.xcconfig` file contains YOUR personal signing settings. It's gitignored, so it won't be pushed.

```bash
cp Config/Local.xcconfig.template Config/Local.xcconfig
```

### Step 3: Find Your Development Team ID

Your Team ID is a 10-character alphanumeric string (e.g., `ABC123DEF0`).

**Option A: From Apple Developer Portal**
1. Go to https://developer.apple.com/account
2. Click "Membership" in the sidebar
3. Find "Team ID"

**Option B: From Xcode**
1. Open Xcode → Settings (⌘,)
2. Go to "Accounts" tab
3. Select your Apple ID
4. Look at the Team ID in the team list

**Option C: From Terminal**
```bash
# If you have profiles installed:
security find-identity -v -p codesigning | head -5
# The Team ID is in parentheses, e.g., "Apple Development: Name (TEAM_ID)"
```

### Step 4: Edit Your Local Config

Open `Config/Local.xcconfig` and replace `YOUR_TEAM_ID_HERE` with your actual Team ID:

```xcconfig
DEVELOPMENT_TEAM = ABC123DEF0
CODE_SIGN_STYLE = Automatic
```

### Step 5: Configure Git to Ignore Local Changes

This is the key step. Run these commands to tell Git to ignore your local changes to signing-related files:

```bash
# Ignore project.pbxproj changes
git update-index --skip-worktree adeste.xcodeproj/project.pbxproj

# Ignore entitlements changes
git update-index --skip-worktree adeste.entitlements
git update-index --skip-worktree ActivityReport/ActivityReport.entitlements
git update-index --skip-worktree DeviceActivityMonitor/DeviceActivityMonitor.entitlements
```

### Step 6: Verify Skip-Worktree is Set

```bash
git ls-files -v | grep ^S
```

You should see output like:
```
S adeste.entitlements
S ActivityReport/ActivityReport.entitlements
S DeviceActivityMonitor/DeviceActivityMonitor.entitlements
S adeste.xcodeproj/project.pbxproj
```

The `S` prefix means skip-worktree is enabled.

### Step 7: Open Xcode and Build

```bash
open adeste.xcodeproj
```

1. Select your target
2. Go to "Signing & Capabilities"
3. Xcode should automatically use your Team ID from the xcconfig
4. Build the project (⌘B)

---

## Troubleshooting

### "No signing certificate found" or "No profile for team"

Make sure:
1. Your `DEVELOPMENT_TEAM` in `Local.xcconfig` is correct
2. You're signed into Xcode with the matching Apple ID
3. You have valid certificates: Xcode → Settings → Accounts → Manage Certificates

### Xcode still shows wrong Team ID

The xcconfig values may be overridden in Xcode's UI. In Xcode:
1. Select the target
2. Go to Build Settings
3. Search for "DEVELOPMENT_TEAM"
4. If it shows your Team ID with a green config icon, it's coming from xcconfig ✓
5. If it's hardcoded (no icon), delete the value so xcconfig takes precedence

### Git says files are modified after skip-worktree

If you accidentally staged files before skip-worktree:
```bash
git reset HEAD adeste.xcodeproj/project.pbxproj
git checkout -- adeste.xcodeproj/project.pbxproj
git update-index --skip-worktree adeste.xcodeproj/project.pbxproj
```

### Need to commit legitimate changes to project.pbxproj

If you need to add a new file or change project structure:
```bash
# Temporarily disable skip-worktree
git update-index --no-skip-worktree adeste.xcodeproj/project.pbxproj

# Make your changes, then commit ONLY the structural changes
# Be careful not to commit signing settings

# Re-enable skip-worktree
git update-index --skip-worktree adeste.xcodeproj/project.pbxproj
```

---

## How It Works

### File Structure
```
Config/
├── Local.xcconfig           # YOUR settings (gitignored)
├── Local.xcconfig.template  # Template to copy (committed)
└── README.md                # This file

levelUp/Config/
├── DebugLocal.xcconfig      # Includes ../../Config/Local.xcconfig
├── DebugTeam.xcconfig       # Includes ../../Config/Local.xcconfig
└── Release.xcconfig         # Includes ../../Config/Local.xcconfig

ActivityReport/Config/
└── (same pattern)

DeviceActivityMonitor/Config/
└── (same pattern)
```

### The Include Chain
```
Target Build Settings
    ↓ reads from
DebugTeam.xcconfig (or Release, etc.)
    ↓ includes
Config/Local.xcconfig (your personal settings)
    ↓ provides
DEVELOPMENT_TEAM = YOUR_TEAM_ID
CODE_SIGN_STYLE = Automatic
```

---

## For Future Team Members

When someone new joins the project:

1. Clone the repository
2. Follow Steps 2-6 above
3. Never commit `Config/Local.xcconfig`
4. Always set skip-worktree on signing files

---

## One-Liner Setup Script

Save time by running this after cloning:

```bash
cd /path/to/adeste && \
cp Config/Local.xcconfig.template Config/Local.xcconfig && \
echo "DEVELOPMENT_TEAM = PASTE_YOUR_TEAM_ID_HERE" && \
echo "Edit Config/Local.xcconfig with your Team ID, then run:" && \
echo 'git update-index --skip-worktree adeste.xcodeproj/project.pbxproj adeste.entitlements ActivityReport/ActivityReport.entitlements DeviceActivityMonitor/DeviceActivityMonitor.entitlements'
```

---

## Questions?

If you run into issues, check:
1. Is `Local.xcconfig` created with your Team ID?
2. Is skip-worktree set? (`git ls-files -v | grep ^S`)
3. Are you signed into Xcode with the correct Apple ID?
