//
// Created by obyoxar on 28.08.18.
//

#ifndef POCEEXP_VIDEO_TEXTURE_H
#define POCEEXP_VIDEO_TEXTURE_H


#include <opencv2/core/types.hpp>
#include "Buffer.h"
#include "Texture.h"
#include "VideoSource.h"

class VideoTexture {
public:
    explicit VideoTexture();
    ~VideoTexture();

    void setUniformToUnit(GLuint uniformLoc);

    void update();
    const cv::Mat getMat() const;

private:
    VideoSource videoSource;
    Buffer<uchar> pixelBuffer;
    Texture<uchar> texture;
    bool firstFill = true;
};


#endif //POCEEXP_VIDEO_TEXTURE_H