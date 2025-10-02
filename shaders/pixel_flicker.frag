precision mediump float;

uniform vec3 uStainColor;
uniform vec3 uBaseColor;
uniform float uSize;
uniform float uTime;

out vec4 fragColor;

void main() {
vec2 pos = floor(gl_FragCoord.xy / uSize) * uSize + uSize * 0.5;
vec2 offset = gl_FragCoord.xy - pos;
float noise = fract(sin(dot(pos, vec2(12.9898, 78.233))) * 43758.5453);
float flicker = 0.7 + 0.3 * sin(uTime * 5.0 + noise * 6.28);
vec3 color = mix(uBaseColor, uStainColor, flicker);
fragColor = vec4(color, 1.0);
}
