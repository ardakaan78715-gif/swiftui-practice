# Room Comfort

Set a room's temperature and humidity with two sliders and the app tells you whether the room is
comfortable, works out the dew point and suggests what to change, such as running the extractor fan
in a damp room or turning the heating up in a cold one.

## What it explores

Layout that adapts to the space it gets and to the reader's text size.

- `Grid` and `GridRow` line up the reading tiles, and `gridCellColumns(2)` lets the dew point tile
  span both columns.
- `ViewThatFits` tries a three-column grid, then a two-column grid, then a plain stack, and keeps the
  first one that fits. On an iPhone in portrait that is the two-column grid. In landscape all three
  tiles fit in one row, and at the largest accessibility text sizes they stack.
- `AnyLayout` switches the verdict header from a row to a column at accessibility text sizes. The
  views keep their identity when the layout changes, so the switch can animate.
- The logic stays out of the views. `RoomReading` sorts the readings into bands and works out the
  dew point, and `ComfortReport` turns those bands into a headline, a colour and tips. Swift Testing
  covers both in `Tests/`, with parameterised tests on every band boundary.

## How the numbers work

Comfortable means 18 to 24 °C and 40 to 60% relative humidity, the usual rule-of-thumb ranges for a
living space. The dew point uses the Magnus formula with the constants 17.62 and 243.12 °C, which is
accurate to a few tenths of a degree across normal indoor conditions.

This is general guidance for the home. It is not a medical device.
