--[[
xPi V2000 for Calculator
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
--]]

x=800

a=10000
c=x/4*14
e=0
f={}
i=0

res="3.141\n"
sTmp=""

for i=1,2801 do
    f[i]=2000
end

iElapse=timer.getMilliSecCounter()

i=0
while c~=0 do
    d=0
	g=c*2
	b=c
	while true do
	    d=math.floor(d+f[b+1]*a)
		g=g-1
		f[b+1]=d%g
		d=math.floor(d/g)
		g=g-1
		b=b-1
		if b==0 then break end
		d=d*b
	end
	c=c-14
	
	if i>0 then
	    if e+d/a<10 and e+d/a>=1 then
		    sTmp=string.format("000%.4d",e+d/a)
		elseif e+d/a<100 and e+d/a>=10 then
		    sTmp=string.format("00%.4d",e+d/a)
		elseif e+d/a<1000 and e+d/a>=100 then
		    sTmp=string.format("0%.4d",e+d/a)
		else
		    sTmp=string.format("%.4d",e+d/a)
		end
		if i%7==0 then sTmp=sTmp .. "\n" end
		res=res .. sTmp
	end
	i=i+1
	
	e=d%a
end

iElapse=timer.getMilliSecCounter()-iElapse
var.store("pistr",res)

function on.paint(gc)
    gc:drawString("Timer: " .. tostring(iElapse/1000) .. " s",20,20)
end