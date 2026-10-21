#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4 inV1[];
layout(location = 1) in vec4 inV2[];
layout(location = 2) in vec4 inUp[];

const float debugSize = 0.2;
const vec3 zAxis = vec3(0.0, 0.0, 1.0);

void main() {
    vec4 inV0 = gl_in[0].gl_Position;

    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// TODO: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade
    vec3 pos = inV0.xyz + (((u - 0.5) * normalize(cross(zAxis, inUp[0].xyz))) + (v * inUp[0].xyz)) * debugSize;
    gl_Position = camera.proj * camera.view * vec4(pos, 1.0);
}