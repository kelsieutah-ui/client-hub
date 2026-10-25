#!/usr/bin/env python3
"""Kelsie Jimenez seasonal signature banner.
Usage: python3 banner.py THEME [--tagline "text"] [--out banner.gif]
THEMES: plain, halloween, pie, newyear, sparkle
"""
import sys, os, math, random, argparse, subprocess, shutil, tempfile
from PIL import Image, ImageDraw, ImageFont, ImageChops
HERE=os.path.dirname(os.path.abspath(__file__)); A=lambda f: os.path.join(HERE,'assets',f)
S=3; W,H=920,300
GOLD=(201,164,76); GLINT=(255,240,190); INK=(255,255,255); GREY=(175,175,175)
cx,cy,R=172,150,124; RR,RW=137,5; DX=340; TX=374
ease=lambda t: 0 if t<=0 else 1 if t>=1 else t*t*(3-2*t)
def seg(t,a,b): return ease((t-a)/(b-a))
def spaced(d,xy,text,font,fill,track):
    x,y=xy
    for ch in text: d.text((x,y),ch,font=font,fill=fill); x+=d.textlength(ch,font=font)+track

def build_base(style='script'):
    base=Image.new('RGB',(W*S,H*S),(0,0,0))
    ph=Image.open(A('headshot.jpg')).convert('RGB'); d=2*R*S; ph=ph.resize((d,d),Image.LANCZOS)
    m=Image.new('L',(d,d),0); ImageDraw.Draw(m).ellipse((0,0,d-1,d-1),fill=255)
    base.paste(ph,((cx-R)*S,(cy-R)*S),m)
    dr=ImageDraw.Draw(base)
    spaced(dr,(TX*S,160*S),'DIRECTOR OF AGENT DEVELOPMENT',ImageFont.truetype(A('LiberationSans-Bold.ttf'),19*S),INK,4.2*S)
    dr.text((TX*S,200*S),'The Perry Group  |  Real Broker LLC',font=ImageFont.truetype(A('LiberationSans-Regular.ttf'),21*S),fill=GREY)
    name=Image.new('L',(W*S,H*S),0)
    if style=='print':
        ImageDraw.Draw(name).text((TX*S,58*S),'Kelsie Jimenez',font=ImageFont.truetype(A('LiberationSerif-Regular.ttf'),60*S),fill=255)
    else:
        ImageDraw.Draw(name).text((TX*S-4*S,22*S),'Kelsie Jimenez',font=ImageFont.truetype(A('great-vibes.woff'),84*S),fill=255)
    return base,name

def signature(im,name,t):
    g=ImageDraw.Draw(im); nb=name.getbbox(); x0,x1=nb[0],nb[2]
    w=seg(t,0.15,1.75)
    if w>0:
        edge=x0+(x1-x0+40*S)*w; m=Image.new('L',(W*S,H*S),0)
        m.paste(255,(0,0,max(0,int(edge-40*S)),H*S))
        ramp=Image.linear_gradient('L').rotate(90,expand=True).resize((40*S,H*S)).transpose(Image.FLIP_LEFT_RIGHT)
        m.paste(ramp,(int(edge-40*S),0)); im.paste(INK,(0,0,W*S,H*S),ImageChops.multiply(name,m))
    bb=[(cx-RR)*S,(cy-RR)*S,(cx+RR)*S,(cy+RR)*S]
    p=seg(t,0.4,1.8)
    if p>0:
        g.arc(bb,-90,-90+360*p,fill=GOLD,width=RW*S)
        if p<1:
            a=math.radians(-90+360*p); r=RW*S/2; x=(cx+RR*math.cos(a))*S; y=(cy+RR*math.sin(a))*S
            g.ellipse((x-r,y-r,x+r,y+r),fill=GOLD)
    q=seg(t,1.4,2.0)
    if q>0: h=95*q; g.rectangle(((DX-1)*S,(150-h)*S,(DX+1)*S,(150+h)*S),fill=GOLD)
    u=seg(t,1.8,2.35)
    if u>0: g.rectangle((TX*S,142*S,(TX+64*u)*S,145*S),fill=GOLD)
    return g

