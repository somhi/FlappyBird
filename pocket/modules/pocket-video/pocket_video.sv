//------------------------------------------------------------------------------
// SPDX-License-Identifier: MPL-2.0
// SPDX-FileType: SOURCE
// SPDX-FileCopyrightText: (c) 2022 Marcus Andrade
//------------------------------------------------------------------------------
//
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this file,
// You can obtain one at https://mozilla.org/MPL/2.0/.
//
//------------------------------------------------------------------------------
// Generic Video Interface for the Analogue Pocket Display
//
// Note: APF scaler requires HSync and VSync to last for a single clock, and
// video_rgb to be 0 when video_de is low
//------------------------------------------------------------------------------

module pocket_video
    (
        input             iPCLK,     //! Display Pixel Clock
        input             iPCLK_90D, //! Display Pixel Clock 90º Phase Shift

        input      [23:0] iRGB,      //! Core: RGB Video
        input             iVS,       //! Core: Vsync
        input             iHS,       //! Core: Hsync
        input             iDE,       //! Core: Data Enable

        output reg [23:0] oRGB,      //! Pixel color: Red[23:16] Green[15:8] Blue[7:0]
        output reg        oVS,       //! Frame Vsync Active high
        output reg        oHS,       //! Frame Hsync Active high
        output reg        oDE,       //! Data enable Active high

        output wire       oPCLK,     //! Display Pixel Clock
        output wire       oPCLK_90D  //! Display Pixel Clock 90º Phase Shift
    );

    assign oPCLK = iPCLK;
    assign oPCLK_90D = iPCLK_90D;

    reg [23:0] rRGB;
    reg        rHS;
    reg        rVS;
    reg        rDE;

    always @(posedge iPCLK) begin
        oDE <= 0;
        oRGB <= 24'h0;
        if (rDE) begin
            oDE <= 1;
            oRGB <= rRGB;
        end
        // Set HSync and VSync to be high for a single cycle on the rising edge of the HSync and VSync coming out of the core
        oHS <= ~rHS && iHS;
        oVS <= ~rVS && iVS;
        rVS  <= iVS;
        rHS  <= iHS;
        rDE  <= iDE;
        rRGB <= iRGB;
    end

endmodule
