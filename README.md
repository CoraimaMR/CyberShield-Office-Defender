# CyberShield-Office-Defender
Godot 2D Cibersecurity game
------------------------------------------------------------------------

## 🎯 Project Overview

**Title:** CyberShield: Office Defender\
**Genre:** Serious Game / Interface Simulation / Puzzle\
**Platform:** PC (Desktop) -- Developed in Godot 4.6\
**Target Audience:** Corporate employees and students (cybersecurity
awareness)\
**Elevator Pitch:** A desktop simulation game where you must identify
phishing emails before your network gets compromised.\
**Session Duration:** 10--15 minutes

CyberShield: Office Defender is designed as an educational serious game
focused on improving phishing detection skills in a realistic
office-like environment.

------------------------------------------------------------------------

## 🎮 Core Gameplay Mechanics

### Main Gameplay Loop

1.  **Reception:** A new email appears on screen (with a notification
    sound "Ping").
2.  **Analysis:** The player reads the sender, subject, and body of the
    message.
3.  **Decision:** The player selects one of three actions:
    -   ✅ **Validate** -- Mark the email as safe.
    -   ⚠️ **Report to IT** -- Identify it as phishing.
    -   🗑️ **Delete** -- Discard harmless spam.
4.  **Feedback:** A popup window informs the player whether they were
    correct and explains why.

------------------------------------------------------------------------

## 📊 Scoring System

### Network Health

-   Starts with **3 Health Points** (displayed as a progress bar).
-   Each mistake reduces 1 health point.
-   If health reaches 0 → **Game Over** (Ransomware activated).

### Points

-   Correct answer: **+10 points**
-   Correct phishing report: **+20 points**
-   Incorrect action: **-5 points**

------------------------------------------------------------------------

## 🏆 Win & Lose Conditions

-   **Victory:** Successfully process 15 emails without losing all
    network health.
-   **Defeat:** Network health reaches 0.

------------------------------------------------------------------------

## 📈 Level Design & Difficulty Progression

The game features **15--20 emails** with increasing difficulty:

  ------------------------------------------------------------------------
  Email Range                  Attack Type                Clues
  ---------------------------- -------------------------- ----------------
  1--5                         Basic Phishing             Obvious spelling
                                                          mistakes, absurd
                                                          domains

  6--10                        Social Engineering         Urgency/fear
                                                          tactics,
                                                          alarmist
                                                          language

  11--15                       Spear Phishing             Convincing
                                                          impersonation,
                                                          credible
                                                          technical
                                                          details

  16--20                       Legitimate Emails          Randomly mixed
                                                          in to increase
                                                          difficulty
  ------------------------------------------------------------------------

------------------------------------------------------------------------

## 🏗️ Technical Architecture

### Scene Node Hierarchy (UI Control)

    Control (MainScene)
    ├── ColorRect (Background)
    ├── Panel (Email Window)
    │   ├── MarginContainer
    │   │   └── VBoxContainer
    │   │       ├── Label (Sender)
    │   │       ├── Label (Subject)
    │   │       ├── RichTextLabel (Body)
    │   │       └── HBoxContainer (Buttons)
    │   │           ├── Button "✅ Validate"
    │   │           ├── Button "⚠️ Report"
    │   │           └── Button "🗑️ Delete"
    ├── HUD (CanvasLayer)
    │   ├── ProgressBar (Health)
    │   └── Label (Score)
    └── PopupPanel (Feedback)
        └── VBoxContainer
            ├── Label (Title)
            ├── RichTextLabel (Explanation)
            └── Button "Continue"

------------------------------------------------------------------------

### Email Data System (Simplified)

``` gdscript
var emails = [
    {
        "sender": "hr@company.com",
        "subject": "Payroll Update",
        "body": "Dear employee, please find attached your payslip...",
        "is_phishing": false,
        "explanation": "Legitimate email from the internal HR department."
    },
    {
        "sender": "security@b4nk.com",
        "subject": "URGENT: Account Verification Required",
        "body": "Your account will be suspended within 24h...",
        "is_phishing": true,
        "explanation": "Suspicious domain (b4nk instead of bank). Urgency tactic."
    }
]
```

------------------------------------------------------------------------

### Component Communication

``` gdscript
signal email_processed(correct: bool)
signal health_changed(new_health: int)
signal game_over(final_score: int)
```

------------------------------------------------------------------------

## 🎨 Visual & Audio Design

### Visual Style

-   **Style:** Minimalist "Modern Office"
-   **Color Palette:**
    -   Background: #E0E0E0
    -   Panel: #FFFFFF
    -   Success: #4CAF50
    -   Error: #F44336
    -   Alert: #FF9800
-   **Typography:** Roboto / Open Sans

### Audio Design

-   Email notification: Soft "Ping"
-   Correct answer: Short positive "Ding"
-   Error: System alert sound
-   Game Over: Critical system failure sound

------------------------------------------------------------------------

## 👥 Development Team

-   Adrian\
-   Luis\
-   Sergio\
-   Coraima

------------------------------------------------------------------------

## 🎯 MVP Scope (Minimum Viable Product)

### Core Features ✅

-   Sequential email display
-   Three functional action buttons with correct logic
-   Visible scoring system
-   Health bar that decreases on mistakes
-   Game Over screen
-   15--20 varied emails
-   Explanatory feedback after each decision
-   Email notification sound

### Nice-to-Have Features ⭐

-   Start screen with instructions
-   Basic transition animations
-   Background ambient music
-   Final statistics screen (% accuracy)

### Out of Scope ❌

-   Save/Load system
-   Selectable multiple levels
-   Interactive attachments
-   Multiplayer
-   Mobile support

------------------------------------------------------------------------

## 🔧 Development Tools

-   **Engine:** Godot 4.6\
-   **Language:** GDScript\
-   **Version Control:** Git + GitHub\
-   **Audio Resources:** Freesound.org\
-   **Fonts:** Google Fonts (Open Sans, Roboto)

------------------------------------------------------------------------

## 📌 Educational Purpose

CyberShield: Office Defender aims to improve cybersecurity awareness by
simulating real-world phishing scenarios in a controlled and interactive
environment. The game encourages critical thinking and safe
email-handling practices in professional contexts.
