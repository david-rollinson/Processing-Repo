#ifdef GL_ES
//GL_ES has comparably lower float and int precision than its 'GL' standalone counterpart.

precision mediump float;
precision mediump int;
#endif

uniform sampler2D texture;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;

varying vec4 vertTexCoord;

void main() {
  float intensity = max(0.0, dot(vertLightDir, vertNormal));
  gl_FragColor = intensity * texture2D(texture, vertTexCoord.st);
}
