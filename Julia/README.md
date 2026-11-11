## **Fresh Eyes on CMIP Data Workshop 2026**: Application with Julia

#### **Purpose of this Tutorial**
* In this Script we will create climate stripe visualization from CMIP data using the Julia programming language. 
* Julia is an open source high level programming language (like Python, Matlab, R,...) that was published in 2012 and is mainly used for scientific programming. 
* The main difference of Julia compared to Python, R or Matlab is its speed. We will explore this characteristic in the following tutorial generating the climate stripes and comparing the performance to a Python implementation.

#### **Setup and Execution**

**Option 1: Run in Browser (Google Colab)**
Click the badge below to open the notebook in Google Colab. You only need a Google account, no installation required.

[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1P-C8BvMVHggqNaODqEQXZMjTTKFGm3wC)

1. Check that the runtime is set to Julia: **Runtime → Change runtime type → Julia**.
2. Run the **Setup** cell first. Installing and precompiling the packages takes about 10–15 minutes.
3. Run the remaining cells.

*Note: To keep your changes, save your own copy via **File → Save a copy in Drive**. The setup cell has to be run again in every new Colab session.*

---

**Option 2: Run Locally (VS Code)**
To run the code on your local machine, follow these steps:

1. **Install Prerequisites**
    * **Visual Studio Code:** Download and install from [code.visualstudio.com](https://code.visualstudio.com/).
    * **Julia:** Download and install Julia via the official multiplexer `juliaup`. Follow the installation instructions here: [Juliaup GitHub](https://github.com/JuliaLang/juliaup#installation).

2. **Install VS Code Extensions**
Open VS Code, navigate to the Extensions view (`Ctrl+Shift+X` or `Cmd+Shift+X`), and install the following extensions:
    * **Julia** (by julialang)
    * **Jupyter** (by Microsoft)

3. **Clone the Repository**
Open your terminal or command prompt and clone this repository:
```bash
git clone https://github.com/TimMauch/Julia-CMIP.git
cd Julia-CMIP
```

