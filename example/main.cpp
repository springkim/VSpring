#include<iostream>
#include<opencv2/opencv.hpp>
#include<VSpring>
int main() {
	std::cout << "hello, world" << std::endl;
	cv::Mat img = cv::imread("../../kakao.jpg");
	cv::imshow("img", img);
	cv::waitKey();
	cv::destroyAllWindows();
	return EXIT_SUCCESS;
}