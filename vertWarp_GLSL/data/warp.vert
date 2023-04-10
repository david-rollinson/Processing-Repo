uniform mat4 projection;
uniform mat4 modelview;
uniform mat3 normalMatrix;
uniform vec3 lightNormal;

uniform float offset;
uniform float scale;

attribute vec4 position;
attribute vec4 color;
attribute vec2 offset1;
attribute vec3 normal;
attribute vec2 texCoord;

varying vec2 fragTexCoord;
varying vec4 vertTexCoord;
varying vec3 vertNormal;
varying vec3 vertLightDir;

void main() {

  vec3 posOffset = position.xyz;
  
  //multiply the position of each vertex to expand the model. 
  posOffset = posOffset * scale;
  //flip upside down.
  posOffset.y = posOffset.y * -1;
  //reset the .w perspective component (default 1.0).
  //posOffset.w = 1.0; //abs(sin(offset));
  
  posOffset.y += 10. * sin(offset + posOffset.y);
  posOffset.x -= 10. * sin(offset + posOffset.x);
  
  vec4 pos = modelview * vec4(posOffset, 1.0);

  gl_Position = projection * pos; 
  
  vertNormal = normalize(normalMatrix * normal);
  vertLightDir = -lightNormal;
  vertTexCoord = vec4(texCoord, 1.0, 1.0);
}
