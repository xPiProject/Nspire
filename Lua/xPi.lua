--[[
xPi V2000 for Nspire Series
TI-Lua Version

Copyleft (c) 2014

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]--

iElapse = 0;

function calc(n)
    local f, res = {}, {};
    local a, b, c, d, e;
    a = 10000;
    c = n / 4 * 14;
    e = 0;
    local i = 1;
    for i = 0, c do f[i] = 2000; end
    
    iElapse = timer.getMilliSecCounter();
    
    while c~=0 do
        d = 0;
        g = c * 2;
        b = c;
        while true do
            d = math.floor(d + f[b] * a);
            g = g - 1;
            f[b] = d % g;
            d = math.floor(d / g)
            g = g - 1; b = b - 1
            if b == 0 then break end
            d = d * b;
        end
        c = c - 14;
        res[i] = string.format("%04d", e + math.floor(d / a));
        i = i + 1;
        e = d % a;
    end
    
    iElapse = timer.getMilliSecCounter() - iElapse;
    
    res[1] = "3.141";
    var.store("res", table.concat(res));
    
    collectgarbage();
end


charStack = {};
ifCalculated = false;

function on.charIn(char)
    local res = ctype.isdigit(char);
    if(res == true) then
        table.insert(charStack, char);
    end
    platform.window:invalidate();
end

function on.backspaceKey()
    table.remove(charStack);
    
    platform.window:invalidate();
end

function on.enterKey()
    local n = tonumber(table.concat(charStack));
    
    if n < 4 then  n = 4;
    elseif  n % 4 ~= 0 then n = n + (4 - n % 4);
    end
    
    calc(n);
    
    ifCalculated = true;
    
    platform.window:invalidate();
end

function on.paint(gc)
    
    gc:setColorRGB(0xffffff);
    gc:fillRect(0, 0, 320, 240);
    gc:setColorRGB(0x000000);
    
    gc:drawString("Digits:", 5, 20);
    gc:drawString(table.concat(charStack), 45, 20);
    
    gc:drawString("Presss [enter] to begin.", 5, 40);
    gc:drawString("Note:Your NS may be unresponsive for a while.",0, 60);
    if(ifCalculated) then
      gc:drawString("Time: " .. tostring(iElapse/1000) .. " s",5,100);
    end
end
-----------------ctype lib-----------------
--[[
    TI-Lua String Library Extension ---- ctype(non assert version)
    Copyright 2013 wtof1996

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]--

ctype = {};
--The exception  table
ctype.exception = {["invChar"] = "ctype:invalid character", ["invType"] = "ctype:invalid type", ["longString"] = "ctype:the string is too long"};

--This private function is used to check input & convert all kinds of input into number.
function ctype.CheckInput(input)
    if(type(input) == "number") then
        if((input > 0x7F) or (input < 0) or (math.ceil(input)) ~= input)  then return nil, ctype.exception.invChar end;
        return input;
    elseif(type(input) == "string") then
        if(#input > 1) then return nil, ctype.exception.longString end;
        local res = input:byte();
        if((res > 0x7F) or (res < 0))  then return nil, ctype.exception.invChar end;
        return res;
    else
        return nil, ctype.exception.invType;
    end
end

--Public function

function ctype.isdigit(char)
    local res, err = ctype.CheckInput(char);
    if(err ~= nil) then return nil, err end;

    if( ((res >= 0x30) and (res <= 0x39))) then return true, nil end;
    return false, nil;
end
