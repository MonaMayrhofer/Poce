//
// Created by obyoxar on 15.08.18.
//

#ifndef POCEEXP_O_SHADER_H
#define POCEEXP_O_SHADER_H


#include <fstream>
#include "glwrap.h"


enum ShaderType {
    VERTEX_SHADER = GL_VERTEX_SHADER,
    FRAGMENT_SHADER = GL_FRAGMENT_SHADER,
    GEOMETRY_SHADER = GL_GEOMETRY_SHADER,
    COMPUTE_SHADER = GL_COMPUTE_SHADER
};

class Shader {
public:
    explicit Shader(std::string sourceFilePath, ShaderType type);
    bool isGood() const;
    const GLuint getGLShaderReference() const;

private:
    bool compile();
    GLuint shader;
    const std::string path;
    std::string source;
    bool good = false;
};


#endif //POCEEXP_O_SHADER_H
