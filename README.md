# SwiftUI Practice

A small SwiftUI app most days, each in its own folder and each exploring one framework or technique:
layout, navigation, SwiftData, Swift Charts, MapKit, animation, notifications, accessibility and more.
Most of them are themed on health, wellbeing and the home. They are deliberately small, about an
hour of focused work each, and every one comes with unit tests for its logic. None of them is a
medical device, and they run on synthetic or public data only.

## Apps

| # | App | What it explores | Screenshot |
| --- | --- | --- | --- |
| 01 | [Room Comfort](apps/01-room-comfort) | `Grid`, `ViewThatFits` and `AnyLayout` adapting to width and Dynamic Type | Pending |

## Running an app

Open `apps/<folder>/<Name>.xcodeproj` in Xcode 26 or later, pick an iOS 17 or later simulator and
press Run. No signing changes are needed. Product > Test runs the app's Swift Testing suite.

## How the repo is put together

Each app folder has a `project.yml`. XcodeGen builds the `.xcodeproj` from it, and the project is
committed so that Xcode opens it straight away. A new app starts from `templates/app`:

```sh
tools/new-app.sh 02 self-care-guide "Self-Care Guide"
```

The script copies the template into `apps/02-self-care-guide`, fills in the names and bundle id, and
runs `xcodegen generate`. After adding or removing source files, run `xcodegen generate` again in the
app's folder so the committed project lists them.

GitHub Actions works out which app folders a pull request or push touched and builds each one on a
macOS runner. It picks the newest stable Xcode on the image, finds an iPhone simulator that Xcode
supports, runs the tests, then installs and launches the app and uploads a screenshot as an artifact.
A change to the workflow itself also builds the newest app, so the change is tried for real. The
workflow can be run by hand for one app folder or for `all`.

The screenshot column reads Pending until the screenshot is in the repo. Download the
`screenshot-<folder>` artifact from the pull request's run, unzip it, and add it before merging:

```sh
tools/add-screenshot.sh 01-room-comfort ~/Downloads/screenshot-01-room-comfort/screenshot.png
```

The script copies it to the app's `docs/screenshot.png`, adds a Screenshot section to the app's
README and puts the image in the index above.

## Licence

MIT. See [LICENSE](LICENSE).
