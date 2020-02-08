

# Music Genre Recognition using Deep Learning

## Description 

This is project "Music Genre Recognition using Deep Learning" developed by Sina Shahsavari, Arash Asghari, Hadi Givehchian, Abhilash Kasarla and Kishore Venkatswammy.

## Abstract 
Music genre recognition has been successfully explored over the last years and recently there has been increasing interest in applying deep learning approaches to tackle this problem. However, most of the proposed architecture are suited only for short music tracks and does not work well for longer tracks. In this paper, we propose a solution to mitigate this problem by introducing a segmentation algo- rithm which can extract useful information in a long au- dio sequences. We also introduce a novel modification to a RNN layer that can achieve the effect of regularization. We explore transfer learning, segmentation and RNN based approaches to music classification.


## For more details please read our final paper 
- https://github.com/Sinashahsavari/Music-Genre-Recognition/blob/master/Final%20Paper.pdf

## Requirements and Usage
### Dependencies
* [Python 3.6+](https://www.continuum.io/downloads)
* [Keras] 


<br/>

### Downloading the [GTZAN](http://marsyas.info/downloads/datasets.html ) dataset

## Code organization 

### experiment1 and experiment2

 - 	Artists1517Excerpt.m: Segment the input music track to small pieces
 - 	Artists1517Segment.m: Extrct STFT features of each segment and use spectral graph clustering methods to cluster similar segments 
 - vgg16_extended_ballroom_224x224x3.ipynb: Extracting Running VGG16 on segmented 
 





