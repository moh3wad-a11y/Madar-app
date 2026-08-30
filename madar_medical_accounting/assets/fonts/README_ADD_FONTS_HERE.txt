This folder must contain, before your first build:

  Cairo-Regular.ttf
  Cairo-Medium.ttf
  Cairo-Bold.ttf

Download the Cairo font family (SIL Open Font License - free for
commercial use) from Google Fonts: https://fonts.google.com/specimen/Cairo

These are bundled as local assets (not fetched via the google_fonts
package) so the app's Arabic typography renders correctly with zero
network access on a fresh install, per the "must work offline"
requirement.

Delete this file once the three .ttf files are in place.
