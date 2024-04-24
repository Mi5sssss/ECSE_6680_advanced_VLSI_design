# Overview of tANS/FSE Encoder

## Introduction

The system is designed to compress data efficiently like ZSTD, utilizing various modules each tailored for specific tasks within the data compression pipeline. 

## Understanding Finite State Entropy (FSE) Encoding

### What is Finite State Entropy?

Finite State Entropy (FSE) is an advanced form of entropy coding used in data compression that surpasses traditional methods like Huffman coding in terms of efficiency and compression ratios. FSE utilizes a table-driven approach to dynamically adjust the probabilities of symbols based on their occurrence and context, which leads to more efficient compression of data with varying statistical properties.

### How Does FSE Work?

FSE operates on the principle of transforming the input data into a series of states using a set of encoding tables derived from the symbol probabilities of the input data. The process is detailed as follows:

#### 1. **Probability Modeling**

- FSE first analyzes the input data to determine the frequency of each symbol.
- Based on these frequencies, a probability model is created which assigns each symbol a probability and a corresponding coding range.

#### 2. **Table Generation**

- Using the probability model, FSE generates two primary tables:
  - **State transition table**: Dictates how the current state changes after encoding a symbol.
  - **Symbol transformation table**: Maps each symbol to a new state and a part of the output bitstream.
  
#### 3. **Encoding Process**

- The encoding process starts with an initial state.
- For each symbol in the input:
  - The symbol is used to look up in the symbol transformation table, which provides a new state and the bits to be written to the output.
  - These bits are output in reverse order, starting from the least significant bit.
  - The state transition table is then consulted with the current state and the symbol to determine the next state.
  
#### 4. **Normalization**

- During encoding, if the state reaches a boundary that cannot represent the next symbol, a normalization process occurs:
  - Bits are output to the bitstream to make room for more symbols.
  - This ensures that the encoder and decoder stay synchronized.

#### 5. **Termination**

- Once all input symbols are processed, the final state represents the last part of the encoded data.
- The final bits derived from the last state are written to the output to complete the encoding process.

### Benefits of Using FSE

- **Efficiency**: FSE adapts to the symbol distribution dynamically, providing better compression ratios than static methods.
- **Speed**: Despite its complexity, modern implementations of FSE are designed to be extremely fast, making it suitable for real-time applications.
- **Versatility**: It can be used across various data types and applications, from text compression to multimedia encoding.


## Module Descriptions

### **Arithmetic Package (`arithmetic_pkg.vhd`)**

- **Purpose**: Supplies basic arithmetic functions that are widely used across the system.
- **Key Functions**:
  - `clog2`: Calculates the ceiling of the base-2 logarithm of a given number, useful for determining bit widths needed to represent values.
  - `dividor_round_to_ceil`: Computes the ceiling of the division between two integers, ensuring that allocations and sizes are properly rounded up.

### **Entropy Package (`entropy_pkg.vhd`)**

- **Purpose**: Manages entropy coding by providing tools to translate data lengths and offsets into compact, encoded forms.
- **Key Functions**:
  - `literal_len2code`: Converts literal lengths into their corresponding codes for compression.
  - `match_len2code`: Transforms match lengths found during compression into codes.
  - `match_off2code`: Encodes match offsets, crucial for referencing previous data in compression algorithms.

### **Compressor Package (`compressor_pkg.vhd`)**

- **Purpose**: Implements the compression logic, handling data streams and managing buffers for efficient processing.
- **Key Features**:
  - Hash functions to quickly find matching data sequences.
  - Mechanisms to manage and manipulate data streams effectively, essential for the dynamic nature of data compression.

### **FSE Tables Package (`fse_tables_pkg.vhd`)**

- **Purpose**: Stores all necessary tables for the FSE encoding process, such as state transition tables and symbol conversion tables.
- **Functionality**: These tables are crucial for the encoder's state management, allowing it to efficiently transition between states based on the input data and encode data using predefined rules.

### **Bitstream Merger (`bitstream_2to1_merger.vhd`)**

- **Purpose**: Combines two bitstreams into one, simplifying the process of merging various parts of encoded data into a single output stream.
- **Functionality**: This module takes two input streams and merges them based on their bit lengths, ensuring that data from two separate sources can be unified into a single stream without loss of information.

### **FSE to Single Bitstream Converter (`fse2single_bitstream.vhd`)**

- **Purpose**: Converts segmented FSE encoded data into a continuous single bitstream, making the output easier to store or transmit.
- **Details**: It ensures all parts of the FSE encoded data are correctly aligned and concatenated, resulting in a streamlined output that retains all necessary encoding details.

### **FSE Encoder (`fse_encoder.vhd`)**

- **Purpose**: Acts as the heart of the system, interfacing with the various packages to perform data encoding.
- **Functionality**: It processes incoming data sequences, applies entropy coding and FSE encoding, and outputs encoded bitstreams along with metadata about the encoding process.

## System Integration

These modules are carefully designed to ensure integration:
- The `fse_encoder` serves as the primary encoding hub, utilizing tools and tables from other packages to encode data.
- The `bitstream_2to1_merger` is strategically utilized to progressively merge different stages of the bitstream.
- The `fse2single_bitstream` module finalizes the output by converting the multi-part streams into a single, manageable stream.

## Conclusion

Finite State Entropy represents a significant advancement in the field of data compression, offering superior performance and efficiency. Its ability to adapt to different data patterns dynamically makes it a powerful tool for modern compression needs, balancing complexity with performance to achieve optimal results.