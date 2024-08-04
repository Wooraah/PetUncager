# PetUncager

**PetUncager** is a simple World of Warcraft addon designed to help players uncage battle pets stored in their inventory and add them to the pet journal if they are not already at the collection limit.

## Features

* Provides a user interface for uncaging pets from your bags to your pet journal (relearns them) for all pets that are not already at the 3/3 limit.
* Offers a keybinding option for quick access to the uncaging function.
* Provides simple reporting to chat on the number of pets that can be added to your journal and those that are already at the maximum collection limit (3/3).
* Creates a button that can be spammed to quickly uncage multiple pets.

## Usage

### Accessing the UI

* Type `/uncager` in the chat to open the PetUncager interface.

### Using the UI

1. **Opening the UI**:
   * Use the `/uncager` command to open the PetUncager window.
2. **Uncaging Pets**:
   * Click the "Uncage Pets – Spam me" button in the UI to uncage eligible pets.
   * You can click this button multiple times to uncage several pets in succession.

### Keybinding

1. **Setting up a Keybind**:
   * Go to the WoW Key Bindings menu (Game Menu > Key Bindings).
   * Look for the "Pet Uncager" section under Add-Ons.
   * Set a keybind for the "Uncage Button" action.
2. **Using the Keybind**:
   * Press your assigned key to trigger the pet uncaging process.

### Chat Messages

* **Upon Login:**
  * `PetUncager loaded. Use /uncager to open the UI or set up a keybind in the Key Bindings menu.`
* **When Uncaging Pets:**
  * `Ready to uncage pet at bag <number> slot <number>.`
  * `Attempted to uncage: <pet name>`
* **When No Eligible Pets are Found:**
  * `No eligible pets found to uncage.`

## Known Limitations

* No interaction with personal, guild or warband banks as yet, only checks bags.
* May display some non-critical error messages in the chat, but these do not affect functionality.

## Troubleshooting

If you encounter any issues:
1. Ensure you have the latest version of the addon.
2. Try reloading your UI (`/reload`) or restarting the game.
3. If errors persist, check the chat for any specific error messages and report them to the addon author.

## License

This addon is licensed under the MIT License. See the LICENSE file for details.
