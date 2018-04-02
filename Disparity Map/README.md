# Stereo - Disparity Mapping 

Objective - Given the stereo pair of two scan-line aligned images (tsukuba_l.png and tsukuba_r.png) compute the disparity map of 
the stereo pair. 

Input Image:

Left Image

![Left Image](https://github.com/rohit517/ENPM673-Perception/blob/master/Disparity%20Map/tsukuba_l.png)

Right Image

![Right Image](https://github.com/rohit517/ENPM673-Perception/blob/master/Disparity%20Map/tsukuba_r.png)

## Getting Started

The code is written in MATLAB. Run the main.m matlab file implementing the program. 

## Output Image

Window Size = 3 and Max Disparity = 16
Left Image is SSD and right Image is SAD

![Output Image](https://github.com/rohit517/ENPM673-Perception/blob/master/Disparity%20Map/Output/u3_16.png)

Window Size = 5 and Max Disparity = 16

![Output Image](https://github.com/rohit517/ENPM673-Perception/blob/master/Disparity%20Map/Output/u5_16.png)

Window Size = 9 and Max Disparity = 16

![Output Image](https://github.com/rohit517/ENPM673-Perception/blob/master/Disparity%20Map/Output/u9_16.png)

Window Size = 15 and Max Disparity = 16

![Output Image](https://github.com/rohit517/ENPM673-Perception/blob/master/Disparity%20Map/Output/u15_16.png)

## Comments

Here we have two scan-line aligned images for which we must compute the disparity map. As shown from the disparity maps below, 
for a given technique, we can change the window size and the max disparity size. SSD as a patch similarity has been used. 
I have also used adaptive choice of window and SAD as a different similarity measure to compare the results and to show how 
changing these parameters affects the output. This leads to some interesting results shown below:

## Author

* **Rohitkrishna Namnbiar**  - [rohit517](https://github.com/rohit517)

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

I would like to thank the course faculty and TA's for their guidance and support. 
