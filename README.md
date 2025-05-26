# High-Speed-32-Bit-ALU
Implemented through SIMD Parallel Computing Technique and High-Speed Arithmetic Circuits

The SIMD 32-bit ALU is designed for parallel processing of four 8-bit data segments using a 16-bit opcode, enabling efficient arithmetic and logical operations.

⚙️ Key Features:
Data Width: 32 bits (4 × 8-bit segments)
Opcode Width: 16 bits (4 × 4-bit control fields)
Parallelism: Each 4-bit opcode controls one 8-bit operation in parallel.

🔢 Supported Operations (Opcode 0–A):
Opcode	Operation
0	      Addition
1      	Subtraction
2	      Multiplication
3	      Division
4	      AND
5	      OR
6	      XOR
7	      One’s Complement of A
8	      Right Shift (Logical)
9	      Left Shift (Logical)
A (10)	4x4 Matrix Multiplication

⚡ High-Speed Arithmetic Units:
Sparse Kogge-Stone Adder – for fast addition
Sparse Kogge-Stone Subtracter – for subtraction
Dadda Multiplier – for high-speed multiplication

🔄 Special Case: 4x4 Matrix Multiplication
Executed only when all 4 opcode fields are set to 0xA (opcode = 0xAAAA).
The 32-bit data input is treated as a 4×4 matrix with 16 elements
Each matrix element is represented using 2 bits
Only binary values are valid:
➤ Each element must be either 0 or 1
➤ No decimal values >1 allowed
The 32 bits are mapped row-wise:
First 2 bits → Row 1, Column 1
Next 2 bits → Row 1, Column 2
... up to Row 4, Column 4
Interprets the full 32-bit data as a 4x4 matrix for multiplication

