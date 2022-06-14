#version 330 core

out vec4 FragColor;

in vec3 aCol;
in vec3 aPos;
in vec3 aNormal;

uniform vec3 viewPos;

void main()
{
    //-------------------------------------------
    // Light Init
    vec3 light_position = vec3(15.0, 30.0, -15.0);
    vec3 light_ambient  = vec3(1.0, 1.0, 1.0);
    vec3 light_color  = vec3(1.0, 1.0, 1.0);

    //-------------------------------------------
    // Light Calculation
    vec3 norm = normalize(aNormal);
    vec3 lightDir = normalize(light_position - aPos);

    //-------------------------------------------
    // Light Ambient
    float ambientStrength = 0.1;
    vec3 ambient = ambientStrength * light_ambient;

    //-------------------------------------------
    // Light Diffuse
    float diff = max(dot(norm, lightDir), 0.0);
    vec3 diffuse = diff * light_color;

    //-------------------------------------------
    // Light Specular
    float specularStrength = 0.8;
    vec3 viewDir = normalize(viewPos-aPos);
    vec3 reflectDir = reflect(-lightDir,norm);
    float spec = pow(max(dot(viewDir,reflectDir),0.0), 100);
    vec3 specular = specularStrength*spec*light_color;


    //-------------------------------------------
    // Light Final Result
    vec3 result = (ambient + diffuse + specular) * vec3(1.0, 0.0, 0.0);
    // vec3 result = (ambient + diffuse + specular) * aCol;

    

    FragColor = vec4(result, 1.0f);
    // FragColor = vec4(norm, 1.0f);
}