# Overview of tANS/FSE Encoder

## Introduction

The system is designed to compress data efficiently like ZSTD, utilizing various modules each tailored for specific tasks within the data compression pipeline. 

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

These modules are carefully designed to ensure seamless integration:
- The `fse_encoder` serves as the primary encoding hub, utilizing tools and tables from other packages to encode data.
- The `bitstream_2to1_merger` is strategically utilized to progressively merge different stages of the bitstream.
- The `fse2single_bitstream` module finalizes the output by converting the multi-part streams into a single, manageable stream.

## Conclusion

This FSE encoder design emphasizes modularity and efficiency, with each component crafted to perform its role effectively while integrating smoothly with others. This structure ensures that the system is not only powerful in terms of performance but also flexible and easy to maintain, suitable for a variety of data compression needs.
