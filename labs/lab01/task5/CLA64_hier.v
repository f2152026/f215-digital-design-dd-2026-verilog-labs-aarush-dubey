// cla64_hier.v
// BONUS -- open-ended. No detailed scaffold is provided; this is meant to
// be a genuine design exercise. Not required for lab submission.
//
// You will likely need to modify cla4.v (or add signals alongside it) so
// that block-generate/block-propagate summaries of its own Gi, Pi signals
// are exposed as outputs, since the second-level lookahead unit below
// needs them. As with every module in this lab from Task 2 onward, every
// gate/assign you add should carry an explicit delay.
//
// Starting point (from Tutorial 3, Q4(d)):
//   - Reuse 16 four-bit CLA blocks (your cla4.v) -- their internal logic
//     doesn't change.
//   - For each block k, define:
//       Gblk_k = "this block produces a carry regardless of its incoming
//                 carry" -- a Boolean function of that block's own 4
//                 bit-level Gi, Pi signals.
//       Pblk_k = "an incoming carry sails straight through this whole
//                 block" -- likewise a function of its own Gi, Pi.
//   - Build a second-level lookahead unit -- structurally identical to
//     cla4.v, just one level up -- that computes each block's carry-in
//     directly from Gblk_0..Gblk_15, Pblk_0..Pblk_15, and cin, instead of
//     rippling block to block.
//
// To test this, wire it into dut.v as a fourth option (copy the pattern
// used for the other three) and run it through the same tb.v. Compare
// your final delay to cla64_blocked.v from Task 4.

module cla64_hier(
  input  [63:0] a,
  input  [63:0] b,
  input         cin,
  output [63:0] sum,
  output        cout
);

  wire [15:0] block_p, block_g;
  wire [16:0] block_c;
  wire [15:0] unused_block_cout;

  assign #(2) block_c[0] = cin;

  genvar i;
  generate
    for (i = 0; i < 16; i = i + 1) begin : gen_block
      cla4_hier_block block (
        .a(a[(i * 4) +: 4]),
        .b(b[(i * 4) +: 4]),
        .cin(block_c[i]),
        .sum(sum[(i * 4) +: 4]),
        .cout(unused_block_cout[i]),
        .block_p(block_p[i]),
        .block_g(block_g[i])
      );
    end
  endgenerate

  // Second-level direct lookahead across the sixteen 4-bit blocks.
  assign #(2) block_c[1] = block_g[0] | (block_p[0] & block_c[0]);
  assign #(2) block_c[2] = block_g[1] | (block_p[1] & block_g[0]) |
                           (block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[3] = block_g[2] | (block_p[2] & block_g[1]) |
                           (block_p[2] & block_p[1] & block_g[0]) |
                           (block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[4] = block_g[3] | (block_p[3] & block_g[2]) |
                           (block_p[3] & block_p[2] & block_g[1]) |
                           (block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                           (block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[5] = block_g[4] | (block_p[4] & block_g[3]) |
                           (block_p[4] & block_p[3] & block_g[2]) |
                           (block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                           (block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                           (block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[6] = block_g[5] | (block_p[5] & block_g[4]) |
                           (block_p[5] & block_p[4] & block_g[3]) |
                           (block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                           (block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                           (block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                           (block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[7] = block_g[6] | (block_p[6] & block_g[5]) |
                           (block_p[6] & block_p[5] & block_g[4]) |
                           (block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                           (block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                           (block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                           (block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                           (block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[8] = block_g[7] | (block_p[7] & block_g[6]) |
                           (block_p[7] & block_p[6] & block_g[5]) |
                           (block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                           (block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                           (block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                           (block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                           (block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                           (block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[9] = block_g[8] | (block_p[8] & block_g[7]) |
                           (block_p[8] & block_p[7] & block_g[6]) |
                           (block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                           (block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                           (block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                           (block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                           (block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                           (block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                           (block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[10] = block_g[9] | (block_p[9] & block_g[8]) |
                            (block_p[9] & block_p[8] & block_g[7]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_g[6]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                            (block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[11] = block_g[10] | (block_p[10] & block_g[9]) |
                            (block_p[10] & block_p[9] & block_g[8]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_g[7]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_g[6]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                            (block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[12] = block_g[11] | (block_p[11] & block_g[10]) |
                            (block_p[11] & block_p[10] & block_g[9]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_g[8]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_g[7]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_g[6]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                            (block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[13] = block_g[12] | (block_p[12] & block_g[11]) |
                            (block_p[12] & block_p[11] & block_g[10]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_g[9]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_g[8]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_g[7]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_g[6]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                            (block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[14] = block_g[13] | (block_p[13] & block_g[12]) |
                            (block_p[13] & block_p[12] & block_g[11]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_g[10]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_g[9]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_g[8]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_g[7]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_g[6]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                            (block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[15] = block_g[14] | (block_p[14] & block_g[13]) |
                            (block_p[14] & block_p[13] & block_g[12]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_g[11]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_g[10]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_g[9]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_g[8]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_g[7]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_g[6]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                            (block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);
  assign #(2) block_c[16] = block_g[15] | (block_p[15] & block_g[14]) |
                            (block_p[15] & block_p[14] & block_g[13]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_g[12]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_g[11]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_g[10]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_g[9]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_g[8]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_g[7]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_g[6]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_g[5]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_g[4]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_g[3]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_g[2]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_g[1]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_g[0]) |
                            (block_p[15] & block_p[14] & block_p[13] & block_p[12] & block_p[11] & block_p[10] & block_p[9] & block_p[8] & block_p[7] & block_p[6] & block_p[5] & block_p[4] & block_p[3] & block_p[2] & block_p[1] & block_p[0] & block_c[0]);

  assign #(2) cout = block_c[16];

endmodule

// Four-bit CLA block with the generate/propagate summary needed by the
// second-level lookahead network above.
module cla4_hier_block(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout,
  output       block_p,
  output       block_g
);
  wire [3:0] p, g;
  wire [4:1] c;

  assign #(2) p = a ^ b;
  assign #(2) g = a & b;
  assign #(2) c[1] = g[0] | (p[0] & cin);
  assign #(2) c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
  assign #(2) c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) |
                     (p[2] & p[1] & p[0] & cin);
  assign #(2) c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) |
                     (p[3] & p[2] & p[1] & g[0]) |
                     (p[3] & p[2] & p[1] & p[0] & cin);
  assign #(2) sum = p ^ {c[3:1], cin};
  assign #(2) cout = c[4];
  assign #(2) block_p = p[3] & p[2] & p[1] & p[0];
  assign #(2) block_g = g[3] | (p[3] & g[2]) |
                        (p[3] & p[2] & g[1]) |
                        (p[3] & p[2] & p[1] & g[0]);
endmodule
