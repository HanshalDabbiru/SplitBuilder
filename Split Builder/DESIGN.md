# Design System Documentation

This document outlines the design language, patterns, and conventions used throughout the workout tracking app. Reference this when creating or modifying UI elements to maintain consistency.

## Core Principles

1. **Simplicity First**: Clean, minimal layouts without excessive decoration
2. **Clear Hierarchy**: Use typography and spacing to establish information priority
3. **Consistent Theming**: Leverage the Theme system for all color decisions
4. **Readable Code**: Prefer explicit layouts over complex modifiers

## Theme System

### Structure
```swift
enum Theme: String, CaseIterable, Identifiable, Codable {
    case bubblegum, buttercup, indigo, lavender, magenta, navy, 
         orange, oxblood, periwinkle, poppy, purple, seafoam, 
         sky, tan, teal, yellow
}
```

### Properties
- `theme.mainColor`: Primary background color for the themed element
- `theme.accentColor`: Foreground text/icon color (auto-adjusts to black or white for optimal contrast)
- Light themes (bubblegum, buttercup, lavender, etc.) → black accent
- Dark themes (indigo, magenta, navy, etc.) → white accent

### Application
- Apply `theme.mainColor` via `.background()` or `.listRowBackground()`
- Apply `theme.accentColor` via `.foregroundColor()`
- Each Exercise and Day has its own theme property
- Use `generateTheme()` method to get random themes for new exercises (avoids consecutive duplicates)

## Typography Scale

Use these font modifiers to establish clear visual hierarchy:

- `.font(.largeTitle)` - Primary page headers (rare, high emphasis)
- `.font(.title)` - Section headers, main content titles
- `.font(.title3)` - Subsection headers, card headers
- `.font(.body)` - Default readable text, counts, descriptions
- `.font(.caption2)` - Small supplementary info, units, metadata

**Example from DayCardView:**
```swift
Text(day.name)
    .font(.title)  // Main identifier

Text("\(day.exercises.count) exercises")
    .font(.body)  // Supporting info

Text("\(day.time()) minutes")
    .font(.caption2)  // Small metadata
```

## Layout Patterns

### Stack Usage

**VStack**: Vertical arrangements of content
- Use `alignment: .leading` for left-aligned content lists
- Use default (center) alignment for headers and centered layouts
- Include `Spacer()` at top and bottom for vertical centering when needed

**HStack**: Horizontal arrangements
- Use for pairing icons with text
- Use for splitting content (label on left, value on right)
- Use `Spacer()` between elements to push content to edges

**Example Pattern:**
```swift
VStack(alignment: .leading) {
    Spacer()
    HStack {
        Text("Label")
        Spacer()
        Text("Value")
    }
    Spacer()
}
```

### Spacer Guidelines
- Use `Spacer()` generously to create breathing room
- Place between elements to push them apart
- Wrap content with vertical Spacers for centering
- HStack with Spacers: `HStack { Spacer(); Content; Spacer() }` for centering

### Padding and Spacing
- **Vertical padding**: Use `.padding(.vertical)` on card content for consistent spacing
- **Top padding**: Use `.padding(.top)` for header sections
- **VStack spacing**: Default spacing is adequate; avoid explicit spacing parameters unless needed
- **Between sections**: Let Form and List handle section spacing naturally
- **Card breathing room**: Spacer() at top and bottom of VStacks provides visual separation
- **Button spacing**: Add buttons use HStack with leading/trailing Spacers for centering

## SF Symbols (Icons)

### Commonly Used Icons
- `dumbbell.fill` - Exercises, weight-related actions
- `clock` - Time, duration
- `circle` - Unchecked state
- `checkmark.circle.fill` - Checked/completed state
- `plus` or `plus.circle.fill` - Add new items
- `square.and.arrow.up` - Share functionality

### Icon Placement
- Pair icons with text in HStacks: `HStack { Image(systemName: "clock"); Text("30 minutes") }`
- Icons typically appear before text for status indicators
- Icons can appear after text for decorative emphasis (e.g., dumbbell with exercise name)

### Sizing
- Default size works for most cases
- Use `.font(.caption2)` on images to scale down for metadata
- Use `.font(.system(size: 50))` for large action buttons (e.g., add button)

## Common UI Components

### Text Fields
```swift
TextField("Exercise Name", text: $exercise.name)
// Simple, no special styling in this app
// Placed at top of forms/cards
```

### Steppers
```swift
Stepper("\(exercise.sets) sets", value: $setsBinding, in: 0...10)
// Label shows current value with unit
// Always include range constraint
```

### Sliders
```swift
Slider(value: $weight, in: 0...300, step: 5) {
    Text("Weight")
}
// Include accessible label
// Define clear min, max, and step values
// Often paired with value display
```

