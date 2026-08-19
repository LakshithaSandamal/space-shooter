# Godot CI validation

This folder contains Godot-visible validation scripts used only by CI and editor-side diagnostics.

`validate_resources.gd` explicitly loads the production main scene, every visual-lab scene, and every shared visual shader so missing references and parse/load failures fail CI.

The GitHub Actions workflow is `.github/workflows/godot-validate.yml`.

Production gameplay must not depend on anything under `dev/`.
