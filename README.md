# PetUncager
**PetUncager** is a simple World of Warcraft addon designed to help players uncage battle pets stored in their inventory and add them to the pet journal if they are not already at the collection limit.

## Features

- Creates a macro that will transfer pets from your bags to your pet journal (relearns them) for all pets that are not already at the 3/3 limit.
- Provides simple reporting to chat on the number of pets that can be added to your journal and those that are already at the maximum collection limit (3/3).
- Automatically creates a macro for easy access.

## Usage

### Macro Creation

- **Automatic Macro Creation**:
- Upon logging in, the addon automatically creates a macro named `PetUncagerMacro`. This macro is essential for the addon to function and can be found in the WoW macro interface.
- The macro is created in the character-specific macros section if space is available. If not, it attempts to create it in the global macros section.

### Using the Macro

1. **Placing the Macro**:
- Drag the `PetUncagerMacro` to your action bar for easy access.

2. **Running the Macro**:
- **Double-Click Requirement**: Due to the nature of how the addon operates, you need to **double-click** the macro button to uncage pets. The first click updates the macro, and the second click executes the uncaging process.
- The addon will attempt to uncage all eligible pets automatically from your inventory.
- If no further pets can be uncaged, the addon will display a message indicating the number of pets remaining at 3/3.

## Chat Messages

- **Upon Login:**
- `PetUncager stats:`
- `<number> pets can be added to your journal.`
- `<number> pets are already at 3/3 in bags.`

- **When Using the Macro:**
- `No further eligible pets found - <number> remaining 3/3 pets in bags.`

## Known Limitations

- No interaction with personal, guild or warband banks as yet, only checks bags.
- Requires a double-click on the macro to execute the uncaging process.


## License

This addon is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
