
# Galactic Coders — Learning Game (Godot)

Galactic Coders is a single, cohesive learning game built with the Godot Engine. The project combines interactive lessons and minigames into a unified experience intended to demonstrate good project structure, modular scene design, and GDScript-based gameplay systems.

Key points
- Platform: Godot Engine (project files included)
- Language: GDScript
- Contents: lessons (variables, arrays, loops, strings), multiple minigames (asteroid dodge, hacking puzzle, flappy-style), UI/menu systems, and grouped assets.

Getting started
1. Install Godot Engine (recommended: Godot 3.5.x or a compatible 3.x build).
2. Open Godot, choose Project -> Import, and select the `project.godot` file at the repository root.
3. Open `Splash_Screen.tscn` or `welcome_screen.tscn` in the editor and run the project using the Play button.

Project structure (overview)
- `project.godot` — Godot project configuration
- `*.tscn` — Scenes (levels, UI, menus)
- `*.gd` — GDScript files (game logic, controllers, UI handlers)
- `assets/`, `LessonsImages/`, `planets/`, `spaceman/`, etc. — image and audio assets

Files and entry points to inspect
- Launch scenes: `Splash_Screen.tscn`, `welcome_screen.tscn`
- Global manager: `GameState.gd` (handles central game state and transitions)
- Lesson modules: `array_lesson.gd`, `loop_game.gd`, `hello_world_lesson.gd`, etc.
- Minigames: `asteroid_minigame.gd`, `hack_minigame.gd`, `flapMain.gd`, etc.
- UI helpers: `texture_button.gd`, `lessons_button.gd`, `homebutton.gd`.

Repository hygiene
The repository currently contains Godot-generated import/cache files (`*.import`) and a `.godot/` directory. These are not required for source and typically are added to `.gitignore` to keep the repo clean. Suggested `.gitignore` entries:

```
.godot/
*.import
export_presets.cfg
/.export/**
```

If you want the repository trimmed, I can remove generated import files and add `.gitignore` (either as a cleanup commit or by rewriting history and force-pushing).

Recommended next additions
- Add a `LICENSE` (e.g., MIT) if you want to clarify reuse rights.
- Add a small `docs/` folder or `README` screenshots/GIFs showing the game running.
- Optionally create a release branch with only essential source and assets for distribution.

Contributing and contact
If you'd like me to perform any of the cleanup tasks (remove import/cache files, add screenshots, add a license, or prepare a release) I can make those changes and push them to this repository.

---
This README was updated to present the project professionally and make it easy for reviewers to run and inspect the codebase.