### Buttons
```swift
Button(action: { /* action */ }) {
    Image(systemName: "plus.circle.fill")
        .foregroundColor(day.theme.mainColor)
        .font(.system(size: 50))
}
// Actions use closures
// Button content can be images or text
// Apply theme colors for consistency
```

### Lists
```swift
List {
    Section(header: Text("Section Title")) {
        ForEach($items) { $item in
            ItemView(item: $item)
        }
    }
}
// Use sections to group related content
// Headers can be simple Text or complex HStacks
// Apply `.listRowBackground()` for themed rows
```

## Card Design Patterns

### Exercise Card (Display Mode)
Used in DayView for showing exercises during workout:
```swift
HStack {
    Button(action: { exercise.toggle() }) {
        Image(systemName: !exercise.isChecked ? "circle" : "checkmark.circle.fill")
    }
    VStack(alignment: .leading) {
        HStack {
            Text(exercise.name)
                .font(.title3)
            Image(systemName: "dumbbell.fill")
        }
        Text("\(exercise.weight, specifier: "%.1f") lbs")
            .font(.caption2)
    }
    Spacer()
    Text("\(exercise.sets)x\(exercise.reps)")
}
.foregroundColor(exercise.theme.accentColor)
```

**Key elements:**
- Check button for completion tracking
- Exercise name with dumbbell icon
- Weight with units (caption size)
- Sets x Reps format on right
- Full theme color application

### Exercise Select Card (Edit Mode)
Used in DayFormView for configuring exercises:
```swift
VStack {
    TextField("Exercise Name", text: $exercise.name)
    // Control elements for weight, sets, reps
}
```

**Key elements:**
- TextField at top
- Editing controls (sliders, steppers)
- Show current values with units
- Dumbbell icon with weight displays

**For lists of editable items (like sets):**
- Wrap each item in VStack with padding for breathing room
- Use Divider() between items for visual separation
- Add buttons positioned at bottom with Spacer() centering
- Consider using ScrollView if items can exceed screen height

### Day Card
Used in SplitView list:
```swift
VStack(alignment: .leading) {
    HStack {
        Text(day.name)
            .font(.title)
        Spacer()
        VStack(alignment: .leading) {
            Text("\(day.exercises.count) exercises")
                .font(.body)
            HStack {
                Image(systemName: "clock")
                    .font(.caption2)
                Text("\(day.time()) minutes")
                    .font(.caption2)
            }
        }
    }
    .foregroundColor(day.theme.accentColor)
    .padding(.vertical)
}
```

**Key elements:**
- Day name prominent on left
- Exercise count and duration on right
- Small clock icon with time
- Vertical padding for touch targets

## Data Display Conventions

### Numbers
- Weight: Show with 1 decimal place `%.1f` or as Int
- Sets/Reps: Always integers
- Counts: Integers (e.g., "3 exercises")
- Time: Integers with "minutes" unit

### Units
- Weight: "lbs" (always include)
- Time: "minutes" (spelled out)
- Sets x Reps: "3x12" format (no spaces)

### Text Formatting
- Exercise names: Capitalize, no special formatting
- Day names: Capitalize
- Empty states: Clear descriptive text (e.g., "No Exercises Today")

## Form Design

### Section Headers
```swift
Section(header: Text("Section Title")) {
    // content
}

// Or centered with styling:
Section(header: HStack { 
    Spacer()
    Text("Current Day").font(.title3)
    Spacer()
}) {
    // content
}
```

### Form Structure (DayFormView pattern)
```swift
Form {
    Section(header: Text("Basic Info")) {
        TextField(...)
        CustomPicker(...)
    }
    Section(header: Text("Theme")) {
        ThemePicker(...)
    }
    Section(header: Text("Items")) {
        List($items, editActions: .all) { $item in
            ItemView(item: $item)
        }
    }
    // Add button at bottom
    HStack {
        Spacer()
        Button(action: { /* add */ }) {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(theme.mainColor)
                .font(.system(size: 50))
        }
        Spacer()
    }
    .listRowBackground(Color.clear)
}
```

## Navigation Patterns

### Toolbar Items
```swift
.toolbar {
    ToolbarItem(placement: .cancellationAction) {
        Button("Cancel") { /* action */ }
    }
    ToolbarItem(placement: .confirmationAction) {
        Button("Save") { /* action */ }
            .disabled(condition)
    }
    ToolbarItem {
        Button(action: { /* action */ }) {
            Image(systemName: "plus")
        }
    }
}
```

### Navigation Links
```swift
NavigationLink(destination: DetailView(item: $item)) {
    ItemCardView(item: $item)
}
.listRowBackground(item.theme.mainColor)
```

### Sheets for Modal Presentation
```swift
.sheet(isPresented: $isPresenting) {
    NavigationStack {
        EditView(...)
    }
}
```

