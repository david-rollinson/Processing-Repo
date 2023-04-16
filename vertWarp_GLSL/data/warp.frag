#ifdef GL_ES
//GL_ES has comparably lower float and int precision than its 'GL' standalone counterpart.

precision mediump float;
precision mediump int;
#endif

flat in int _index; 

uniform sampler2D texture;

varying vec4 vertColor;
varying vec3 vertNormal;
varying vec3 vertLightDir;
varying vec4 vertTexCoord;

void main() {
  //float intensity = max(0.0, dot(vertLightDir, vertNormal));
  //gl_FragColor = intensity * texture2D(texture, vertTexCoord.st);
  //gl_FragColor = texture2D(texture, vertTexCoord.st);
  if(mod(_index, 8) == 0){
  //colour vertices red if they satisfy mod condition.
    gl_FragColor = vec4(1.0,0,0,1.0);
  } else if (mod(_index, 8) == 1) {
    gl_FragColor = vec4(1.0,0,0,1.0);
  } else if (mod(_index, 8) == 2) {
    gl_FragColor = vec4(1.0,0,0,1.0);
  }else if (mod(_index, 8) == 3) {
    gl_FragColor = vec4(1.0,0,0,1.0);
  } else {
    gl_FragColor = vec4(0,0,1.0,1.0);
  }
}
