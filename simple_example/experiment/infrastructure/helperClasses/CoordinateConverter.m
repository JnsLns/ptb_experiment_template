classdef CoordinateConverter
% Instantiate an object of this class at the outset of an experiment, feed-
% ing it the specifics of the spatial setup of the experiment (see
% Constructor method documentation). Then use it within experimental code
% to convert between different coordinate frames and units using the
% provided methods. The goal of this class is to enable the user to think
% (almost) exclusively in degrees of visual angle and within the
% presentation-area-based coordinate frame when specifying stimuli and such,
% while easily converting to the Psychtoolbox frame when using Psychtoolbox
% functions. It is also useful when dealing with motion tracking equipment
% (see below).
% 
%                       ___Method naming scheme___
%
%       va  : degrees of visual angle
%       mm  : millimeters
%       px  : pixels
%       pa  : presentation-area coordinate frame
%       ptb : Psychtoolbox coordinate frame
%       scr : screen-based coordinate frame
%
%   E.g., paMmToPtbPx -> convert from millimeter coordinates given
%   in the presentation-area-based frame to pixel coordinates in
%   the Psychtoolbox frame. vaToPx -> convert from degree visual angle to
%   pixels.
%
% 
%                ___Method summary / input / output___
%
% Unit conversion methods expect a numeric array as input and return an 
% array of the same size holding converted values. 
%
% Unit-coordinate-frame conversion methods take two input arguments,
% namely two vectors of length n, which hold the x and y coordinates of n
% points, respectively. They return a 2-by-n matrix giving converted x and
% y coordinates in its rows, for each of the n points. This format (x,y
% coordinats in rows, points in columns) was chose since this is the format
% that most Psychtoolbox functions expect when drawing.
%
%
%                      ___Coordinate frames___
%
%
% Presentation-area  : Origin at bottom left of presentation area, x-axis
% (pa)                 increasing to the right, y-axis increasing upward.
%                      Note that where the bottom left of the presentation
%                      area is is determined by setting 'presArea_va'
%                      (which gives the [horz, vert] length of each side of
%                      the rectangular presentation area that in turn is
%                      always centered in the screen; thus, if presArea_va
%                      is [0 0], the origin is in the screen center).
%
% Psychtoolbox       : Origin at top left of the visible image of the
% (ptb)                screen, x-axis increasing to the right, y-axis
%                      increasing downward. Expected by all Psychtoolbox
%                      functions.
%
% Screen-based       : Origin at bottom left of the visible image of the
% (scr)                screen, x-axis increasing to the right, y-axis
%                      increasing upward. This frame is intended for use
%                      with motion tracking equipment. The idea is to have
%                      markers mounted on the screen and assess others
%                      markers' positions within a coordinate frame defined
%                      by those mounted markers. The markers should be
%                      mounted such that the coordinate frame is congruent
%                      with the screen-based frame, thus enabling usage of
%                      this class to convert from marker positions as
%                      returned by the motion tracking equipment to the
%                      other frames (e.g., for drawing a pointer on the
%                      screen or recording trajectories in relation to
%                      stimuli).




    properties (SetAccess=private)
        viewingDistance_mm  % Distance of participant from screen in mm
        expScreenSize_mm    % Screen [width, height] in mm (visible image)
        expScreenSize_px    % Screen [horz, vert] resolution in pixels
        presArea_va         % Presentation area [width, height] in visual angle        
        presMargins_mm      % Margins [horz, vert] on each side of pres.area
    end
    
    methods              
        
        function obj = CoordinateConverter(viewingDistance_mm, expScreenSize_mm, expScreenSize_px, presArea_va)            
        % function obj = CoordinateConverter(viewingDistance_mm, expScreenSize_mm, expScreenSize_px, presArea_va)
        %   
        %               ___Inputs___
        %       
        % viewingDistance_mm 	Distance of participant from screen in mm
        % expScreenSize_mm      Screen [width, height] in mm (visible image)
        % expScreenSize_px      Screen [horz, vert] resolution in pixels
        % presArea_va           Presentation area [width, height] in visual angle
        
            obj.viewingDistance_mm = viewingDistance_mm;
            obj.expScreenSize_mm = expScreenSize_mm;
            obj.expScreenSize_px = expScreenSize_px;
            obj.presArea_va = presArea_va;
            presArea_mm = obj.vaToMm(obj.presArea_va);
            obj.presMargins_mm = (obj.expScreenSize_mm - presArea_mm)./2;
        end

        function [mm] = pxToMm(obj, px)
        % Unit conversion method.
            mm = px ./ mean(obj.expScreenSize_px./obj.expScreenSize_mm);
        end
        function [mm] = vaToMm(obj, va)   
        % Unit conversion method.
            mm = 2 * pi * obj.viewingDistance_mm * va/360;
        end
        function [px] = mmToPx(obj, mm)            
        % Unit conversion method.
            px = mm * mean(obj.expScreenSize_px./obj.expScreenSize_mm);
        end
        function [px] = vaToPx(obj, va)
        % Unit conversion method.
            px = obj.mmToPx(obj.vaToMm(va));
        end
        function [va] = mmToVa(obj, mm)
        % Unit conversion method.
            va = mm * 180 / (pi * obj.viewingDistance_mm);
        end
        function [va] = pxToVa(obj, px)
        % Unit conversion method.
            va = obj.mmToVa(obj.pxToMm(px));
        end
                
        function xy_ptb_px = paMmToPtbPx(obj, x_pa_mm, y_pa_mm)  
        % Unit-coordinate-frame conversion method.
        
            % Transform CRF
            x_ptb_mm = x_pa_mm + obj.presMargins_mm(1);
            y_ptb_mm = -y_pa_mm - obj.presMargins_mm(2) + obj.expScreenSize_mm(2);            
            % Convert to pixels
            x_ptb_px = obj.mmToPx(x_ptb_mm);
            y_ptb_px = obj.mmToPx(y_ptb_mm);      
            % Shape into matrix
            xy_ptb_px = [x_ptb_px(:)'; y_ptb_px(:)'];
        end
                
        function xy_ptb_px = paVaToPtbPx(obj, x_pa_va, y_pa_va)
        % Unit-coordinate-frame conversion method.
        
            % Convert input from visual angle to mm
            x_pa_mm = obj.vaToMm(x_pa_va);
            y_pa_mm = obj.vaToMm(y_pa_va);            
            % Transform to PTB CRF in pixels
            xy_ptb_px = paMmToPtbPx(x_pa_mm, y_pa_mm);            
        end
        
        function xy_pa_mm = ptbPxToPaMm(obj, x_ptb_px, y_ptb_px)
        % Unit-coordinate-frame conversion method.
        
            % Convert to mm
            x_ptb_mm = obj.pxToMm(x_ptb_px);
            y_ptb_mm = obj.pxToMm(y_ptb_px);            
            % Transform CRF
            x_pa_mm = x_ptb_mm - obj.presMargins_mm(1);
            y_pa_mm = -y_ptb_mm - obj.presMargins_mm(2) + obj.expScreenSize_mm(2);
            % Shape into matrix
            xy_pa_mm = [x_pa_mm(:)'; y_pa_mm(:)'];
        end
        
        function xy_pa_va = ptbPxToPaVa(obj, x_ptb_px, y_ptb_px)
        % Unit-coordinate-frame conversion method.
        
            % Convert from ptb frame in pixels to pres area frame in mm
            xy_pa_mm = obj.ptbPxToPaMm(x_ptb_px, y_ptb_px);            
            % Convert from millimeters to visual angle
            xy_pa_va = obj.mmToVa(xy_pa_mm);                        
        end
        
        function xy_pa_mm = scrMmToPaMm(obj, x_scr_mm, y_scr_mm)
        % Unit-coordinate-frame conversion method.

            % Subtract margins
            x_pa_mm = x_scr_mm - obj.presMargins_mm(1);
            y_pa_mm = y_scr_mm - obj.presMargins_mm(2);
            % Shape into matrix
            xy_pa_mm = [x_pa_mm(:)'; y_pa_mm(:)'];            
        end
        
        function xy_ptb_px = scrMmToPtbPx(obj, x_scr_mm, y_scr_mm)
        % Unit-coordinate-frame conversion method.
            
            % Transform CRF
            y_ptb_mm = obj.expScreenSize_mm(2) - y_scr_mm;            
            % Convert to pixels
            x_ptb_px = obj.mmToPx(x_scr_mm);
            y_ptb_px = obj.mmToPx(y_ptb_mm);
            % Shape into matrix
            xy_ptb_px = [x_ptb_px(:)'; y_ptb_px(:)'];            
        end
                
    end
     
end