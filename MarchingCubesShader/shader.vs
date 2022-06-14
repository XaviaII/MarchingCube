#version 330 core

layout (location = 0) in vec3 aPos;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

uniform float dlimit;

uniform sampler3D noise3D;

out VS_OUT {
    vec4 f0123;
    vec4 f4567;
    uint mc_case;
    vec3 aCol;
    vec3 aPos;
    vec3 aNormal;
} vs_out;

void main()
{
    gl_Position = projection * view * model * vec4(aPos, 1.0f);
    vs_out.aPos = vec3(model * vec4(aPos, 1.0f));

    float step = (1.0 / 20.0);
    vec3 texPos = aPos / 20.0;

    //vs_out.aCol = vec3(round(texture(noise3D, texPos).r));
    vs_out.aCol = texture(noise3D, texPos).rrr;
    
    vs_out.f0123 = vec4(   texture(noise3D, texPos).x,
                           texture(noise3D, texPos + vec3(step, 0.0, 0.0)).x,
                           texture(noise3D, texPos + vec3(step, 0.0, step)).x,
                           texture(noise3D, texPos + vec3(0.0, 0.0, step)).x    );

    vs_out.f4567 = vec4(   texture(noise3D, texPos + vec3(0.0, step, 0.0)).x,
                           texture(noise3D, texPos + vec3(step, step, 0.0)).x,
                           texture(noise3D, texPos + vec3(step, step, step)).x,
                           texture(noise3D, texPos + vec3(0.0, step, step)).x    );

    vec3 normal = vec3(
        texture(noise3D, texPos + vec3(-step, 0.0, 0.0)).x - texture(noise3D, texPos + vec3(step, 0.0, 0.0)).x,
        texture(noise3D, texPos + vec3(0.0, -step, 0.0)).x - texture(noise3D, texPos + vec3(0.0, step, 0.0)).x,
        texture(noise3D, texPos + vec3(0.0, 0.0, -step)).x - texture(noise3D, texPos + vec3(0.0, 0.0, step)).x
    );

    vs_out.aNormal = normalize(normal);

    float f0, f1, f2, f3, f4, f5, f6, f7;

    if (vs_out.f0123.x > dlimit)  f0 = 1;
    else  f0 = 0;
    if (vs_out.f0123.y > dlimit)  f1 = 1;
    else  f1 = 0;
    if (vs_out.f0123.z > dlimit)  f2 = 1;
    else  f2 = 0;
    if (vs_out.f0123.w > dlimit)  f3 = 1;
    else  f3 = 0;
    if (vs_out.f4567.x > dlimit)  f4 = 1;
    else  f4 = 0;
    if (vs_out.f4567.y > dlimit)  f5 = 1;
    else  f5 = 0;
    if (vs_out.f4567.z > dlimit)  f6 = 1;
    else  f6 = 0;
    if (vs_out.f4567.w > dlimit)  f7 = 1;
    else  f7 = 0;

    uint n0 = uint(f0);
    uint n1 = uint(f1);
    uint n2 = uint(f2);
    uint n3 = uint(f3);
    uint n4 = uint(f4);
    uint n5 = uint(f5);
    uint n6 = uint(f6);
    uint n7 = uint(f7);

    vs_out.mc_case = n0;
    vs_out.mc_case += n1 * uint(2);
    vs_out.mc_case += n2 * uint(4);
    vs_out.mc_case += n3 * uint(8);
    vs_out.mc_case += n4 * uint(16);
    vs_out.mc_case += n5 * uint(32);
    vs_out.mc_case += n6 * uint(64);
    vs_out.mc_case += n7 * uint(128);
}