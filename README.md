# VORP Core

## Introduction

VORP Core is a comprehensive Lua-based framework for RedM, designed to enhance server functionality and player experience with a wide array of configurable settings and commands.

## Requirements

- [oxmysql](https://github.com/overextended/oxmysql/releases): A must-have for database operations, ensuring smooth data handling and integration.

## Installation Guide

1. **Setup:**
   - Download and ensure `oxmysql` is properly set up and configured in your RedM server environment.
2. **VORP Core Installation:**
   - Rename the downloaded folder to `vorp_core`.
   - Move the `vorp_core` folder into your server's resources directory, usually found under `\resources\[VORP]\vorp_core`.
   - Include `ensure vorp_core` in your server's `resources.cfg/server.cfg` file, placing it at the top of the load order for priority loading.

## Documentation

- [Documentation](https://docs.vorp-core.com/introduction)
- Direct link to the full VORP Core documentation for in-depth details and guides.

---

## Features Overview

## Configuration Options (`config.lua`)

### Server Settings
- **Language:** Set the server's language, referring to available options in the 'translation' folder.
- **OneSync:** Toggle OneSync integration (`true` for enabled).
- **Database Updates:** Enable automatic database updates.
- **Player Info Logs:** Configure logging of player information on join/leave.

### Starting Configuration
- **Initial Resources:** Set starting amounts for gold, money, role-play currency, and experience points.
- **Default Player Settings:** Configure default job, job grade, user group, and job label for new players.
- **Whitelist and Auto-update:** Manage whitelist settings and auto-updates.

### Player Limits
- **Health and Stamina:** Set maximum health and stamina for players.
- **PvP Settings:** Enable or disable player vs player combat and toggling.

### Multicharacter Support
- **Character Limits:** Set the maximum number of characters a player can create.
- **Discord ID Saving:** Choose to save Discord IDs in the character/user database.

### UI Core Settings
- **UI Visibility:** Manage the visibility of various UI elements, including player cores and the Dead Eye core.

### Webhook Configurations
- **Discord Integration:** Configure webhook color, name, logo, and footer for Discord integration.

### Map Configurations
- **Radar Settings:** Customize radar types for different scenarios (on foot, on horse).

### Respawn Settings
- **Health on Respawn/Resurrection:** Define health parameters for respawning and resurrection.
- **Respawn Mechanics:** Configure respawn timers, keys, and combat logging penalties.

### Ban System Configurations
- **Time Formatting:** Set the date and time format for ban notifications.
- **Time Zone Settings:** Configure server time zone and time difference from UTC.

### Command Permission Settings
- **Command Permissions:** Manage permissions for using various commands, including admin rights in the database.

### Discord Rich Presence Integration
- **Rich Presence Settings:** Customize Discord rich presence, including maximum players, application ID, and button configurations.

---

### Commands Overview (`commands.lua`)

##### Administrative Commands
- **addGroup:** Assign a group to a player with specified ID and group name.
- **addJob:** Assign a job to a player, including job name, grade, and salary.
- **addItem:** Add items to a player's inventory with item name and quantity.
- **addWeapon:** Provide weapons to a player with weapon name and ammo count.
- **delMoney:** Remove currency from a player's account, specifying type and amount.
- **addMoney:** Add currency to a player's account, specifying type and amount.
- **delWagons:** Delete a player's wagons.
- **revive:** Revive a player with specified ID.
- **teleport:** Teleport a player to a marked location.
- **delHorse:** Delete a player's horse.
- **heal:** Heal a player and replenish their needs.
- **addWhitelist:** Add a player to the whitelist.
- **unWhitelist:** Remove a player from the whitelist.
- **ban:** Ban a player with specified duration.
- **unBan:** Unban a player.
- **warn:** Issue a warning to a player.
- **unWarn:** Remove a warning from a player.
- **charName:** Change a character's name.
- **charCreateAdd:** Allow a player to create additional characters.
- **charCreateRemove:** Remove a player's ability to create additional characters.
- **myJob:** Display the player's current job and details.

These commands and configurations offer extensive control over the server's gameplay, administration, and player management, ensuring a tailored and smooth experience for all participants.

---

## Support and Community

For assistance, join the [VORP Core Discord](https://discord.gg/DHGVAbCj7N) community. Engage with developers and server administrators, share insights, and stay updated on the latest features and improvements.

---

## Credits

- **Original Framework:** Inspired by the [VORP-Core C# version](https://github.com/VORPCORE/VORP-Core/releases), this Lua version extends the core's functionality while maintaining its foundational principles.
- **Contributors:** Special thanks to `goncalobsccosta#9041` and all community members for their contributions and support in the development and enhancement of VORP Core.

---

VORP Core Lua Version offers a robust platform for RedM servers, providing the tools necessary for a highly customizable and immersive gameplay experience.