def glint(g,t,start):
    k=(t-start)/0.9
    if 0<k<1:
        c=-90+360*ease(k)
        for i in range(24):
            wv=max(0,1-abs(i-12)/12); col=tuple(int(GOLD[j]+(GLINT[j]-GOLD[j])*wv) for j in range(3))
            a0=c+(i-12)*1.4; g.arc([(cx-RR)*S,(cy-RR)*S,(cx+RR)*S,(cy+RR)*S],a0,a0+1.6,fill=col,width=RW*S)

def tagline(im,text,t,start,color=GOLD):
    a=seg(t,start,start+0.6)
    if a<=0 or not text: return
    f=ImageFont.truetype(A('great-vibes.woff'),40*S)
    layer=Image.new('L',(W*S,H*S),0); d=ImageDraw.Draw(layer)
    tw=d.textlength(text,font=f); d.text(((W-22)*S-tw,232*S),text,font=f,fill=int(255*a))
    im.paste(color,(0,0,W*S,H*S),layer)

# ---------- theme sprites ----------
def bat(g,x,y,s,flap,col):
    w=math.sin(flap)*0.6
    pts=[(0,0),(-.35,-.15-w*.2),(-.7,-.45-w),(-1,-.2-w*.8),(-.85,.05),(-.65,0),(-.5,.18),(-.25,.08),(0,.22),
         (.25,.08),(.5,.18),(.65,0),(.85,.05),(1,-.2-w*.8),(.7,-.45-w),(.35,-.15-w*.2)]
    g.polygon([((x+px*s)*S,(y+py*s)*S) for px,py in pts],fill=col)
    g.ellipse(((x-.12*s)*S,(y-.22*s)*S,(x+.12*s)*S,(y+.12*s)*S),fill=col)

def pie(g,x,y,s,rot,col_crust=(214,160,82),col_fill=(170,30,45)):
    g.ellipse(((x-s)*S,(y-s*.45)*S,(x+s)*S,(y+s*.45)*S),fill=col_crust)
    g.ellipse(((x-s*.82)*S,(y-s*.36)*S,(x+s*.82)*S,(y+s*.30)*S),fill=col_fill)
    for i in range(-2,3):   # lattice
        ox=i*s*.32; g.line(((x+ox-s*.15)*S,(y-s*.33)*S,(x+ox+s*.15)*S,(y+s*.28)*S),fill=col_crust,width=max(2,int(s*.12*S)))
        oy=i*s*.13; g.line(((x-s*.78)*S,(y+oy)*S,(x+s*.78)*S,(y+oy)*S),fill=col_crust,width=max(2,int(s*.10*S)))

def sparkle(g,x,y,s,col):
    for ang in (0,90):
        a=math.radians(ang)
        pts=[(x+math.cos(a)*s,y+math.sin(a)*s),(x+math.cos(a+math.pi/2)*s*.18,y+math.sin(a+math.pi/2)*s*.18),
             (x-math.cos(a)*s,y-math.sin(a)*s),(x-math.cos(a+math.pi/2)*s*.18,y-math.sin(a+math.pi/2)*s*.18)]
        g.polygon([(px*S,py*S) for px,py in pts],fill=col)

def theme_overlay(theme,im,g,t,rng_state):
    if theme=='halloween':
        for i,(x0,y0,sp,s,ph) in enumerate(rng_state):
            k=t-2.2-i*0.12
            if 0<k<2.4:
                x=x0+sp*k*240; y=y0-k*95+math.sin(k*5+ph)*12
                if -40<x<W+40: bat(g,x,y,s,k*22+ph,(235,120,30) if i%3==0 else (230,230,230))
    elif theme=='pie':
        for (x0,delay,s,vy) in rng_state:
            k=t-2.2-delay
            if k>0:
                y=-40+vy*k*k*260
                if y<H+40: pie(g,x0+math.sin(k*3+x0)*6,y,s,0)
    elif theme in ('newyear','sparkle'):
        for (x,y,s,ph) in rng_state:
            k=t-2.0
            if k>0:
                tw=max(0,math.sin(k*4+ph))**3
                if tw>0.05:
                    c=tuple(int(GOLD[j]+(GLINT[j]-GOLD[j])*tw) for j in range(3))
                    sparkle(g,x,y,s*(0.4+0.6*tw),c)

