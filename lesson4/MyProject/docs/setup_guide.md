# Setup Guide

## Requirements

- Godot Engine 4.x
- Git (for version control)

## Installation

1. Clone the repository
2. Open Godot Engine
3. Import the project by selecting `project.godot`
4. Run the project (F5)

## Development Setup

### Project Structure
The project follows a modular structure:
- `autoload/` - Global singleton scripts
- `scenes/` - Scene files organized by category
- `scripts/` - Logic scripts organized by system
- `assets/` - All game resources
- `data/` - Configuration and data files

### Adding New Features

1. Create scripts in appropriate `scripts/` subdirectory
2. Create scenes in appropriate `scenes/` subdirectory
3. Add assets to appropriate `assets/` subdirectory
4. Update configuration files in `data/config/` if needed

## Building

Use Godot's export system to build for target platforms.
