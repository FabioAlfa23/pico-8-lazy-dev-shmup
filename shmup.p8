pico-8 cartridge // http://www.pico-8.com
version 43
__lua__
function _init()
	cls()
	bg=0
	c=0	
	player=playerinit(64,130,2,2,3,4,8)
	bullet={}
	score=flr(rnd(3000))
	lives=4
	star=starinit()
	mode="start"
end 


function _update()
	starscroll(star)
	--game state machine--
	if mode=="start" then
	--start screen state--
		startupdate()
	elseif mode=="play" then
	--game loop state--
		
		player=playerupdate(player)
		
		if btnp(❎) then
			local mybull={}
			mybull=bulletinit(player.x,player.y,16,17,7,0,7,5)
			sfx(mybull.sound)
			add(bullet,mybull)
		end		
		
		for i=#bullet, 1,-1 do 
			bulletshoot(bullet[i],player)
			if bullet[i].by<-8 then
				del(bullet,bullet[i])
			end
		end			
			
	elseif mode=="end" then
		c=0
	--gameover screen state--
		endupdate(player,bullet)
	elseif mode=="st_anim" then
	--animation between start screen--
	--and play loop--
		animupdate(player)
	else
		
	end
end


function _draw()

	cls(bg)
	starfield(star)
	if mode=="start" then
		bg=0
		startdraw()
	elseif mode=="play" then
		bg=0
		playerdraw(player)
		for i=1,#bullet do
			bulletdraw(bullet[i],player)
		end
		drawui(score,lives,player)
		print(#bullet)
	elseif mode=="end" then
		bg=8
		enddraw()
		
	elseif mode=="st_anim" then
		bg=0
		animdraw(player)
	else
	
	end
	
end
-->8
function playerinit(sx,sy,sspd,sspt,ssht,safi,saff)
	player={
		x=sx,
		y=sy,
		speed=sspd,
		sprite=sspt,
		hp=ssht,
		asprite=safi,
		afi=safi,
		aff=saff
	}
	return player		
end

function playerupdate(p)
	local lx=p.x
	local ly=p.y
	
	p.sprite=2
	
	p.asprite+=1
	if p.asprite>p.aff then
		p.asprite=p.afi
	end
	
	if btn(⬅️) then
			p.x-=p.speed
			p.sprite=1
	end
	if btn(➡️) then
			p.x+=p.speed
			p.sprite=3
	end
	if btn(⬆️) then
			p.y-=p.speed
	end
	if btn(⬇️) then
			p.y+=p.speed
	end
	if btnp(🅾️) then
		mode="end"
	end
	if playercollidex(p)==1 then 
		p.x=127 
	elseif playercollidex(p)==2 then
		p.x=-7
	end
	if playercollidey(p)==1 then
	 p.y=ly
 end
	return player 
end

function playerdraw(p)
	spr(p.sprite,p.x,p.y)
	spr(p.asprite,p.x,p.y+8)
end
-->8
function playercollidex(p)
	local flg
	if p.x<-7 then
	 flg=1
 elseif p.x>127 then
	 flg=2
 else
 	flg=0
 end
	return flg 
end

function playercollidey(p)
	local flg
	if p.y<0 then
	 flg=1
 elseif p.y>120 then
 	flg=1
 else
 	flg=0
 end
	return flg 
end

function drawui(sc,lives,p)
	for i=0,lives-1 do
		if i<p.hp then
			spr(14,(i*9)+1,1)
		else
			spr(15,(i*9)+1,1)
		end
	end
	print("score: "..score,45,1,12)
end


-->8
function bulletinit(x,y,t,tf,sp,fx,fsz,ffx)
	local bulletinit={}
	
	bulletinit.bx=x
	bulletinit.by=y
	bulletinit.sprite=t
	bulletinit.fi=t
	bulletinit.ff=tf
	bulletinit.speed=sp
	bulletinit.sound=fx
	bulletinit.sflashsz=fsz
	bulletinit.flashsz=fsz
	bulletinit.flashx=ffx
	
	return bulletinit
end

function bulletshoot(b,p)
	b.sprite+=1
	b.flashsz-=1
	b.by-=b.speed
	
	--if btnp(❎) then
		--b.bx=p.x
		--b.by=p.y
		--sfx(0)
		--b.flashsz=b.sflashsz
		--b.sprite=b.fi
	--end
	
	if b.flashsz<-1 then
		b.flashsz=-1
	end
	
	if b.sprite>b.ff then
		b.sprite=b.ff
	end	
		
	--return b
end

function bulletdraw(b,p)
	circfill(b.bx+3.5,p.y-b.flashx,b.flashsz,7)
	spr(b.sprite,b.bx,b.by)
end
		
-->8
function starinit()
	star={
		n=100,
		x={},
		y={},
		spd={},
		col={},
		palette={6,7,10,12,7,7,7,6,7}
	}
	
	for i=1,star.n do
		star.spd[i]=rnd(1.5)+0.5
		star.x[i]=flr(rnd(128))
		star.y[i]=flr(rnd(128))
		star.col[i]=star.palette[flr(rnd(9))]
	end
	return star
end

function starscroll(s)
	for i=1,s.n do
		s.y[i]+=s.spd[i]
		if s.y[i]>128 then
			s.y[i]=0
			s.x[i]=flr(rnd(128))
			s.col[i]=s.palette[flr(rnd(9))]
		end
	end
end

function starfield(star)
	for i=1,star.n do		
		pset(star.x[i],star.y[i],star.col[i])
	end
end
-->8
function startupdate()
	if btnp(❎) then
		mode="st_anim"
	end
 local	c={7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5}
	
end

function startdraw()
	print("shmup", 55, 30,7)
	
	--for i=1, 60 do
	print("press ❎ to start", 30,90, 5)
		
	--end	
end

function animupdate(p)
	if p.y>64 then
	 p.y-=(p.speed*2)
	else
		mode="play"
	end
end 

function animdraw(p)
	playerdraw(p)
end

function endupdate(p,b)
	player=playerinit(64,130,2,2,3,4,8)
	bullet=bulletinit(-1,-1,16,17,7,0,7,5)
	c+=1
	if c>3000 or btnp(❎) then
		mode="start"
	end
	
end 

function enddraw()
	print("game over",40,30,7)
	print("press ❎ to restart", 30, 100, 5)
end
__gfx__
000000000a000a00a000000a00a000a0077007700770077007700770077007700770077000000000000000000000000000000000000000000880088008800880
0000000008d008d08d0000d80d800d80c77cc77cc77cc77c77700777c77cc77c77c00c7700000000000000000000000000000000000000008888878880088708
007007000550055055000055055005500cc00cc0cccccccc77c00c7707cccc70cc0000cc00000000000000000000000000000000000000008888887880000078
00077000056205d05d06d0d50d502650000000000cc00cc0c700007c0cc00cc00000000000000000000000000000000000000000000000008888887880000078
0007700005ddd58258dd6d85285ddd5000000000000000000c0000c0000000000000000000000000000000000000000000000000000000000888888008000080
00700700056dd5dd5dd6ddd5dd5dd650000000000000000000000000000000000000000000000000000000000000000000000000000000000088880000800800
00000000aaadd75575daad57557ddaaa000000000000000000000000000000000000000000000000000000000000000000000000000000000008800000088000
000000006ccdd666665cc566666ddcc6000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009999009a7777a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009aa9009a7777a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009aa9009a7777a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
009999009a7777a90000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000009aaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000009999000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100003b0503a050370503405032050300502d0502905029050240502605023050210501e0501a0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
