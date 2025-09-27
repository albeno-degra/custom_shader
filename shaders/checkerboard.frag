precision mediump float;

uniform vec2 uSize;
uniform vec3 uColor1;
uniform vec3 uColor2;

out vec4 fragColor;

void main() {
    vec2 pos = floor(gl_FragCoord.xy / uSize);
    bool isEven = mod(pos.x + pos.y, 2.0) < 1.0;

    vec3 color = isEven ? uColor1 : uColor2;
    fragColor = vec4(color, 1.0);
}
