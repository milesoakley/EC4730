%% Lab 3: A Simple JPEG-like Algorithm
% Miles Oakley and Drew Spitzer
clear all; close all; clc;

% 1. Define Source Images and Quantization matrix
x1 = [110 110 109 107 110 122 163 164;
    112 107 105 107 107 127 145 140;
    109 111 109 112 108 125 123 120;
    110 109 112 114 110 126 145 160;
    110 107 109 114 114 126 159 158;
    107 109 108 111 112 128 160 180;
    107 109 110 115 111 131 167 180;
    106 107 109 111 112 138 166 164];

x2 = [141 106 132 173 184 194 198 194
    159 153 157 176 187 190 194 195;
    148 167 164 176 185 192 196 195;
    174 168 163 177 184 192 201 203;
    185 176 166 177 185 193 203 205;
    165 154 165 174 182 194 201 203;
    162 160 165 171 180 194 198 196;
    160 159 166 170 178 191 198 193];

QL = [16 11 10 16 24 40 51 61;
    12 12 14 19 26 58 60 55;
    14 13 16 24 40 57 69 56;
    14 17 22 29 51 87 80 62;
    18 22 37 56 68 109 103 77;
    24 35 55 64 81 104 113 92;
    49 64 78 87 103 121 120 101;
    72 92 95 98 112 100 103 99];

% 2. Apply offset (-128)
x1_o = x1 - 128;
x2_o = x2 - 128;

% 3. Apply 2-D DCT
X1 = uint8(round(dct2(x1_o)));
X2 = uint8(round(dct2(x2_o)));
X1_bin = dec2bin(X1);
X2_bin = dec2bin(X2);

 %% Scheme 1 - Embed After the DCT
% 4a. Embed messages of 3 legnths in the LSBs of the DCT matrix
mlengths = [16 32 64];
m1 = uint8([1,0,0,1,1,1,0,1,1,0,0,1,1,1,0,1]);
m2 = [m1 m1];
m3 = [m2 m2];

X1_stego = X1;
X1_stego(1:8,1) = bitset(X1(1:8,1), 1, m1(1:8)');
X1_stego(1:8,2) = bitset(X1(1:8,2), 1, m1(9:16)');

X1_stego2 = X1;
X1_stego2(1:8,1) = bitset(X1(1:8,1), 1, m2(1:8)');
X1_stego2(1:8,2) = bitset(X1(1:8,2), 1, m2(9:16)');
X1_stego2(1:8,3) = bitset(X1(1:8,3), 1, m2(17:24)');
X1_stego2(1:8,4) = bitset(X1(1:8,4), 1, m2(25:32)');

X1_stego3 = X1;
X1_stego3(1:8,1) = bitset(X1(1:8,1), 1, m3(1:8)');
X1_stego3(1:8,2) = bitset(X1(1:8,2), 1, m3(9:16)');
X1_stego3(1:8,3) = bitset(X1(1:8,3), 1, m3(17:24)');
X1_stego3(1:8,4) = bitset(X1(1:8,4), 1, m3(25:32)');
X1_stego3(1:8,5) = bitset(X1(1:8,5), 1, m3(33:40)');
X1_stego3(1:8,6) = bitset(X1(1:8,6), 1, m3(41:48)');
X1_stego3(1:8,7) = bitset(X1(1:8,7), 1, m3(49:56)');
X1_stego3(1:8,8) = bitset(X1(1:8,8), 1, m3(57:64)');

X1_stego = double(X1_stego);
X1_stego_bin = dec2bin(X1_stego);
X1_stego2 = double(X1_stego2);
X1_stego_bin2 = dec2bin(X1_stego2);
X1_stego3 = double(X1_stego3);
X1_stego_bin3 = dec2bin(X1_stego3);

% 5a. Quantize
X1_T = X1_stego * QL;
X1_T2 = X1_stego2 * QL;
X1_T3 = X1_stego3 * QL;

% 6a. Inverse Quantization
X1_R = X1_T * inv(QL);
X1_R2 = X1_T2 * inv(QL);
X1_R3 = X1_T3 * inv(QL);

% 7a. Apply 2D IDCT
x1_R = round(idct2(X1_R));
x1_R2 = round(idct2(X1_R2));
x1_R3 = round(idct2(X1_R3));

% 8a. Apply Inverse Offset
x1_R = x1_R + 128;
x1_R2 = x1_R2 + 128;
x1_R3 = x1_R3 + 128;

disp(x1)
disp(x1_R)

disp(X1)
disp(X1_R)

%% Scheme 2 - Embed After Quatization
% 4b. Quantize the matrix
X2t = double(X2) * QL;

% 5b. Embed messages of 3 lengths in the LSBs of the Quantized matrix
X2_stego = X2t;
X2_stego(1:8,1) = bitset(X2t(1:8,1), 1, m1(1:8)');
X2_stego(1:8,2) = bitset(X2t(1:8,2), 1, m1(9:16)');

X2_stego2 = X2t;
X2_stego2(1:8,1) = bitset(X2t(1:8,1), 1, m2(1:8)');
X2_stego2(1:8,2) = bitset(X2t(1:8,2), 1, m2(9:16)');
X2_stego2(1:8,3) = bitset(X2t(1:8,3), 1, m2(17:24)');
X2_stego2(1:8,4) = bitset(X2t(1:8,4), 1, m2(25:32)');

X2_stego3 = X2t;
X2_stego3(1:8,1) = bitset(X2t(1:8,1), 1, m3(1:8)');
X2_stego3(1:8,2) = bitset(X2t(1:8,2), 1, m3(9:16)');
X2_stego3(1:8,3) = bitset(X2t(1:8,3), 1, m3(17:24)');
X2_stego3(1:8,4) = bitset(X2t(1:8,4), 1, m3(25:32)');
X2_stego3(1:8,5) = bitset(X2t(1:8,5), 1, m3(33:40)');
X2_stego3(1:8,6) = bitset(X2t(1:8,6), 1, m3(41:48)');
X2_stego3(1:8,7) = bitset(X2t(1:8,7), 1, m3(49:56)');
X2_stego3(1:8,8) = bitset(X2t(1:8,8), 1, m3(57:64)');

X2_stego = double(X2_stego);
X2_stego_bin = dec2bin(X2_stego);
X2_stego2 = double(X2_stego2);
X2_stego_bin2 = dec2bin(X2_stego2);
X2_stego3 = double(X2_stego3);
X2_stego_bin3 = dec2bin(X2_stego3);

% 6a. Inverse Quantization
X2_R = X2_stego * inv(QL);
X2_R2 = X2_stego2 * inv(QL);
X2_R3 = X2_stego3 * inv(QL);

% 7a. Apply 2D IDCT
x2_R = round(idct2(X2_R));
x2_R2 = round(idct2(X2_R2));
x2_R3 = round(idct2(X2_R3));

% 8a. Apply Inverse Offset
x2_R = x2_R + 128;
x2_R2 = x2_R2 + 128;
x2_R3 = x2_R3 + 128;

disp(x2)
disp(x2_R)

disp(X2)
disp(X2_R)