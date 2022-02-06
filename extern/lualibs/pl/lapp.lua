-- Penlight 1.11.0-1 | /lua/pl/lapp.lua | https://github.com/lunarmodules/Penlight | License: MIT | Minified using https://www.npmjs.com/package/luamin/v/1.0.4
-- Copyright (C) 2009-2016 Steve Donovan, David Manura.
-- Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
-- The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
local a,b=pcall(require,'pl.sip')if not a then b=require'sip'end;local c=b.match_at_start;local d,e=table.insert,table.insert;b.custom_pattern('X','(%a[%w_%-]*)')local function f(g)return g:gmatch('([^\n]*)\n')end;local function h(i)return i:gsub('^%s+','')end;local function j(i)return h(i):gsub('%s+$','')end;local function k(g,l)return g:sub(l,l)end;local m={}local n,o,p,q,r,s;m.callback=false;local t={stdin={io.stdin,'file-in'},stdout={io.stdout,'file-out'},stderr={io.stderr,'file-out'}}m.show_usage_error=true;function m.quit(u,v)if v=='throw'then error(u)end;if u then io.stderr:write(u..'\n\n')end;if not v then io.stderr:write(r)end;os.exit(1)end;function m.error(u,v)if not m.show_usage_error then v=true elseif m.show_usage_error=='throw'then v='throw'end;m.quit(s..': '..u,v)end;function m.open(w,x)local y,z=io.open(w,x)if not y then m.error(z,true)end;d(n,y)return y end;function m.assert(A,u)if not A then m.error(u)end end;local function B(C,D,E,F)m.assert(D<=C and E>=C,F..' out of range')end;local function G(g)local y=tonumber(g)if not y then m.error("unable to convert to number: "..g)end;return y end;local H={}local I={string=true,number=true,['file-in']='file',['file-out']='file',boolean=true}local function J(K,y)if K.converter then y=K.converter(y)end;if K.type=='number'then y=G(y)elseif I[K.type]=='file'then y=m.open(y,K.type=='file-in'and'r'or'w')elseif K.type=='boolean'then return y end;if K.constraint then K.constraint(y)end;return y end;function m.add_type(L,M,N)H[L]={converter=M,constraint=N}end;local function O(P)m.assert(#P==1,P..": short parameters should be one character")end;local function Q(R,S)local y,T;if not S or S=='number'then y=tonumber(R)end;if y then return y,'number'elseif t[R]then local U=t[R]return U[1],U[2]else if R=='true'and not S then return true,'boolean'end;if R:match'^["\']'then R=R:sub(2,-2)end;local K=H[S]or{}K.type=S;local V=m.show_usage_error;m.show_usage_error="throw"T,y=pcall(J,K,R)m.show_usage_error=V;if T then return y,S or'string'end;return R,S or'string'end end;function m.process_options_string(i,W)local X={}local Y;local arg=W or _G.arg;n={}o={}p={}q={}local function Z(g)local _,a0=g:gsub('^%.%.%.%s*','')return _,a0>0 end;local function a1(K,F,y)F=type(F)=="string"and F:gsub("%W","_")or F;if not K.varargs then X[F]=y else if not X[F]then X[F]={y}else d(X[F],y)end end end;r=i;for a2,a3 in ipairs(arg)do if a3=="-h"or a3=="--help"then return m.quit()end end;for a4 in f(i)do local _={}local a5,a6,S,N,a7;a4=h(a4)local function a8(i)return c(i,a4,_)end;if a8'-$v{short}, --$o{long} $'or a8'-$v{short} $'or a8'--$o{long} $'then if _.long then a5=_.long:gsub('[^%w%-]','_')if#_.rest==1 then a5=a5 .._.rest end;if _.short then p[_.short]=a5 end else a5=_.short end;if _.short and not m.slack then O(_.short)end;_.rest,Y=Z(_.rest)elseif a8'$<{name} $'then a5,a7=_.name:match'([^%.]+)(.*)'a5=a5:gsub('%A','_')Y=a7=='...'d(q,a5)end;if _.rest then a4=_.rest;_={}local a9;if c('$({def} $',a4,_)or c('$({def}',a4,_)then local aa=j(_.def)local ab,a7=aa:match('^(%S+)(.*)$')a7=j(a7)if ab=='optional'then ab,a7=a7:match('^(%S+)(.*)$')a7=j(a7)a9=true end;local ac;if ab=='default'then ac=true;if a7==''then m.error("value must follow default")end else if c('$f{min}..$f{max}',ab,_)then local D,E=_.min,_.max;S='number'N=function(C)B(C,D,E,a5)end elseif not ab:match'|'then S=ab else local ad=ab;local ae='|'..ad..'|'S='string'N=function(g)m.assert(ae:match('|'..g..'|'),"value '"..g.."' not in "..ad)end end end;_.rest=a7;aa=_.rest;if ac or c('default $r{rest}',aa,_)then a6,S=Q(_.rest,S)end else a6=false;S='boolean'end;local K={type=S,defval=a6,required=a6==nil and not a9,comment=_.rest or a5,constraint=N,varargs=Y}Y=nil;if H[S]then local M=H[S].converter;if type(M)=='string'then K.type=M else K.converter=M end;K.constraint=H[S].constraint elseif not I[S]and S then m.error(S.." is unknown type")end;o[a5]=K end end;local af=1;local ag=1;local ah=1;local F,K,y;local ai=false;local function aj(F)local ak=F:find'[=:]'if ak then e(arg,ah+1,F:sub(ak+1))F=F:sub(1,ak-1)end;return F,ak end;local function al(F)return o[p[F]or F]end;while ah<=#arg do local am=arg[ah]local _={}if am=='--'then ai=true;af=#q+1;ah=ah+1;am=arg[ah]if not am then break end end;if not ai and(c('--$S{long}',am,_)or c('-$S{short}',am,_))then if _.long then F=aj(_.long)elseif#_.short==1 or al(_.short)then F=_.short else local an,ao=aj(_.short)if not ao then F=k(an,1)local ap=al(F)if ap and ap.type~='boolean'then e(arg,ah+1,an:sub(2))else for l=2,#an do e(arg,ah+l-1,'-'..k(an,l))end end else F=an end end;if p[F]then F=p[F]end;if not o[F]and(F=='h'or F=='help')then m.quit()end else F=q[af]if not F then F=ag;K={type='string'}o[F]=K;ag=ag+1 else K=o[F]end;if not K.varargs then af=af+1 end;y=am end;K=o[F]if not K then m.error("unrecognized parameter: "..F)end;if K.type~='boolean'then if not y then ah=ah+1;y=arg[ah]am=y end;m.assert(y,F.." was expecting a value")else y=not K.defval end;K.used=true;y=J(K,y)a1(K,F,y)if I[K.type]=='file'then a1(K,F..'_name',am)end;if m.callback then m.callback(F,am,_)end;ah=ah+1;y=nil end;for F,K in pairs(o)do if not K.used then if K.required then m.error("missing required parameter: "..F)end;a1(K,F,K.defval)end end;return X end;if arg then s=arg[0]s=s or rawget(_G,"LAPP_SCRIPT")or"unknown"s=s:gsub('.+[\\/]',''):gsub('%.%a+$','')else s="inter"end;setmetatable(m,{__call=function(aq,i,W)return m.process_options_string(i,W)end})return m