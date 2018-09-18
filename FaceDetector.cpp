#include <utility>

//
// Created by obyoxar on 01.09.18.
//
#include "monitoring.h"
#include "FaceDetector.h"
#include <opencv2/highgui.hpp>

FaceDetector::FaceDetector(std::string modelPath) : pose_model(){
    deserialize(modelPath) >> pose_model;
}

FaceDetector::~FaceDetector() = default;;

std::vector<FaceDetector::Rect> FaceDetector::detectOutlines(cv_image<rgb_pixel> image) {
    std::vector<rectangle> rectangles = detector(image);
    return rectangles;
}

std::vector<FaceDetector::Point> FaceDetector::detectNoses(cv::Mat image, cv::Size viewSize) {
    cv::Mat scaled;
    cv::resize(image, scaled, viewSize);
    cv_image<rgb_pixel> dlibImage(scaled);
    auto detections = this->detectOutlines(dlibImage);
    std::vector<FaceDetector::Point> noses(detections.size());
    auto noseIterator = noses.begin();
    for (const auto &face : detections){
        full_object_detection detection = pose_model(dlibImage, face);
        dlib::point noseTip = detection.part(28);
        *(noseIterator++) = FaceDetector::Point(
                noseTip.x() / (float)viewSize.width,
                noseTip.y() / (float)viewSize.height
                );
    }
    return noses;
}

