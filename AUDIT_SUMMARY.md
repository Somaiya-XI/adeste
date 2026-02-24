# Level UP – Global Project Audit Summary

**Date:** Audit performed across the full codebase.  
**Goal:** Professional, efficient codebase ready for App Store submission.

---

## 1. Dead Code & Redundancy

### 1.1 Ghost / Deprecated Files (no longer used)
These files contain only a single deprecation comment and are not referenced anywhere. They are still compiled (project uses file system sync). Consider removing or keeping as documentation.

| File | Status |
|------|--------|
| `Views/Components/HabitsCompomnent/Cards/WakeUpHabitCardView.swift` | Comment only |
| `Views/Components/HabitsCompomnent/Cards/StepsHabitCardView.swift` | Comment only |
| `Views/Components/HabitsCompomnent/Cards/WaterHabitCardView.swift` | Comment only |
| `Views/Components/HabitsCompomnent/Cards/PrayerHabitCardView.swift` | Comment only |
| `Views/Components/HabitsCompomnent/Cards/AthkarHabitCardView.swift` | Comment only |
| `Views/Components/HabitsCompomnent/Cards/HabitCardView.swift` | Comment only |
| `Views/Components/HabitsCompomnent/Layout/HabitCardLayout.swift` | Comment only |
| `Views/Components/HabitsCompomnent/Layout/HabitLayoutItem.swift` | Not read; likely same |

**Recommendation:** Either delete these files (and exclude from build if needed) or leave as one-line signposts. No references to these types exist in the codebase.

### 1.2 Debug `print` Statements (should be removed or guarded for production)
| File | Line(s) | Usage |
|------|---------|--------|
| `Services/NotificationManager.swift` | 21, 24, 27, 55, 57, 112, 114 | Errors and success logs |
| `Services/NotificationDelegate.swift` | 22, 50, 54 | Intentions logging |
| `ViewModels/HomeViewModel.swift` | 44 | Health error |
| `Tests/NotificationTesting.swift` | 30, 48 | Test/debug |
| `Tests/IntentionTesting.swift` | 48 | Test/debug |

**Recommendation:** Remove or wrap in `#if DEBUG` in production code (NotificationManager, NotificationDelegate, HomeViewModel). Leave or remove in Test views as desired.

### 1.3 Commented-Out / Leftover Code
- **HomeView.swift:** Duplicate `import SwiftUI` (lines 8 and 11). Empty `.onAppear { }` block (no-op).
- **IntentionsView.swift:** Comment block at top: `// selectedIntentionIcon -> currentIntention`, `// currentIntentionsCount -> minimumIntentions` (refactor notes – safe to remove).
- **IntentionsView.swift:** Minor formatting: `}        }` in `addMoreButton` (line 227) – double space before closing brace.

---

## 2. UI/UX Consistency (16px Rule & Spacing)

### 2.1 Cards – Inner Padding ✅
All habit cards already use **`.padding(16)`** on the main content `VStack`:
- `SmallHabitCard`, `WideHabitCard`, `WaterIntakeCard`, `HabitProgressCard` – **OK.**

### 2.2 Custom Frame Extensions
- **SmallHabitCard:** uses `.smallHabitFrame()` ✅  
- **WideHabitCard:** uses `.wideHabitFrame()` ✅  
- **WaterIntakeCard:** uses `.waterCardFrame()` ✅  
- **HabitProgressCard:** uses **hardcoded** `.frame(width: 345, height: 243)` in three places. No extension in `View+Frames.swift`.

**Recommendation:** Add `habitProgressCardFrame()` (345×243) in `View+Frames.swift` and use it in `HabitProgressCard` for consistency.

### 2.3 Section Spacing
- **HomeView:** `VStack(spacing: 24)` and `.padding(.horizontal)` (no explicit 16). Section spacing 24px is within 24–32px range ✅. Consider `.padding(.horizontal, 16)` for consistent edge padding.
- **IntentionsView:** Header uses `.padding(.top, 8)` and `.padding(.bottom, 20)`; card uses `.padding(.horizontal, 16)` and `.padding(.vertical, 12)`; summary uses `.padding(.top, 28)` and `.padding(.bottom, 16)`. Mixed; consider standardizing to 16px where appropriate.
- **ProfileView:** `.padding(.horizontal, 16)` ✅; section spacing via `Spacer().frame(height: …)` (20, 36, 16, 36, 16, 32).
- **AppLimitCardView:** Overlay content has **no inner padding**; text may touch edges. Recommend adding `.padding(16)` to the overlay `VStack`.
- **MapSectionView:** Same – overlay has no padding. Recommend `.padding(16)` for overlay content.
- **StreakView:** No inner padding; small view. Optional: add padding if design specifies.

### 2.4 Small Device (e.g. iPhone SE)
- **HomeView** has no `ScrollView`; content is `VStack` + `Spacer()`. On short screens, sections could be squeezed. Consider wrapping in `ScrollView` for small devices or using `ScrollView` always for safety.
- Habit cards use fixed heights from extensions; TabView height 260 is fixed. No overlap identified, but worth testing on SE.

---

