# Typography Audit Report — Level UP

**Generated:** Full project scan  
**Existing extensions** (from `SwiftUI+Font.swift`):  
`s48Heavy` | `s32Medium` (32, **bold**) | `s28Medium` | `s24Medium` | `s20Medium` | `s18Medium` | `s16Medium` | `s12Medium` | `s12Light`

---

## 1. Hardcoded vs. Extensions

All uses of `.font(.system(...))` that could be replaced by extensions or where extensions are missing.

| File | Line | Current Code | Suggested Extension |
|------|------|--------------|---------------------|
| **SmallHabitCard.swift** | 49 | `.font(.system(size: 12, weight: .medium))` | `.s12Medium` |
| **SmallHabitCard.swift** | 54 | `.font(.system(size: 32, weight: .medium))` | ⚠️ No match — `s32Medium` is **bold**; consider adding `s32MediumPlain` or `s32Regular` |
| **SmallHabitCard.swift** | 59 | `.font(.system(size: 12, weight: .light))` | `.s12Light` |
| **SmallHabitCard.swift** | 73 | `.font(.system(size: 80))` | *(Icon size — special case)* |
| **HabitsSectionView.swift** | 15 | `.font(.system(size: 32, weight: .medium))` | ⚠️ Same as above — `s32Medium` is bold |
| **WaterIntakeCard.swift** | 30 | `.font(.system(size: 32))` | ⚠️ 32 regular — no extension; `s32Medium` is bold |
| **ManageIntentionsView.swift** | 37 | `.font(.system(size: 24, weight: .semibold, design: .rounded))` | ⚠️ Similar — `.s24Medium` (24 medium); consider `s24Semibold` |
| **ManageIntentionsView.swift** | 51 | `.font(.system(size: 16, weight: .semibold, design: .rounded))` | ⚠️ Similar — `.s16Medium` (16 medium); consider `s16Semibold` |
| **ManageIntentionsView.swift** | 153 | `.font(.system(size: 20, weight: .semibold))` | ⚠️ Similar — `.s20Medium` (20 medium); consider `s20Semibold` |
| **ProfileView.swift** | 41 | `.font(.system(size: 14))` | ❌ No extension for 14pt |
| **PickHabit .swift** | 31 | `.font(.system(size: 40, weight: .bold))` | ❌ No extension for 40pt bold |
| **PickHabit .swift** | 42 | `.font(.system(size: 17))` | ❌ No extension for 17pt |
| **PickHabit .swift** | 119 | `.font(.system(size: 28, weight: .semibold))` | ⚠️ Similar — `.s28Medium` (28 medium); consider `s28Semibold` |
| **PickHabit .swift** | 165 | `.font(.system(size: 70))` | *(Large display — special case)* |
| **PickHabit .swift** | 169 | `.font(.system(size: 29, weight: .regular))` | ❌ No extension for 29pt |
| **PickHabit .swift** | 193 | `.font(.system(size: iconSize))` | *(Dynamic — special case)* |
| **PickHabit .swift** | 204 | `.font(.system(size: 65))` | *(Large display — special case)* |
| **PickHabit .swift** | 207 | `.font(.system(size: 65))` | *(Large display — special case)* |
| **PickHabit .swift** | 215 | `.font(.system(size: 28, weight: .regular))` | ⚠️ Similar — `.s28Medium` (28 medium); consider `s28Regular` |
| **IntentionsView.swift** | 112 | `.font(.system(size: 28, weight: .medium, design: .rounded))` | `.s28Medium` |
| **IntentionsSymbolPicker.swift** | 30 | `.font(.system(size: 16, weight: .medium))` | `.s16Medium` |
| **StartCycle.swift** | 30 | `.font(.system(size: 14))` | ❌ No extension for 14pt |
| **StartCycle.swift** | 124 | `.font(.system(size: 28, weight: .bold))` | ❌ No extension for 28pt bold |
| **StartCycle.swift** | 137 | `.font(.system(size: 13, weight: .semibold))` | ❌ No extension for 13pt |
| **StartCycle.swift** | 141 | `.font(.system(size: 13))` | ❌ No extension for 13pt |
| **StartCycle.swift** | 150 | `.font(.system(size: 26, weight: .bold))` | ❌ No extension for 26pt bold |
| **StartCycle.swift** | 179 | `.font(.system(size: 18, weight: .semibold))` | ⚠️ Similar — `.s18Medium` (18 medium); consider `s18Semibold` |
| **StartCycle.swift** | 209 | `.font(.system(size: 20, weight: .medium))` | `.s20Medium` |
| **StartCycle.swift** | 214 | `.font(.system(size: 18, weight: .medium))` | `.s18Medium` |
| **IntentionSummaryChart.swift** | 31 | `.font(.system(size: w * 0.28))` | *(Dynamic — special case)* |
| **SymbolView.swift** | 38 | `.font(.system(size: 16, weight: .medium))` | `.s16Medium` |
| **SymbolView.swift** | 42 | `.font(.system(size: 16, weight: .medium, design: .rounded))` | `.s16Medium` |
| **SymbolView.swift** | 52 | `.font(.system(size: 18, weight: .medium))` | `.s18Medium` |
| **SymbolView.swift** | 75 | `.font(.system(size: 22, weight: .medium))` | ❌ No extension for 22pt medium |
| **TabBar.swift** | 68 | `.font(.system(size: 20, weight: .semibold))` | ⚠️ Similar — `.s20Medium`; consider `s20Semibold` |
| **TabBar.swift** | 71 | `.font(.system(size: 10, weight: .medium))` | ❌ No extension for 10pt medium |
| **Buttons.swift** | 17 | `.font(.system(size: 16, weight: .semibold, design: .rounded))` | ⚠️ Similar — `.s16Medium`; consider `s16Semibold` |
| **AchievementsView.swift** | 24 | `.font(.system(size: 24, weight: .semibold, design: .rounded))` | ⚠️ Similar — `.s24Medium`; consider `s24Semibold` |

