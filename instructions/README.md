# AI instruction index

Use the instruction file that matches the task, together with the canonical docs.

## General Godot implementation

Read:

```text
instructions/godot_ai_instructions.md
```

It defines Godot 4.7 architecture, typed GDScript, scene ownership, node selection, validation, and staged implementation rules.

## Visual production / UI / VFX / shaders

Also read:

```text
instructions/visual_ai_instructions.md
```

It defines the procedural visual pipeline, production visual code ownership, semantic colors, font/icon rules, animation policy, and visual-lab QA requirements.

## Canonical visual review scene

```text
res://dev/visual_lab/visual_lab.tscn
```

Production code must never depend on `dev/`.
