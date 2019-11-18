% function [newPosX, newPosY] = getMouseRemapped(multiplierXY)
%
% Change ratio of actual mouse movement distance (on the desk) to pointer
% movement distance (on the screen). This function should be called
% repeatedly in a loop as a replacement of GetMouse() from Psychtoolbox-3.
% Similar to GetMouse(), it returns the current mouse position and can thus be 
% used for mouse tracking. However, it also changes the ratio of actual
% mouse movement distance (on the desk) to pointer movement distance (on
% the screen) according to a multiplier passed as input argument. This is
% achieved by storing the mouse position from the last call, using this
% together with mouse position in the current call to compute movement
% velocity, multiplying the velocity with the input multiplier, and then
% setting the mouse position to the position corresponding to that
% multiplied position.
%
% IMPORTANT: Disable mouse acceleration.
%
% To achieve specific mappings between mouse movement distance on the desk
% and on the screen (e.g., one to one), use the function mouseRemapCalib
% to obtain a multiplier tailored to the desired ratio and the specific
% hardware used.
%
% mutliplierXY: 2-element row vector holding the multipliers for horizontal
% and vertical movement OR scalar giving one multiplier for both.
% The travel distance actually applied to the mouse pointer is the product
% of the multiplier with the distance that would have been travelled with
% the unaltered mapping (which is system- and hardware-specific).

function [newPosX, newPosY] = getMouseRemapped(multiplier)

% Store reference mouse position across calls of this funciton
persistent oldPos;

if ~all(size(multiplier) == [1,2])
    error('multiplier must be a two-element row vector.'  )
end

[newPos(1),newPos(2)] = GetMouse();

if ~isempty(oldPos) && ~all(oldPos==newPos)    
    mov = newPos - oldPos;
    newPos = oldPos + mov .* multiplier;            
    SetMouse(ceil(newPos(1)),ceil(newPos(2)));
end

oldPos = newPos;
newPosX = newPos(1);
newPosY = newPos(2);

end