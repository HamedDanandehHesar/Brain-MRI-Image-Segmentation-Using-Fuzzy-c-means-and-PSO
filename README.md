:::
# Brain MRI Segmentation using Fuzzy C‑Means Optimized by Particle Swarm Optimization (FCM‑PSO)

A MATLAB implementation for **automatic brain MRI tissue segmentation** using a hybrid **Fuzzy C‑Means (FCM)** clustering algorithm optimized with **Particle Swarm Optimization (PSO)**.

The algorithm segments brain MRI images into major anatomical tissue classes:

- **CSF (Cerebrospinal Fluid)**
- **Gray Matter (GM)**
- **White Matter (WM)**

The approach combines the **soft clustering capability of FCM** with the **global optimization ability of PSO** to obtain more robust segmentation results compared to conventional FCM.

---

# Overview

Brain MRI segmentation is an essential step in many medical imaging applications such as:

- neurological disease diagnosis
- brain volume estimation
- tumor detection
- tissue analysis

Traditional segmentation methods often rely on thresholding or standard clustering algorithms. However, MRI images typically suffer from:

- noise
- intensity inhomogeneity
- overlapping tissue intensities

To address these challenges, this project applies **Fuzzy C‑Means clustering enhanced with Particle Swarm Optimization**.

The hybrid method improves clustering stability and helps avoid poor local minima often encountered in conventional FCM.

---

# Key Features

- Automatic **brain MRI segmentation**
- Hybrid **FCM + PSO clustering**
- Soft clustering using **fuzzy membership functions**
- Identification of major brain tissues:
  - CSF
  - Gray Matter
  - White Matter
- Visualization of **binary tissue masks**
- Generation of **color‑coded segmentation map**

---

# Input Image

The program accepts **MRI images in JPG format**.

Example input workflow:

```matlab
[file, path] = uigetfile('*.jpg','Select MRI image');
Img = imread([path '\' file]);
```

If the image is RGB, it is converted to grayscale:

```matlab
Gray_Scale = rgb2gray(Img);
```

The grayscale image is then reshaped into a vector for clustering:

```matlab
Inputs = Input_Img(:);
Inputs = double(Inputs);
```

---

# Algorithm Pipeline

The segmentation framework follows the steps below.

---

# 1. Image Preprocessing

The MRI image is converted to grayscale (if necessary) and stored as a matrix:

```
Input_Img
```

For clustering, the image pixels are converted into a vector:

```
Inputs = Input_Img(:)
```

Each pixel intensity becomes a data sample for the clustering algorithm.

---

# 2. Hybrid FCM‑PSO Clustering

The algorithm uses **Particle Swarm Optimization** to improve the initialization and convergence of the **Fuzzy C‑Means clustering algorithm**.

### Key Parameters

```
Number_of_Clusters = 4
Fuzziness_q = 2
MaxIteration = 30
Population Size = 12
Intensity Range = [0 , 255]
```

These parameters define the PSO search process and the FCM clustering behavior.

---

# 3. Particle Swarm Optimization

Each particle in PSO represents a **candidate fuzzy membership matrix**.

During each iteration, particles update their position and velocity based on:

- personal best solution
- global best solution

The PSO update rule follows:

```
v = w*v + c1*r1*(pbest - x) + c2*r2*(gbest - x)
```

where:

- `v` = particle velocity
- `x` = particle position
- `pbest` = personal best solution
- `gbest` = global best solution
- `w` = inertia weight
- `c1`, `c2` = learning coefficients

PSO searches for membership matrices that minimize the **FCM clustering objective function**.

---

# 4. Fuzzy C‑Means Membership Update

For each particle, the FCM algorithm updates:

- cluster centers
- fuzzy membership matrix

Each pixel has a **membership value for each cluster**, allowing soft classification.

The fuzziness parameter:

```
q = 2
```

controls how strongly pixels belong to multiple clusters.

---

# 5. Cluster Label Assignment

After convergence, each pixel is assigned to the cluster with **maximum membership value**.

Cluster centers are sorted in ascending order:

```matlab
[ClusterCenters,ind] = sort(ClusterCenters,'ascend');
```

The cluster labels are then reconstructed into the original image size:

```
Label = reshape(Label,[S1,S2])
```

---

# 6. Brain Tissue Extraction

The clusters correspond to different brain tissues.

In this implementation:

```
Cluster 2 → CSF
Cluster 3 → Gray Matter
Cluster 4 → White Matter
```

Binary masks are generated:

```
CSF_binary
GM_binary
WM_binary
```

These masks isolate the corresponding tissue regions.

---

# 7. Visualization of Segmentation Results

The algorithm produces several visual outputs.

### Binary tissue segmentation

- CSF mask
- Gray matter mask
- White matter mask

Displayed as:

```
CSF Binary
Gray Matter Binary
White Matter Binary
```

---

### Color‑coded segmentation

A color map is generated to visualize tissues simultaneously.

Color assignment:

```
Red   → CSF
Green → White Matter
Blue  → Gray Matter
```

Example visualization:

```
Original MRI image
Color‑coded segmentation result
```

---

# Output Example

The program produces figures showing:

- original MRI image
- binary CSF segmentation
- binary Gray Matter segmentation
- binary White Matter segmentation
- combined color segmentation map

These outputs allow easy visual inspection of the segmentation quality.

---

# MATLAB Requirements

The code requires:

- MATLAB R2018 or later
- Image Processing Toolbox

No external datasets are required.

---

# Main Function

The core segmentation algorithm is implemented in:

```
Discrete_FCM_PSO_ver2()
```

This function performs:

- PSO optimization
- fuzzy membership updates
- cluster center estimation
- final clustering assignment

---

# Applications

This framework can be applied in:

- brain tissue segmentation
- neurological disease research
- MRI image analysis
- medical image processing
- automated brain structure extraction

---

# Advantages of the Method

Compared with classical clustering approaches:

- More stable than standard FCM
- Less sensitive to initialization
- Better optimization through PSO search
- Robust segmentation of overlapping intensity distributions

---

# Summary

This project implements a **hybrid FCM‑PSO segmentation algorithm** for brain MRI images.

The method:

- converts the MRI image into pixel intensity data
- applies **Particle Swarm Optimization to optimize FCM clustering**
- extracts **CSF, Gray Matter, and White Matter**
- produces **binary and color segmentation maps**

The result is a **simple yet powerful unsupervised brain MRI segmentation framework** suitable for biomedical imaging research.
:::

که باعث می‌شود ریپازیتوری **خیلی قوی‌تر برای GitHub و رزومه تحقیقاتی** دیده شود.
