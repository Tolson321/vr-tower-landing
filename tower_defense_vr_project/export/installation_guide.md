# Tower Defense VR - Installation Guide

## Requirements
- Meta Quest 2 or Meta Quest 3 headset
- Godot 4.2.1 or later (for development)
- SideQuest (for sideloading the APK)

## Installation Steps

### For Players
1. Enable Developer Mode on your Meta Quest headset
   - Install the Oculus/Meta app on your smartphone
   - Connect your headset to the app
   - Navigate to Settings > Developer and enable Developer Mode

2. Install SideQuest on your computer
   - Download from https://sidequestvr.com/
   - Install and run the application

3. Connect your Meta Quest to your computer
   - Use a USB-C cable
   - Accept the USB debugging prompt in your headset

4. Install the APK using SideQuest
   - In SideQuest, click "Install APK from folder"
   - Navigate to the tower_defense_vr.apk file
   - Select and install

5. Launch the game
   - In your Meta Quest, go to Apps > Unknown Sources
   - Find and select "Tower Defense VR"

### For Developers
1. Clone the repository
   - `git clone https://github.com/yourusername/tower_defense_vr.git`
   - `cd tower_defense_vr`

2. Open the project in Godot
   - Launch Godot 4.2.1
   - Select "Import" and navigate to the project folder
   - Open the project.godot file

3. Configure Android export
   - Install Android Build Template
   - Configure Android SDK path in Editor Settings
   - Set up keystore for signing

4. Export the project
   - Go to Project > Export
   - Select Android/Meta Quest preset
   - Click "Export Project"
   - Save as tower_defense_vr.apk

5. Test on device
   - Follow the player installation steps above

## Troubleshooting

### Common Issues
- **Black screen on launch**: Ensure OpenXR is properly configured
- **Low performance**: Check that performance optimization is enabled
- **Controller not detected**: Restart the game and ensure controllers are paired
- **Game crashes**: Check logs in SideQuest for error details

### Support
For additional support, please file an issue on the GitHub repository or contact the developer directly.