---

## 2. Missing / Frequent Styles (Used 3+ Times Without Extension)

| Font Style | Usage Count | Files | Suggestion |
|------------|-------------|-------|------------|
| **16pt medium** | 3 | IntentionsSymbolPicker, SymbolView (×2) | Use existing `.s16Medium` |
| **18pt medium** | 2 | StartCycle, SymbolView | Use existing `.s18Medium` |
| **20pt semibold** | 2 | ManageIntentionsView, TabBar | Consider adding `s20Semibold` |
| **16pt semibold** | 2 | ManageIntentionsView, Buttons | Consider adding `s16Semibold` |
| **24pt semibold** | 2 | ManageIntentionsView, AchievementsView | Consider adding `s24Semibold` |
| **14pt (regular)** | 2 | ProfileView, StartCycle | Consider adding `s14Regular` or `s14Medium` |
| **32pt medium** | 2 | SmallHabitCard, HabitsSectionView | ⚠️ `s32Medium` is bold; consider adding `s32Regular` or renaming |
| **28pt medium** | 1 | IntentionsView | Use existing `.s28Medium` |
| **20pt medium** | 1 | StartCycle | Use existing `.s20Medium` |

No single style appears 3+ times without an extension. Most repeated combinations are size 16/18/20/24 in semibold or medium.

---

## 3. Similarity Check (Optimization)

Hardcoded fonts that are close to existing extensions and could be unified:

