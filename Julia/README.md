## **Fresh Eyes on CMIP Data Workshop 2026**: Application with Julia

#### **Purpose of this Tutorial**
* In this Script we will create climate stripe visualization from CMIP data using the Julia programming language. 
* Julia is an open source high level programming language (like Python, Matlab, R,...) that was published in 2012 and is mainly used for scientific programming. 
* The main difference of Julia compared to Python, R or Matlab is its speed. We will explore this characteristic in the following tutorial generating the climate stripes and comparing the performance to a Python implementation.

#### **Setup and Execution**

**Option 1: Run in Binder**
Click the badge below to open the notebook in Binder. 

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/TimMauch/Julia-CMIP/main?urlpath=%2Fdoc%2Ftree%2Fclimate_stripes.ipynb)

Important: After running the speed comparison, please restart the binder kernel, becuase otherwise the meomery of your session will be exhausted!

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
Open your terminal or command prompt and clone the repository:
```bash
git clone https://github.com/link/to/repo
cd Julia-CMIP
```

