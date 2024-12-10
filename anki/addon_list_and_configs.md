---
title: _anki_addon_config
aliases:
  - Anki Addons and Configs
  - _anki_addon_config
date_created: 2024-12-01T18:19
date_modified: 2024-12-01T18:32
---
# Anki Addons and Configs

## Download Codes

| Addon                                                                    | Code       |
| ------------------------------------------------------------------------ | ---------- |
| [Addon Config Sync](https://ankiweb.net/shared/info/60290354)            | 60290354   |
| [Advanced Browser](https://ankiweb.net/shared/info/874215009)            | 874215009  |
| [AJT Media Converter](https://ankiweb.net/shared/info/1151815987)        | 1151815987 |
| [Anki Note Linker](https://ankiweb.net/shared/info/1077002392)           | 1077002392 |
| [AnkiConnect](https://ankiweb.net/shared/info/2055492159)                | 2055492159 |
| [AnkiRestart](https://ankiweb.net/shared/info/237169833)                 | 237169833  |
| [BetterSearch](https://ankiweb.net/shared/info/1052724801)               | 1052724801 |
| [Customize Keyboard Shortcuts](https://ankiweb.net/shared/info/24411424) | 24411424   |
| [Enhance main window](https://ankiweb.net/shared/info/877182321)         | 877182321  |
| [FSRS Helper](https://ankiweb.net/shared/info/759844606)                 | 759844606  |
| [Image Occlusion Enhanced](https://ankiweb.net/shared/info/1374772155)   | 1374772155 |
| [Markdown input](https://ankiweb.net/shared/info/904999275)              | 904999275  |
| [Review Heatmap](https://ankiweb.net/shared/info/1771074083)             | 1771074083 |

## Config

### Advanced Browser

```json
// Advanced Browser: 874215009
{
    "Column alignment": "Start",
    "Show internal fields": false,
    "Table content": "No interaction",
    "Use a single list for fields": false
}
```

### AJT Media Converter

```json
// AJT Media Converter: 1151815987
{
    "avoid_upscaling": true,
    "bulk_convert_fields": [],
    "bulk_reconvert_webp": false,
    "convert_on_note_add": true,
    "copy_paste": true,
    "custom_name_field": "front",
    "cwebp_args": [
        "-short",
        "-mt",
        "-pass",
        "10",
        "-af",
        "-blend_alpha",
        "0xffffff",
        "-m",
        "6"
    ],
    "drag_and_drop": true,
    "filename_pattern_num": 0,
    "image_height": 300,
    "image_quality": 100,
    "image_width": 0,
    "max_image_height": 600,
    "max_image_width": 800,
    "preserve_original_filenames": true,
    "saved_presets": [
        {
            "image_height": 300,
            "image_quality": 100,
            "image_width": 0
        },
        {
            "image_height": 0,
            "image_quality": 100,
            "image_width": 0
        }
    ],
    "shortcut": "Ctrl+Meta+v",
    "show_context_menu_entry": true,
    "show_editor_button": true,
    "show_settings": "toolbar",
    "tooltip_duration_seconds": 5
}
```

### BetterSearch

```json
// BetterSearch: 1052724801
{
    "--aliases Replace while typing": false,
    "--aliases dictionary": {},
    "--aliases_regex Replace while typing": false,
    "--aliases_regex dictionary": {},
    "-Add Button to the Browser Search Bar": true,
    "-Modify Search Bar": false,
    "-Multiline bar Auto Search on space (only for Anki versions <=2.1.40)": true,
    "-Multiline bar Height relative to default (when shown in Browser)": 100,
    "-Shortcut for Multi-bar mode: show fuzzy menu": "Alt+h, g",
    "Multiline Dialog: Shortcut inside: Open History": "Alt+H, h",
    "Multiline Dialog: shortcut: open window": "Alt+t,s",
    "Multiline Dialog: show Button Bar": true,
    "Multiline Dialog: show Filter Button (only for Anki versions <=2.1.40)": true,
    "Multiline Dialog: use bigger typewriter font": true,
    "also use in create filtered deck dialog": true,
    "autoadjust FilterDialog position": true,
    "custom tag&deck string 1": "xx",
    "custom tag&deck string 2": "all:",
    "date range dialog for added: string": "dadded:",
    "date range dialog for edited: string": "dedited:",
    "date range dialog for introduced: string": "dintroduced:",
    "date range dialog for rated: string": "drated:",
    "ignore upper and lower case (case insensitive search)": false,
    "lines shown in filter dialog": 500,
    "modifier for insert current text only": "Ctrl",
    "modifier for negate": "Alt",
    "modifier for override add * default": "Meta",
    "modifier for override autosearch default": "Shift",
    "modify: window opened by search strings triggers search by default": true,
    "modify_card": true,
    "modify_deck": true,
    "modify_field": true,
    "modify_flag": true,
    "modify_is": true,
    "modify_is__show_explanations": true,
    "modify_note": true,
    "modify_props": true,
    "modify_tag": true,
    "shortcut - focus search box and card from note dialog": "Alt+H, x",
    "shortcut - focus search box and card selector dialog": "Alt+H, c",
    "shortcut - focus search box and date added dialog": "Alt+H, a",
    "shortcut - focus search box and date edited dialog": "Alt+H, e",
    "shortcut - focus search box and date introduced dialog": "Alt+H, i",
    "shortcut - focus search box and date rated dialog": "Alt+H, r",
    "shortcut - focus search box and deck selector dialog": "Alt+H, d",
    "shortcut - focus search box and field from note dialog": "Alt+H, f",
    "shortcut - focus search box and is dialog": "Alt+H, s",
    "shortcut - focus search box and note selector dialog": "Alt+H, n",
    "shortcut - focus search box and prop dialog": "Alt+H, p",
    "shortcut - focus search box and tag selector dialog": "Alt+H, t",
    "shortcut - focus search box and tag/deck selector dialog": "Alt+H, m",
    "shortcut - select entry from history in fuzzy dialog": "Alt+H, h",
    "shortcuts trigger search by default": true,
    "tag dialog exit on re:": false,
    "tag insertion - add '*' to matches": "all"
}
```

### Customize Keyboard Shortcuts

```json
// Customize Keyboard Shortcuts: 24411424
{
    "editor _duplicates": {},
    "editor _extras": {
        "paste custom text": "<nop>"
    },
    "editor _pastes": {},
    "editor add card close window": "<default>",
    "editor add media": "F3",
    "editor block indent": "<nop>",
    "editor block outdent": "<nop>",
    "editor bold": "Ctrl+B",
    "editor card layout": "Ctrl+L",
    "editor change col": "F8",
    "editor change deck": "<nop>",
    "editor change note type": "Ctrl+N",
    "editor cloze": "Ctrl+Shift+C",
    "editor cloze alt": "Ctrl+Shift+Alt+C",
    "editor cloze forced increment": "<nop>",
    "editor cloze no increment": "<nop>",
    "editor confirm add card": "Ctrl+Return",
    "editor focus tags": "Ctrl+Shift+T",
    "editor foreground": "F7",
    "editor html edit": "Ctrl+Shift+X",
    "editor insert latex": "Ctrl+T, T",
    "editor insert latex equation": "Ctrl+T, E",
    "editor insert latex math environment": "Ctrl+T, M",
    "editor insert mathjax block": "Shift+Ctrl+M",
    "editor insert mathjax chemistry": "Ctrl+M, C",
    "editor insert mathjax inline": "Ctrl+Alt+M",
    "editor italic": "Ctrl+I",
    "editor list insert ordered": "<nop>",
    "editor list insert unordered": "<nop>",
    "editor record sound": "F5",
    "editor remove format": "Ctrl+R",
    "editor subscript": "Ctrl+=",
    "editor superscript": "Ctrl++",
    "editor toggle sticky all": "Shift+F9",
    "editor toggle sticky current": "F9",
    "editor underline": "Ctrl+U",
    "m_toolbox _duplicates": {},
    "m_toolbox addons": "Ctrl+Shift+A",
    "m_toolbox create filtered deck": "F",
    "m_toolbox export": "Ctrl+E",
    "m_toolbox import": "Ctrl+Shift+I",
    "m_toolbox preferences": "Ctrl+P",
    "m_toolbox quit": "Ctrl+Q",
    "m_toolbox see documentation": "F1",
    "m_toolbox study": "/",
    "m_toolbox switch profile": "Ctrl+Shift+P",
    "m_toolbox undo": "Ctrl+Z",
    "main add": "A",
    "main browse": "B",
    "main debug": "Ctrl+:",
    "main deckbrowser": "D",
    "main stats": "T",
    "main study": "S",
    "main sync": "Y",
    "reviewer _duplicates": {},
    "reviewer bury card": "-",
    "reviewer bury note": "=",
    "reviewer card info": "I",
    "reviewer choice 1": "1",
    "reviewer choice 2": "2",
    "reviewer choice 3": "3",
    "reviewer choice 4": "4",
    "reviewer delete note": "Ctrl+Delete",
    "reviewer edit current": "E",
    "reviewer flip card 1": " ",
    "reviewer flip card 2": "Qt.Key_Return",
    "reviewer flip card 3": "Qt.Key_Enter",
    "reviewer mark card": "*",
    "reviewer more options": "M",
    "reviewer options menu": "o",
    "reviewer pause audio": "5",
    "reviewer play recorded voice": "v",
    "reviewer previous card info": "Alt+I",
    "reviewer record voice": "Shift+v",
    "reviewer replay audio 1": "r",
    "reviewer replay audio 2": "F5",
    "reviewer seek backward": "6",
    "reviewer seek forward": "7",
    "reviewer set due date": "Ctrl+Shift+D",
    "reviewer set flag 0": "Ctrl+0",
    "reviewer set flag 1": "Ctrl+1",
    "reviewer set flag 2": "Ctrl+2",
    "reviewer set flag 3": "Ctrl+3",
    "reviewer set flag 4": "Ctrl+4",
    "reviewer set flag 5": "Ctrl+5",
    "reviewer set flag 6": "Ctrl+6",
    "reviewer set flag 7": "Ctrl+7",
    "reviewer suspend card": "@",
    "reviewer suspend note": "!",
    "window_browser _filters": {
        "_concat": {},
        "_orConcat": {}
    },
    "window_browser add note": "Ctrl+E",
    "window_browser add tag": "Ctrl+Shift+A",
    "window_browser change deck": "Ctrl+D",
    "window_browser change note type": "Ctrl+Shift+M",
    "window_browser clear unused tags": "<nop>",
    "window_browser close": "Ctrl+W",
    "window_browser delete": "Ctrl+Del",
    "window_browser filter": "Ctrl+Shift+F",
    "window_browser find": "Ctrl+F",
    "window_browser find and replace": "Ctrl+Alt+F",
    "window_browser find duplicates": "<nop>",
    "window_browser first card": "Home",
    "window_browser flag_blue": "Ctrl+4",
    "window_browser flag_green": "Ctrl+3",
    "window_browser flag_orange": "Ctrl+2",
    "window_browser flag_red": "Ctrl+1",
    "window_browser forget card": "Ctrl+Alt+N",
    "window_browser goto card list": "Ctrl+Shift+L",
    "window_browser goto next note": "Ctrl+N",
    "window_browser goto note": "Ctrl+Shift+N",
    "window_browser goto previous note": "Ctrl+P",
    "window_browser goto sidebar": "Ctrl+Shift+R",
    "window_browser guide": "F1",
    "window_browser info": "Ctrl+Shift+I",
    "window_browser invert selection": "Ctrl+Alt+S",
    "window_browser last card": "End",
    "window_browser manage note types": "<nop>",
    "window_browser preview": "Ctrl+Shift+P",
    "window_browser remove current filter": "<nop>",
    "window_browser remove tag": "Ctrl+Alt+Shift+A",
    "window_browser reposition": "Ctrl+Shift+S",
    "window_browser reschedule": "Ctrl+Shift+D",
    "window_browser save current filter": "<nop>",
    "window_browser select all": "Ctrl+Alt+A",
    "window_browser select notes": "<nop>",
    "window_browser sidebar search": "Alt+1",
    "window_browser sidebar select": "Alt+2",
    "window_browser suspend": "Ctrl+J",
    "window_browser toggle mark": "Ctrl+K",
    "window_browser undo": "Ctrl+Alt+Z",
    "Ω custom paste end style": "n",
    "Ω custom paste extra texts": {},
    "Ω custom paste text": "",
    "Ω enable conflict warning": "y",
    "Ω enable editor": "y",
    "Ω enable m_toolbox": "y",
    "Ω enable main": "y",
    "Ω enable reviewer": "y",
    "Ω enable window_browser": "y"
}
```

### Enhance Main Window

```json
// Enhance Main Window: 877182321
{
    "book symbol": "{",
    "cap value": null,
    "color empty": "red",
    "color empty descendant": "green",
    "color zero": false,
    "columns": [
        {
            "description": "Percent bar to do today",
            "header": "Today",
            "name": "bar",
            "names": [
                "review today",
                "new today",
                "learning card",
                "reviewed today"
            ],
            "overlay": null,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "#893BFF",
            "description": "Number of reviews you will see today (new, review and learning)",
            "header": "Review Total",
            "name": "today",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "red",
            "description": "Cards you'll see today which are not new",
            "header": null,
            "name": "cards seen today",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "#FFF380",
            "description": "Review cards you will see today",
            "header": "Due",
            "name": "review today",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "green",
            "description": "Review cards you will see today (and the ones you will not see today)",
            "header": null,
            "name": "review",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Unseen cards you will see today (what Anki calls New cards), followed by the unseen cards that you will not see today. Neither buried nor suspended.",
            "header": null,
            "name": "unseen new",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Cards that have never been answered. Neither buried nor suspended.",
            "header": null,
            "name": "unseen",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "#FFA62F",
            "description": "Unseen cards you will see today (what Anki calls New cards). Neither buried nor suspended.",
            "header": "New",
            "name": "new today",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "#6AA121",
            "description": "Cards in learning (either new cards you see again, or cards which you have forgotten recently, assuming those cards didn't graduate)",
            "header": "In Progress",
            "name": "learning card",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Reviews which will happen later, either because a review happened recently, or because the card has many review left.",
            "header": null,
            "name": "learning later",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Cards in learning which are due now (and in parentheses, the number of reviews which are due later)",
            "header": null,
            "name": "learning all",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Cards in learning which are due now",
            "header": null,
            "name": "learning now",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "green",
            "description": "Review cards which are due today (not counting those in learning)",
            "header": null,
            "name": "review due",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "#6698FF",
            "description": "Number of reviewed cards seen today",
            "header": "Seen Today",
            "name": "reviewed today",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "#6698FF",
            "description": "Number of reviews done today",
            "header": "Reviews Today",
            "name": "repeated today",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "magenta",
            "description": "Number of reviewed cards seen today and number of reviews",
            "header": null,
            "name": "reviewed today/repeated today",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Number of times you saw a question from this deck",
            "header": null,
            "name": "repeated",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "description": "Percent bar showing the decks' repartition",
            "header": "Total",
            "name": "bar",
            "names": [
                "mature",
                "young",
                "learning card",
                "unseen",
                "buried",
                "suspended"
            ],
            "overlay": null,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "black",
            "description": "Number of cards/notes in the deck",
            "header": null,
            "name": "notes/cards",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "blue",
            "description": "Number of notes in the deck",
            "header": "Notes",
            "name": "notes",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "orange",
            "description": "Number of cards in the deck",
            "header": "Cards",
            "name": "cards",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Number of reviewed cards with interval at least 3 weeks/less than 3 weeks",
            "header": null,
            "name": "mature/young",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Number of reviewed cards which are not yet due",
            "header": null,
            "name": "undue",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Number of reviewed cards with interval at least 3 weeks",
            "header": "Mature",
            "name": "mature",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Number of reviewed cards with interval less than 3 weeks",
            "header": "Young",
            "name": "young",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "purple",
            "description": "Number of marked notes",
            "header": null,
            "name": "marked",
            "overlay": null,
            "percent": true,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "red",
            "description": "Number of notes with a leech card",
            "header": "Leeches",
            "name": "leech",
            "overlay": null,
            "percent": true,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Number of buried cards (cards you decided not to see today)/Number of suspended cards (cards you will never see unless you unsuspend them in the browser)",
            "header": null,
            "name": "buried/suspended",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Number of buried cards (cards you decided not to see today, or you saw a sibling)",
            "header": "Buried",
            "name": "buried",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "red",
            "description": "Number of suspended cards (cards you will never see unless you unsuspend them in the browser)",
            "header": "Suspended",
            "name": "suspended",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "green",
            "description": "Reviewed cards which are due tomorrow",
            "header": null,
            "name": "due tomorrow",
            "overlay": null,
            "percent": false,
            "present": true,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Flags from 0 to 4",
            "header": "Flags",
            "name": "all flags",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": null,
            "description": "Flags from 1 to 4",
            "header": "Flags",
            "name": "flags",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        },
        {
            "absolute": true,
            "color": "Red",
            "description": "Flag 1",
            "header": "Flag 1",
            "name": "flag 1",
            "overlay": null,
            "percent": false,
            "present": false,
            "subdeck": true
        }
    ],
    "default column color": "grey",
    "do color empty": true,
    "do color marked": true,
    "dot in numbers": true,
    "end symbol": ";",
    "ended marked background color": "yellow",
    "given up symbol": "/",
    "hide values of parent decks": false,
    "hide values of parent decks when subdecks are shown": false,
    "marked background color": "powderblue",
    "option": false,
    "pause symbol": "="
}
```

### FSRS Helper

```json
// FSRS Helper: 759844606
{
    "auto_disperse": true,
    "auto_disperse_after_reschedule": true,
    "auto_disperse_after_sync": true,
    "auto_disperse_when_review": true,
    "auto_easy_days": false,
    "auto_reschedule_after_review": true,
    "auto_reschedule_after_sync": true,
    "days_to_reschedule": 7,
    "debug_notify": false,
    "display_memory_state": true,
    "easy_dates": [],
    "easy_days": [
        4,
        5
    ],
    "easy_days_review_ratio": 0,
    "easy_days_review_ratio_list": [
        1,
        1,
        1,
        1,
        1,
        1,
        1
    ],
    "free_days": [
        5
    ],
    "fsrs_stats": true,
    "has_rated": false,
    "has_sponsored": false,
    "load_balance": true,
    "mature_ivl": 21,
    "reschedule_threshold": 0,
    "show_steps_stats": false,
    "skip_manual_resched_cards": false
}
```

### Markdown Input

```json
// Markdown Input: 904999275
{
    "CodeMirror": {
        "keymap": [
            {
                "key": "Mod-f",
                "preventDefault": true,
                "run": "openSearchPanel",
                "scope": "editor search-panel"
            },
            {
                "key": "Mod-n",
                "preventDefault": true,
                "run": "findNext",
                "scope": "editor search-panel",
                "shift": "findPrevious"
            },
            {
                "key": "Mod-d",
                "preventDefault": true,
                "run": "selectNextOccurrence"
            },
            {
                "key": "Mod-Shift-l",
                "preventDefault": true,
                "run": "selectSelectionMatches"
            },
            {
                "key": "Mod-g",
                "preventDefault": true,
                "run": "gotoLine"
            },
            {
                "key": "Escape",
                "preventDefault": true,
                "run": "closeSearchPanel",
                "scope": "editor search-panel"
            },
            {
                "key": "Mod-Shift-z",
                "preventDefault": true,
                "run": "clozeCurrent"
            },
            {
                "key": "Mod-Shift-c",
                "preventDefault": true,
                "run": "clozeNext"
            },
            {
                "key": "Mod-Shift-j",
                "preventDefault": true,
                "run": "joinLines"
            }
        ],
        "search": {
            "caseSensitive": false,
            "regexp": true,
            "wholeWord": false
        }
    },
    "Converter": {
        "Markdown extensions": {
            "Definition lists": true,
            "Inline media": true,
            "Strikethrough": "double",
            "Subscript": true,
            "Superscript": true,
            "Table newline": "¨",
            "Tables": "extended",
            "Underline": true
        },
        "Markdown format": {
            "bullet": "-",
            "fences": true,
            "hardBreak": "spaces",
            "listItemIndent": "one",
            "ruleRepetition": 10,
            "tightDefinitions": true
        }
    },
    "Field input": {
        "Autohide toolbar": true,
        "Cycle rich text/Markdown": true,
        "Default field state": "rich text",
        "Next field": "Ctrl+PgDown",
        "Previous field": "Ctrl+PgUp",
        "Rich text shortcut": "Ctrl+Alt+X",
        "Shortcut": "Ctrl+M+D"
    },
    "General": {
        "Browser sort field": true
    },
    "Window input": {
        "Last geometry": "AdnQywADAAAAAAAA////+AAAB38AAAQHAAAAAAAAABcAAAd/AAAEBwAAAAAAAAAAB4AAAAAAAAAAFwAAB38AAAQH",
        "Mode": "note",
        "Shortcut": "Ctrl+Alt+M",
        "Shortcut accept": "Ctrl+Return",
        "Shortcut reject": "Shift+Escape",
        "Size mode": "parent"
    }
}
```