## State Management

### Bindings
- Use `@Binding` for child views that need to modify parent state
- Binding syntax: `TextField("Name", text: $item.name)`
- For computed bindings, create custom Binding wrappers:
```swift
private var customBinding: Binding<Type> {
    Binding(
        get: { /* read value */ },
        set: { newValue in /* write value */ }
    )
}
```

### Draft Pattern (EditDayView)
For complex editing with cancel/save:
```swift
@State private var draftDay: Day
@State private var originalDay: Day

init(day: Binding<Day>) {
    self._day = day
    self._draftDay = State(initialValue: day.wrappedValue)
    self._originalDay = State(initialValue: day.wrappedValue)
}

private var hasChanges: Bool {
    draftDay != originalDay
}

// Edit draftDay, save on confirmation, compare for changes
```

## Interaction Patterns

### Toggle Actions
```swift
Button(action: { exercise.toggle() }) {
    Image(systemName: exercise.isChecked ? "checkmark.circle.fill" : "circle")
}
```

### Add Items
Large centered button at bottom of lists or forms:
```swift
HStack {
    Spacer()
    Button(action: { /* add new item */ }) {
        Image(systemName: "plus.circle.fill")
            .foregroundColor(theme.mainColor)
            .font(.system(size: 50))
    }
    Spacer()
}
.listRowBackground(Color.clear)
```

**Pattern notes:**
- Use `plus.circle.fill` for add actions
- Size at 50 points for prominent touch target
- Center horizontally with leading/trailing Spacers
- Apply theme.mainColor for consistency
- Use smaller icons for inline add buttons (reduce size to 30-35 points)

### Delete/Edit Actions
Use `.editActions: .all` on List with ForEach for swipe actions

### Remove Items
For inline removal (like removing sets):
- Use smaller minus/trash icons
- Can use Button with system image
- Consider using destructive button style for clarity

## Accessibility

### Labels
Always provide accessible labels for controls:
```swift
Slider(value: $weight, in: 0...300, step: 5) {
    Text("Weight")  // Accessible label
}
```

### Text Sizing
Use semantic font styles (`.title`, `.body`, etc.) which automatically scale with Dynamic Type

## Common Pitfalls to Avoid

1. **Don't hardcode colors** - Always use theme.mainColor and theme.accentColor
2. **Don't skip Spacers** - They're essential for proper layout
3. **Don't mix font sizes randomly** - Follow the established scale
4. **Don't forget units** - Always show "lbs", "minutes", etc.
5. **Don't skip preview providers** - Include them for all views
6. **Don't ignore empty states** - Always handle zero-item cases

## Preview Patterns

```swift
struct ViewName_Previews: PreviewProvider {
    static var previews: some View {
        // For simple views:
        ViewName(item: .constant(Item.sampleData))
        
        // For navigation views:
        NavigationStack {
            ViewName(item: .constant(Item.sampleData))
        }
        
        // For fixed size previews:
        ViewName(...)
            .previewLayout(.fixed(width: 400, height: 120))
            .background(theme.mainColor)
    }
}
```

## Code Organization

### File Structure
- One view per file
- File name matches struct name
- Include comments at top for view purpose
- Keep related views grouped (e.g., all Day views together)

### Computed Properties
Place after body:
```swift
var body: some View {
    // view code
}

private var customBinding: Binding<Type> {
    // binding logic
}
```

## Example: Building a New Card View

When creating a new card view, follow this template:

```swift
import SwiftUI

struct NewCardView: View {
    @Binding var item: Item
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text(item.name)
                        .font(.title3)
                    Text(item.detail)
                        .font(.caption2)
                }
                Spacer()
                HStack {
                    Image(systemName: "icon.name")
                        .font(.caption2)
                    Text(item.value)
                        .font(.body)
                }
            }
            .foregroundColor(item.theme.accentColor)
            .background(item.theme.mainColor)
            .padding(.vertical)
            Spacer()
        }
    }
}

struct NewCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewCardView(item: .constant(Item.sampleData))
            .previewLayout(.fixed(width: 400, height: 80))
            .background(Item.sampleData.theme.mainColor)
    }
}
```

## Summary Checklist

When creating any new UI element, verify:

- [ ] Uses appropriate typography scale
- [ ] Applies theme colors correctly
- [ ] Includes proper Spacers for layout
- [ ] Uses SF Symbols consistently
- [ ] Shows units with numeric values
- [ ] Has a PreviewProvider
- [ ] Follows VStack/HStack patterns from existing views
- [ ] Handles empty/zero states
- [ ] Uses bindings appropriately
- [ ] Matches the minimal, clean aesthetic

---

*This design system is extracted from the existing codebase patterns. When in doubt, refer to similar existing views as examples.*