def theme_state(theme):
    rnd=random.Random(7)
    if theme=='halloween':
        return [(rnd.uniform(40,360),rnd.uniform(200,290),rnd.uniform(1.7,2.3),rnd.uniform(30,42),rnd.uniform(0,6)) for _ in range(5)]
    if theme=='pie':
        xs=[420,560,700,840,490,630,770,880,380]
        return [(x+rnd.uniform(-15,15),rnd.uniform(0,1.3),rnd.uniform(26,34),rnd.uniform(.9,1.2)) for x in xs]
    if theme in ('newyear','sparkle'):
        pts=[]
        while len(pts)<30:
            x,y=rnd.uniform(20,W-20),rnd.uniform(15,H-15)
            if (x-cx)**2+(y-cy)**2>(RR+18)**2 and not (TX-10<x<840 and 25<y<230): pts.append((x,y,rnd.uniform(6,12),rnd.uniform(0,6.28)))
        return pts
    return None

DEFAULT_TAG={'halloween':'Happy Halloween','pie':'Pie Night  ·  Nov 23','newyear':'Happy New Year','plain':'','sparkle':''}
DUR={'plain':3.5,'halloween':5.2,'pie':5.0,'newyear':5.5,'sparkle':5.0}

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('theme'); ap.add_argument('--tagline'); ap.add_argument('--out',default='banner.gif'); ap.add_argument('--width',type=int,default=920); ap.add_argument('--name',choices=['script','print'],default='script')
    a=ap.parse_args(); theme=a.theme; tag=a.tagline if a.tagline is not None else DEFAULT_TAG.get(theme,'')
    base,name=build_base(a.name); st=theme_state(theme); T=DUR.get(theme,4); fps=20
    tmp=tempfile.mkdtemp(); n=int(T*fps)+1
    tag_start={'halloween':4.0,'pie':4.1,'newyear':2.6,'sparkle':2.6}.get(theme,2.6)
    for i in range(n):
        t=i/fps; im=base.copy(); g=signature(im,name,t); glint(g,t,2.45)
        if st: theme_overlay(theme,im,g,t,st)
        tagline(im,tag,t,tag_start)
        im.resize((W,H),Image.LANCZOS).save(f'{tmp}/f{i:03d}.png')
    # hold last frame 1s more
    sc=f'scale={a.width}:-1:flags=lanczos,' if a.width!=W else ''
    subprocess.run(['ffmpeg','-loglevel','error','-y','-framerate',str(fps),'-i',f'{tmp}/f%03d.png','-vf',f'{sc}palettegen=max_colors=256',f'{tmp}/p.png'],check=True)
    subprocess.run(['ffmpeg','-loglevel','error','-y','-framerate',str(fps),'-i',f'{tmp}/f%03d.png','-i',f'{tmp}/p.png','-lavfi',f'{sc.rstrip(",") + "[x];[x]" if sc else ""}[1:v]paletteuse=dither=none:diff_mode=rectangle'.replace('[x];[x][1:v]','[x];[x][1:v]') if False else (f'{sc}null[x];[x][1:v]paletteuse=dither=none:diff_mode=rectangle'),'-loop','0','-final_delay','1000',a.out],check=True)
    Image.open(f'{tmp}/f{n-1:03d}.png').save(os.path.splitext(a.out)[0]+'_final.png')
    shutil.copy(f'{tmp}/f{int(min(n-1,4.0*fps)):03d}.png',os.path.splitext(a.out)[0]+'_mid.png')
    shutil.rmtree(tmp); print('wrote',a.out,os.path.getsize(a.out),'bytes')
if __name__=='__main__': main()
