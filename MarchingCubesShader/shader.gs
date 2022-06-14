#version 330 core

layout (points) in;
layout (triangle_strip, max_vertices = 16) out;

uniform mat4 view;
uniform mat4 projection;

uniform samplerBuffer triTable;

in VS_OUT {
    vec4 f0123;
    vec4 f4567;
    uint mc_case;
    vec3 aCol;
	vec3 aPos;
	vec3 aNormal;
} gs_in[];

out vec3 aCol;
out vec3 aPos;
out vec3 aNormal;

vec3 setVertex(int index) {
	vec4 position = gl_in[0].gl_Position;

	vec4 move;
	
	if (index == 0) gl_Position = position + projection * view * vec4(0.5, 0.0, 0.0, 1.0);
	if (index == 1) gl_Position = position + projection * view * vec4(1.0, 0.0, 0.5, 1.0);
	if (index == 2) gl_Position = position + projection * view * vec4(0.5, 0.0, 1.0, 1.0);
	if (index == 3) gl_Position = position + projection * view * vec4(0.0, 0.0, 0.5, 1.0);
	if (index == 4) gl_Position = position + projection * view * vec4(0.5, 1.0, 0.0, 1.0); 
	if (index == 5) gl_Position = position + projection * view * vec4(1.0, 1.0, 0.5, 1.0);
	if (index == 6) gl_Position = position + projection * view * vec4(0.5, 1.0, 1.0, 1.0);
	if (index == 7) gl_Position = position + projection * view * vec4(0.0, 1.0, 0.5, 1.0);
	if (index == 8) gl_Position = position + projection * view * vec4(0.0, 0.5, 0.0, 1.0);
	if (index == 9) gl_Position = position + projection * view * vec4(1.0, 0.5, 0.0, 1.0); 
	if (index == 10) gl_Position = position + projection * view * vec4(1.0, 0.5, 1.0, 1.0);
	if (index == 11) gl_Position = position + projection * view * vec4(0.0, 0.5, 1.0, 1.0);

	vec4 new_position = gl_Position;
	
	EmitVertex();

	aPos = gs_in[0].aPos;

	return new_position.xyz;
}

void setTriangle(int a, int b, int c, int i) {
	vec3 p[3];

	p[0] = setVertex(a);
	p[1] = setVertex(b);
	p[2] = setVertex(c);

	aNormal = gs_in[0].aNormal;

	EndPrimitive();
}

void main()
{
	int config = int(gs_in[0].mc_case);

	if (config == 0 || config == 255) {
		return;
	}

	aCol = gs_in[0].aCol;

	int e[16];

	for (int i = 0; i < 16; i++) {
		e[i] = int(texelFetch(triTable, 16 * config + i).x);
	}

	for (int i = 0; i < 16; i += 3) {
		if (e[i] == -1) return;

		setTriangle(e[i], e[i + 1], e[i + 2], i);
	}
}