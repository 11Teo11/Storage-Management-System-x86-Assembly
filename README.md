# Storage-Management-System-x86-Assembly


A low-level simulation of **file storage and memory management**, implemented in **x86 Assembly**.  
The project models how an operating system could handle **file allocation, retrieval, deletion, and defragmentation** within **1D and 2D memory structures**.

Developed as part of the **Computer Systems Architecture** course  
*Faculty of Mathematics and Computer Science, University of Bucharest*  

---

## Overview

The simulator works in two main modes:
1. **1D Memory Model** — memory represented as a linear vector of 1024 cells  
2. **2D Memory Model** — memory represented as a 256x1024 matrix  

Each cell stores a **file descriptor** (integer).  
The system can:
- Add files with specific sizes and descriptors  
- Retrieve file positions  
- Delete files  
- Perform defragmentation (compact memory)  
- Display all occupied memory segments  

---

## Features

| Operation | Description |
|------------|-------------|
| **Add** | Allocates a new file in the available memory blocks |
| **Get** | Displays the coordinates (1D or 2D) of a specific file descriptor |
| **Delete** | Frees memory blocks associated with a descriptor |
| **Defrag** | Moves all existing files to compact memory usage |
| **Display** | Lists all stored files with their intervals |
