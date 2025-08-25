# Architecture Documentation

## Overview

This project is a 3D virtual space application built with Godot Engine.

## Structure

- **Autoload System**: Global managers for game state, networking, audio, etc.
- **Scene System**: Hierarchical scene management for UI and 3D worlds
- **Network Layer**: WebSocket + GraphQL communication
- **Asset Pipeline**: Organized asset management system

## Key Components

### Autoload Managers
- Game: Global state management
- Net: Network communication
- Audio: Sound system
- Chat: Chat functionality  
- Rooms: Room management
- Settings: Configuration management

### Player System
- PlayerController: Local player control
- PlayerSync: Network synchronization
- AnimationController: Animation state management

### UI System
- Screen management with history
- Component-based UI elements
- Theme and localization support