## 3. SwiftUI Best Practices

### 3.1 State Management
- **HomeView:** `@StateObject private var viewModel = HomeViewModel()` and `init(previewPages:)` sets `_viewModel = StateObject(wrappedValue: vm)`. If `previewPages != nil`, a second `HomeViewModel()` is created in the init and not used (only `vm` is used for the StateObject). The line `@StateObject private var viewModel = HomeViewModel()` is the actual stored instance; the one created in init when passing preview data is used only to set `vm.pages` and then wrapped in StateObject. So the preview path does work, but the pattern is a bit confusing (two view models exist in preview case). Consider clarifying or using a single source of truth.
- **IntentionsView:** `@State var vm: IntentionsViewModel` – consider `@StateObject` if the VM is a reference type and should be owned by the view.
- **SmallHabitCard / WideHabitCard / HabitProgressCard:** Stateless; no issues.

### 3.2 Heavy Views
- **IntentionsView:** Large body (GeometryReader, ZStack, multiple branches). Could extract: header toolbar, timer card, intentions grid card, summary section into separate subviews.
- **ProfileView:** Moderate; already uses `settingsRow` and `customDivider`. Fine as is.
- **StartCycle:** Multiple frames and logic; could be split into subviews if it grows.

### 3.3 Card Logic (Swifty & Clean)
- **SmallHabitCard:** Clear; handles system vs asset icon. ✅  
- **WideHabitCard:** Simple; no redundant state. ✅  
- **HabitProgressCard:** Good structure; mock data in one place. Asset name is `"ic_stepsprogress"` (different from `"ic_steps"`) – intentional for chart icon. ✅  

---

## 4. “Stupid Mistake” Check

### 4.1 Hardcoded Strings (should be constants or localized)
- **HabitsSectionView:** `"Daily habit"`, `"Wake up"`, `"Exercise"`, `"Praying"`, `"Athkar"`, `"7:45"`, `"PM"`, `"9,565"`, `"Steps"`, `"FJR"`, `"MORNING"` – consider moving to `Constants.swift` or `Localizable.xcstrings`.
- **WaterIntakeCard:** `"Water intake"` – same.
- **HabitProgressCard:** `"Habit progress"` – same.
- **AppLimitCardView:** `"Usage Card"`, `"Screen time / limits"`.
- **MapSectionView:** `"Character / Time"`.
- **StreakView:** `"Streak"`.
- **Constants** already has `consts.fajrStr = "FJR"` etc.; Praying card uses `"FJR"` and `"MORNING"` directly instead of constants.

### 4.2 Alignment / Overlap
- No obvious overlap found. Habit cards use fixed widths (168, 345) and are in padded HStack/VStack. Recommend manual test on iPhone SE for Home and Intentions.

### 4.3 `ic_steps` and `isSystemIcon`
- **HabitsSectionView:** Exercise card uses `iconName: "ic_steps"` and **`isSystemIcon: false`** ✅  
- **SmallHabitCard Preview “Exercise Card”:** Uses `iconName: "ic_steps"` and **`isSystemIcon: false`** ✅  
- **HabitProgressCard:** Uses asset **`"ic_stepsprogress"`** for the chart (different asset) – correct.

No incorrect `isSystemIcon: true` with `ic_steps` found.

### 4.4 Other
- **Typo in folder name:** `HabitsCompomnent` → should be `HabitsComponent` (cosmetic; renaming can break references).
- **Typo in folder name:** `Extentions` → `Extensions` (same note).
- **IntentionsView** `addMoreButton`: `let listOfIcons = ["target"]` – only one icon; `randomElement()!` always returns `"target"`. Consider constant or expanding list.

---

## Summary Table

| Category | Issue | Severity | Action |
|----------|--------|----------|--------|
| Dead code | 6–8 deprecated single-line Swift files | Low | Delete or keep as docs |
| Debug | print() in NotificationManager, NotificationDelegate, HomeViewModel | Medium | Remove or #if DEBUG |
| Debug | print() in Test views | Low | Optional remove |
| Redundancy | Duplicate import + empty onAppear in HomeView | Low | Remove |
| Redundancy | Comment refactor notes in IntentionsView | Low | Remove |
| Redundancy | "}        }" formatting in IntentionsView | Low | Fix |
| UI | HabitProgressCard hardcoded 345×243 | Low | Add frame extension |
| UI | AppLimitCardView / MapSectionView no inner padding | Medium | Add .padding(16) |
| UI | HomeView no ScrollView on small devices | Medium | Consider ScrollView |
| UI | HomeView .padding(.horizontal) not explicit 16 | Low | Optional .padding(.horizontal, 16) |
| Strings | Many hardcoded labels in cards/sections | Low | Constants or Localizable |
| Strings | FJR/MORNING not using consts | Low | Use consts.fajrStr etc. |
| State | IntentionsView @State vm – consider @StateObject | Low | Verify VM type |
| State | HomeView preview VM init pattern | Low | Clarify if desired |

---

**Next step:** Say which fixes you want applied (e.g. “apply all”, “only high/medium”, or list by category), and they can be implemented in the codebase.
