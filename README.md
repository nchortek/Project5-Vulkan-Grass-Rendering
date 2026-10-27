Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

* Nathan Chortek
  * [LinkedIn](https://www.linkedin.com/in/nathan-chortek/), [personal website](https://www.nathanchortek.com/)
* Tested on: Windows 11, AMD Ryzen AI 9 HX 370, NVIDIA GeForce RTX 5090 Laptop GPU

TODO: cover gif

## Features Implemented

In this project, we set up a Vulkan rendering pipeline that simulates a field of grass. Each frame a compute shader runs that simulates the forces acting on each grass blade
and determines which blades should be rendered. Tessellation shaders are used to construct geometry for the blades, and indirect drawing is used for rendering.

### Representing Grass as Bezier Curves

Each blade is represented as a Bezier curve with three control points: `v0`, `v1`, and `v2`. Combined with an `up` vector and four floats representing orientation, height,
width, and stiffness, we have everything needed for tessellation and force simulation.

![](img/blade_model.jpg)

### Simulating Forces

**Gravity**

Given a gravity direction, `D.xyz`, and the magnitude of acceleration, `D.w`, we compute the environmental gravity in our scene as `gE = normalize(D.xyz) * D.w`. We then 
determine the contribution of the gravity with respect to the front facing direction of the blade, `f`, as a term called the "front gravity". Front gravity is computed as 
`gF = (1/4) * ||gE|| * f`. We can then determine the total gravity on the grass blade as `g = gE + gF`.

TODO: gif

**Recovery**

Recovery corresponds to the counter-force that brings our grass blade back into equilibrium. This is derived in the paper using Hooke's law. In order to determine the recovery 
force, we need to compare the current position of `v2` to its original position before simulation started, `iv2`. At the beginning of our simulation, `v1` and `v2` are 
initialized to be a distance of the blade height along the `up` vector. Once we have `iv2`, we can compute the recovery forces as `r = (iv2 - v2) * stiffness`.

TODO: gif

**Wind**

Animated Perlin noise is used to form a wind vector field, taking a blade's XZ position as input. Once we have a wind direction, we determine a wind alignment term based on how
perpendicular the blade is to the wind direction, and total wind force (`w`) is calculated as `windDirection * windAlignment`.

TODO: gif

### Culling

**Orientation**

Blades that are parallel to the wind direction are barely visible, so we cull blades for which the dot product of the view direction and the blade's front face direction is less
than `0.9`.

TODO: gif

**View-frustum**

We also cull blades that are outside of the view-frustum, considering they won't show up in the frame anyway. To determine if a grass blade is in the view-frustum, we compare the
visibility of three points: `v0, v2, and m`, where `m = (1/4)v0 * (1/2)v1 * (1/4)v2`. If all three points are outside of the view-frustum, we cull the grass blade.

TODO: gif

**Distance**

The further a blade is from the camera, the less visible it will be to the user. With this in mind, we place blades into buckets based on their distance from the camera, and apply
stochastic culling at increasing rates proportional to distance from the camera.

TODO: gif

## Performance Analysis

TODO

### Frame Time vs Blade Count

TODO

### Impact of Culling

TODO
