//-----------------------------------------------------------------------------
// Title         : pe_array_decs.v - top-level header file - game of life
// Project       : Tiled Sequential Processing
//-----------------------------------------------------------------------------
// File          : tsp_decs.v
// Author        : John Nestor
// Created       : 29.06.2015
// Last modified : 29.06.2015
//-----------------------------------------------------------------------------
// Description :
// This is the top-level header file for Tiled Sequential Processing.  This file
// should be customized for arrays of different sizes and configurations.  
// Note that some parameters are interrelated; including 
//
//------------------------------------------------------------------------------
// Modification history :
// 29.06.2015 : created
//-----------------------------------------------------------------------------



`ifndef PE_ARRAY_DEFS
`define PE_ARRAY_DEFS

// size parameters - PE array

`define N_PX 32   // width of tile in PEs
`define N_PY 32  // height of tile in PEs

`define N_PX_BITS 5  // number of bits in horiz physical address ( ceil(log2(N_PX)) )
`define N_PY_BITS 5  // number of bits in vertical physical address ( ceil(log2(N_PY)) )
`define N_P_BITS `N_PX_BITS + `N_PY_BITS


`endif