| Current Hardcoded | Existing Extension | Recommendation |
|-------------------|--------------------|----------------|
| `size: 12, weight: .medium` | `.s12Medium` | **Replace** |
| `size: 12, weight: .light` | `.s12Light` | **Replace** |
| `size: 16, weight: .medium` | `.s16Medium` | **Replace** (3 instances) |
| `size: 18, weight: .medium` | `.s18Medium` | **Replace** (2 instances) |
| `size: 20, weight: .medium` | `.s20Medium` | **Replace** (1 instance) |
| `size: 28, weight: .medium, design: .rounded` | `.s28Medium` | **Replace** (1 instance) |
| `size: 32, weight: .medium` | `.s32Medium` (actually **bold**) | Decide: either add `s32Regular` or update `s32Medium` to match name |
| `size: 16, weight: .semibold` | `.s16Medium` | Decide: unify with medium or add `s16Semibold` |
| `size: 18, weight: .semibold` | `.s18Medium` | Decide: unify with medium or add `s18Semibold` |
| `size: 20, weight: .semibold` | `.s20Medium` | Decide: unify with medium or add `s20Semibold` |
| `size: 24, weight: .semibold` | `.s24Medium` | Decide: unify with medium or add `s24Semibold` |
| `size: 28, weight: .semibold` | `.s28Medium` | Decide: unify with medium or add `s28Semibold` |
| `size: 28, weight: .regular` | `.s28Medium` | Decide: add `s28Regular` or keep hardcoded |

---

## 4. Semantic Fonts (Not Size-Based)

These use semantic system fonts (`.caption`, `.title2`, etc.). Decide whether to keep or replace with custom extensions:

| File | Line | Current Code |
|------|------|--------------|
| MapSectionView.swift | 18 | `.font(.caption)` |
| AppLimitCardView.swift | 18 | `.font(.caption)` |
| AppLimitCardView.swift | 22 | `.font(.caption2)` |
| StreakView.swift | 18 | `.font(.caption)` |
| AthkarTestView.swift | 20 | `.font(.title2).bold()` |
| IntentionCard.swift | 34 | `.font(.title2.bold())` |
| IntentionCard.swift | 40 | `.font(.title)` |
| IntentionCard.swift | 50 | `.font(.largeTitle)` |
| IntentionCard.swift | 58 | `.font(.title2)` |
| IntentionCard.swift | 79 | `.font(.title3.bold())` |

---

## 5. Suggested New Extensions (Prioritized)

Based on frequency and similarity:

| New Extension | Spec | Rationale |
|---------------|------|-----------|
| **s32Regular** or **s32Medium** | 32pt, weight: .medium | Fix mismatch: `s32Medium` is bold; 2 uses of 32pt medium |
| **s16Semibold** | 16pt, weight: .semibold, design: .rounded | 2 uses; semibold distinct from medium |
| **s20Semibold** | 20pt, weight: .semibold | 2 uses (ManageIntentionsView, TabBar) |
| **s24Semibold** | 24pt, weight: .semibold, design: .rounded | 2 uses |
| **s14Regular** or **s14Medium** | 14pt, weight: .regular or .medium | 2 uses |
| **s18Semibold** | 18pt, weight: .semibold | 1 use; complements s18Medium |
| **s10Medium** | 10pt, weight: .medium | 1 use (TabBar) |
| **s22Medium** | 22pt, weight: .medium | 1 use (SymbolView) |
| **s28Semibold** | 28pt, weight: .semibold | 1 use |
| **s13Semibold** | 13pt, weight: .semibold | 1 use |

---

## 6. Quick Wins (Direct Replacements)

Replace these hardcoded fonts with existing extensions:

| File | Line | Replace With |
|------|------|--------------|
| SmallHabitCard.swift | 49 | `.s12Medium` |
| SmallHabitCard.swift | 59 | `.s12Light` |
| IntentionsView.swift | 112 | `.s28Medium` |
| IntentionsSymbolPicker.swift | 30 | `.s16Medium` |
| StartCycle.swift | 209 | `.s20Medium` |
| StartCycle.swift | 214 | `.s18Medium` |
| SymbolView.swift | 38, 42 | `.s16Medium` |
| SymbolView.swift | 52 | `.s18Medium` |

---

**Note:** `s32Medium` in your extensions uses `weight: .bold`, but its name suggests medium. Decide whether to rename it (e.g. to `s32Bold`) or add a true `s32Medium`/`s32Regular` for consistency.
