# VR Compatibility Requirements for Meta Quest 2 and 3 with Godot

## Overview
Based on our research, Godot Engine now has an XR edition specifically designed for Meta Quest devices. This is a significant development that makes creating VR games for Meta Quest 2 and 3 much more accessible. The Godot Editor is available on the Meta Horizon Store for Meta Quest 3 and Meta Quest Pro devices running Horizon OS version 69 or higher.

## Godot XR Edition Features
- Native editor running directly on Meta Quest devices
- Ability to create and develop 2D, 3D, and immersive XR apps
- Hybrid app with panel (2D) and immersive (XR) windows
- Support for keyboard, mouse, touch controllers, and direct touch
- Seamless multitasking for live editing and debugging
- Panel resizing and Theater View support

## Performance Considerations for Meta Quest
When developing for standalone XR devices like Meta Quest 2 and 3, consider these performance guidelines:

1. **Renderer Selection**
   - Use the compatibility renderer for better performance on standalone devices
   - Mobile renderer is available in Godot 4.3+ but still needs optimization

2. **Screen Effects**
   - Avoid screen space effects like glow, DOF, etc.
   - Disable auto-enabled glow as it turns off various optimizations

3. **Rendering Optimizations**
   - Use foveated rendering (set Foveation level to high and enable Foveation dynamic)
   - For Mobile renderer, enable VRS with: `get_viewport().vrs_mode = Viewport.VRS_XR`
   - Use MSAA x2 in Godot 4.3+ (practically free on mobile GPUs)

4. **Texture and Material Optimizations**
   - Avoid reading from screen texture or depth texture
   - Avoid effects like refraction on materials
   - Optimize materials by converting to shader materials when needed
   - Limit texture usage per material (combine roughness, metallic, and AO into one texture)
   - Calculate UVs in vertex shader instead of fragment shader

5. **Lighting Considerations**
   - Avoid excessive lights and shadows (very expensive on mobile hardware)
   - Bake lighting when possible
   - Use single spotlight for player flashlight
   - Use omni lights only with static shadow buffers

## Setup Requirements
For developing VR applications for Meta Quest 2 and 3 with Godot:

1. **Godot Version**
   - Use Godot 4.x (preferably 4.2.1 or newer)
   - Choose the GLES2/Compatibility renderer for better performance

2. **Required Plugins**
   - OpenXR plugin for Godot
   - Android export template

3. **Export Settings**
   - Set XR Mode to "Oculus Mobile VR"
   - Set Degrees of Freedom mode to "6DOF"
   - Configure proper Android export settings

4. **Development Workflow Options**
   - Traditional: Develop on PC and export to Quest
   - Native: Use Godot XR Edition directly on Quest devices

## Testing and Deployment
- Enable developer mode on Meta Quest devices through the Oculus app
- Connect Quest to PC with USB cable for deployment
- Test performance regularly on the actual device

## Resources
- Godot XR Edition on Meta Horizon Store: https://www.meta.com/experiences/godot-game-engine/7713660705416473/
- Godot documentation for VR development
- Performance considerations for standalone XR: https://forum.godotengine.org/t/performance-considerations-for-stand-alone-xr/52324
