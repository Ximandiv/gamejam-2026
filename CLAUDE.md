# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Godot 4.6 game project ("Jam 2026") developed for Global Game Jam 2026. The game features a player character with mask-based abilities, where different masks provide special powers (SILENCE, FOCUS, BRAVERY).

## Running the Project

- Open the project in Godot 4.6 or later
- The main scene is configured in [project.godot](project.godot) (currently set to `uid://bcgurf4q5skse`)
- Run the project using Godot's play button or F5
- Resolution: 1920x1080

## Architecture

### Player System
The player uses a component-based architecture split across multiple scripts:

- **[player_movement.gd](Scripts/Player/player_movement.gd)**: CharacterBody2D handling movement, jumping, and push mechanics. The player has two separate velocity components (`_input_velocity_x` for player input and `_push_velocity_x` for external forces) that combine for final movement.
- **[player_masks.gd](Scripts/Player/player_masks.gd)**: Manages mask switching via input (currently only SILENCE mask on key "1"). Uses a shared `PlayerStatus` resource.
- **[PlayerStatus](Scripts/Player/player_status_resource.gd)**: Resource class storing the current active mask state, shared between player components and trigger systems.
- **[PlayerMaskEnum](Scripts/Player/Enums/player_mask_enum.gd)**: Global autoload enum defining available masks (NONE, SILENCE, FOCUS, BRAVERY).

### Global Systems
- **[GameState](shared/utils/GameState.gd)**: Singleton managing game state (score, lives, level), save/load functionality via ConfigFile, and settings. Not configured as autoload yet.
- **[MusicManager](shared/utils/MusicManager.gd)**: Singleton for music playback with crossfade support between tracks using dual AudioStreamPlayer instances. Not configured as autoload yet.

### Triggers
- **[sound_trigger.gd](Scripts/Triggers/sound_trigger.gd)**: Area2D that pushes the player when entered, unless they have the SILENCE mask active. The trigger stops movement, waits 1.5s, then applies a push force.

### Input Actions
Defined in [project.godot](project.godot):
- `left`: Left arrow key
- `right`: Right arrow key
- `jump`: Space bar
- `silence`: Key "1" (activates silence mask)

### Physics
- Uses "Jolt Physics" engine for 3D (though this appears to be a 2D game)
- GL Compatibility renderer
- Default texture filter set to nearest-neighbor (pixel art style)

## Code Conventions

- GDScript files use snake_case for variables/functions, PascalCase for class names
- Export variables prefixed with `_` are considered internal despite being exported
- Player components communicate via shared `PlayerStatus` resource
- Use signals for cross-system communication (GameState, MusicManager)
- Groups are used for identifying nodes ("player", "sound_push_area")
