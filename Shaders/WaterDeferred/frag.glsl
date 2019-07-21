#version 330

layout(location = 0) out vec3 OutNormal;

in vec3 Position; 
in vec3 Normal; 
in vec2 TexCoord; 


uniform sampler2DArray NormalMap; 
uniform float Time; 
uniform vec3 CameraPosition; 

vec4 SampleInterpolatied(sampler2DArray Sampler,vec3 Coord) {

	float BaseTime = mod(Coord.z, 119.); 

	int Coord1 = int(floor(BaseTime)); 
	int Coord2 = int(ceil(BaseTime))%119; 

	return mix(texture(Sampler, vec3(Coord.xy, Coord1)), texture(Sampler,vec3(Coord.xy, Coord2)), fract(BaseTime)); 


}

void main() {

	vec2 ActualTexCoord = ((TexCoord*2.-1.)+CameraPosition.xz*0.01) * 100.; 

	vec3 NormalSample  = SampleInterpolatied(NormalMap, vec3(ActualTexCoord,mod(Time*12.0, 119.))).xyz * vec3(2.0,1.0,2.0) - vec3(1.0,0.0,1.0); 
	NormalSample.y = 1.0; 
	NormalSample.xz *= 0.15; 
	OutNormal = normalize(mix(NormalSample, vec3(0.0,1.0,0.0),0.5)); 
}