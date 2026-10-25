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

def tagline(im,text,t,start,color=GOLD,right=None):
    a=seg(t,start,start+0.6)
    if a<=0 or not text: return
    f=ImageFont.truetype(A('great-vibes.woff'),40*S)
    layer=Image.new('L',(W*S,H*S),0); d=ImageDraw.Draw(layer)
    tw=d.textlength(text,font=f); d.text((((right or W-22))*S-tw,232*S),text,font=f,fill=int(255*a))
    im.paste(color,(0,0,W*S,H*S),layer)

# ---------- theme sprites ----------
def bat(g,x,y,s,flap,col):
    w=math.sin(flap)*0.6
    pts=[(0,0),(-.35,-.15-w*.2),(-.7,-.45-w),(-1,-.2-w*.8),(-.85,.05),(-.65,0),(-.5,.18),(-.25,.08),(0,.22),
         (.25,.08),(.5,.18),(.65,0),(.85,.05),(1,-.2-w*.8),(.7,-.45-w),(.35,-.15-w*.2)]
    g.polygon([((x+px*s)*S,(y+py*s)*S) for px,py in pts],fill=col)
    g.ellipse(((x-.12*s)*S,(y-.22*s)*S,(x+.12*s)*S,(y+.12*s)*S),fill=col)

_PIE_CACHE={}
def _pie_sprite(kind):
    if kind in _PIE_CACHE: return _PIE_CACHE[kind]
    from PIL import ImageFilter
    D=400; R=190; c=D/2
    im=Image.new('RGBA',(D,D),(0,0,0,0)); d=ImageDraw.Draw(im)
    # fluted crust edge
    pts=[]
    for i in range(360):
        a=math.radians(i); r=R*(1+0.035*math.cos(a*26))
        pts.append((c+r*math.cos(a),c+r*math.sin(a)))
    d.polygon(pts,fill=(196,138,66,255))
    d.ellipse((c-R*.93,c-R*.93,c+R*.93,c+R*.93),fill=(222,170,96,255))
    d.ellipse((c-R*.86,c-R*.86,c+R*.86,c+R*.86),fill=(205,150,78,255))
    # filling with soft radial gradient
    fill=Image.new('RGBA',(D,D),(0,0,0,0)); fd=ImageDraw.Draw(fill)
    if kind=='pumpkin': inner,outer=(236,146,58),(196,102,34)
    else: inner,outer=(214,150,70),(170,100,40)
    steps=40
    for k in range(steps):
        t=k/(steps-1); r=R*.80*(1-t*.98)
        col=tuple(int(outer[j]+(inner[j]-outer[j])*t) for j in range(3))+(255,)
        fd.ellipse((c-r,c-r,c+r,c+r),fill=col)
    im.alpha_composite(fill)
    if kind=='lattice':
        strip=Image.new('RGBA',(D,D),(0,0,0,0)); sd=ImageDraw.Draw(strip)
        for i in range(-2,3):
            o=i*R*.32
            sd.line((c+o,c-R*.8,c+o,c+R*.8),fill=(226,176,104,255),width=int(R*.17))
            sd.line((c-R*.8,c+o,c+R*.8,c+o),fill=(214,162,92,255),width=int(R*.17))
        m=Image.new('L',(D,D),0); ImageDraw.Draw(m).ellipse((c-R*.82,c-R*.82,c+R*.82,c+R*.82),fill=255)
        strip.putalpha(ImageChops.multiply(strip.getchannel('A'),m)); im.alpha_composite(strip)
    # glossy highlight
    hl=Image.new('RGBA',(D,D),(0,0,0,0)); ImageDraw.Draw(hl).ellipse((c-R*.55,c-R*.62,c+R*.05,c-R*.18),fill=(255,240,210,70))
    hl=hl.filter(ImageFilter.GaussianBlur(14)); im.alpha_composite(hl)
    _PIE_CACHE[kind]=im; return im

def pie(im,x,y,s,rot,tilt,kind='pumpkin'):
    spr=_pie_sprite(kind)
    w=int(2*s*S); squash=max(0.18,abs(math.cos(tilt))); h=max(2,int(w*squash))
    thick=int(s*S*0.28*abs(math.sin(tilt)))
    layer=Image.new('RGBA',(w,h+thick+2),(0,0,0,0)); ld=ImageDraw.Draw(layer)
    if thick>0:  # crust side band
        ld.ellipse((0,thick,w-1,thick+h-1),fill=(150,98,44,255))
        ld.rectangle((0,h//2,w-1,thick+h//2),fill=(150,98,44,255))
    top=spr.resize((w,h),Image.LANCZOS); layer.alpha_composite(top,(0,0))
    layer=layer.rotate(rot,resample=Image.BICUBIC,expand=True)
    im.paste(layer,(int(x*S-layer.width/2),int(y*S-layer.height/2)),layer)


def back_ease(t):
    if t<=0: return 0
    if t>=1: return 1
    c1=1.70158; c3=c1+1; return 1+c3*(t-1)**3+c1*(t-1)**2

def snowman(g,x,base,sc):
    """x center, base = ground y, sc = scale (1 = ~118px tall at 2x)"""
    if sc<=0.02: return
    def circ(cx_,cy_,r,fill): g.ellipse(((cx_-r)*S,(cy_-r)*S,(cx_+r)*S,(cy_+r)*S),fill=fill)
    w=(245,245,248); sh=(214,220,230)
    r1,r2,r3=30*sc,22*sc,16*sc
    y1=base-r1; y2=y1-r1-r2+8*sc; y3=y2-r2-r3+6*sc
    for cy_,r in ((y1,r1),(y2,r2),(y3,r3)):
        circ(x,cy_,r,sh); circ(x-r*.12,cy_-r*.12,r*.9,w)
    # scarf (gold)
    g.rounded_rectangle(((x-r2*.95)*S,(y2-r2+2*sc)*S,(x+r2*.95)*S,(y2-r2+9*sc)*S),radius=3*sc*S,fill=GOLD)
    g.rectangle(((x+r2*.3)*S,(y2-r2+6*sc)*S,(x+r2*.65)*S,(y2-r2+22*sc)*S),fill=GOLD)
    # face
    for dx in (-5,5): circ(x+dx*sc,y3-3*sc,1.9*sc,(25,25,25))
    g.polygon([((x)*S,(y3+1*sc)*S),((x+11*sc)*S,(y3+3*sc)*S),((x)*S,(y3+5*sc)*S)],fill=(236,120,40))
    for i,dx in enumerate((-6,-2,2,6)): circ(x+dx*sc,y3+8*sc+abs(dx)*-.25*sc,1.2*sc,(25,25,25))
    # buttons
    for dy in (-8,2): circ(x,y2+dy*sc,2.2*sc,(25,25,25))
    circ(x,y1-12*sc,2.4*sc,(25,25,25))
    # hat
    g.rectangle(((x-15*sc)*S,(y3-r3+2*sc)*S,(x+15*sc)*S,(y3-r3+6*sc)*S),fill=(20,20,20))
    g.rectangle(((x-10*sc)*S,(y3-r3-16*sc)*S,(x+10*sc)*S,(y3-r3+3*sc)*S),fill=(20,20,20))
    g.rectangle(((x-10*sc)*S,(y3-r3-2*sc)*S,(x+10*sc)*S,(y3-r3+1*sc)*S),fill=GOLD)
    # stick arms
    g.line(((x-r2*.9)*S,(y2)*S,(x-r2*1.9)*S,(y2-12*sc)*S),fill=(110,72,40),width=max(2,int(2.4*sc*S)))
    g.line(((x+r2*.9)*S,(y2)*S,(x+r2*1.9)*S,(y2-14*sc)*S),fill=(110,72,40),width=max(2,int(2.4*sc*S)))

TREE_X,TREE_BASE,TREE_H=868,290,135
def tree(g,star_glow,ornaments=1.0):
    x=TREE_X; b=TREE_BASE; h=TREE_H
    g.rectangle(((x-7)*S,(b-14)*S,(x+7)*S,(b)*S),fill=(110,72,40))
    greens=[(26,92,52),(30,104,58),(36,118,66)]
    tiers=[(b-14,50,h*.42),(b-14-h*.28,40,h*.40),(b-14-h*.54,29,h*.38)]
    for (yb,hw,th),col in zip(tiers,greens):
        g.polygon([((x-hw)*S,yb*S),((x+hw)*S,yb*S),(x*S,(yb-th)*S)],fill=col)
    if ornaments>0:
        rnd=random.Random(3)
        for i in range(14):
            fy=rnd.uniform(0.1,0.85); yy=b-14-fy*(h-20); half=50*(1-fy)*0.8
            xx=x+rnd.uniform(-half,half); r=3.2
            col=GOLD if i%2 else (196,40,52)
            g.ellipse(((xx-r)*S,(yy-r)*S,(xx+r)*S,(yy+r)*S),fill=col)
    # star
    top=b-14-h*.54-h*.38
    sc=1+0.25*star_glow
    col=tuple(int(120+(GLINT[j]-120)*star_glow) if j<2 else int(80+(GLINT[j]-80)*star_glow) for j in range(3))
    pts=[]
    for i in range(10):
        a=-math.pi/2+i*math.pi/5; r=(11 if i%2==0 else 4.6)*sc
        pts.append(((x+r*math.cos(a))*S,(top+r*math.sin(a))*S))
    g.polygon(pts,fill=col)
    return top


def _rot_ellipse(cx_,cy_,rx,ry,ang,n=28):
    ca,sa=math.cos(ang),math.sin(ang); pts=[]
    for i in range(n):
        u=2*math.pi*i/n; ex,ey=rx*math.cos(u),ry*math.sin(u)
        pts.append(((cx_+ex*ca-ey*sa)*S,(cy_+ex*sa+ey*ca)*S))
    return pts

def turkey(g,x,base,sc,fan):
    if sc<=0.02: return
    body_y=base-26*sc
    cols=[(150,74,34),(201,164,76),(214,104,40),(170,40,40),(214,104,40),(201,164,76),(150,74,34)]
    n=len(cols); spread=math.radians(150)*max(0.05,fan)
    for i,c in enumerate(cols):          # tail feathers fanning out behind
        a=-math.pi/2+(i-(n-1)/2)*(spread/(n-1))
        fx=x+math.cos(a)*30*sc; fy=body_y-6*sc+math.sin(a)*30*sc
        g.polygon(_rot_ellipse(fx,fy,30*sc,11*sc,a),fill=c)
        g.polygon(_rot_ellipse(x+math.cos(a)*48*sc,body_y-6*sc+math.sin(a)*48*sc,9*sc,7*sc,a),fill=(250,232,190) if i%2 else (240,200,120))
    # feet
    for dx in (-8,8):
        g.line(((x+dx*sc)*S,(base-8*sc)*S,(x+dx*sc)*S,base*S),fill=(236,150,50),width=max(2,int(3*sc*S)))
        g.line(((x+dx*sc-5*sc)*S,base*S,(x+dx*sc+5*sc)*S,base*S),fill=(236,150,50),width=max(2,int(3*sc*S)))
    # body
    g.ellipse(((x-24*sc)*S,(body_y-24*sc)*S,(x+24*sc)*S,(body_y+20*sc)*S),fill=(120,70,38))
    g.ellipse(((x-15*sc)*S,(body_y-8*sc)*S,(x+15*sc)*S,(body_y+16*sc)*S),fill=(150,92,50))
    # head
    hy=body_y-30*sc
    g.ellipse(((x-12*sc)*S,(hy-12*sc)*S,(x+12*sc)*S,(hy+12*sc)*S),fill=(140,84,46))
    for dx in (-5,5):
        g.ellipse(((x+dx*sc-3*sc)*S,(hy-5*sc)*S,(x+dx*sc+3*sc)*S,(hy+1*sc)*S),fill=(255,255,255))
        g.ellipse(((x+dx*sc-1.6*sc)*S,(hy-3.6*sc)*S,(x+dx*sc+1.6*sc)*S,(hy-0.4*sc)*S),fill=(20,20,20))
    g.polygon([((x-4*sc)*S,(hy+2*sc)*S),((x+4*sc)*S,(hy+2*sc)*S),(x*S,(hy+9*sc)*S)],fill=(240,170,50))
    g.ellipse(((x+1*sc)*S,(hy+5*sc)*S,(x+6*sc)*S,(hy+15*sc)*S),fill=(200,40,40))

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
                if y<H+50: pie(im,x0+math.sin(k*3+x0)*6,y,s,math.sin(k*2+x0)*35,k*3.2+x0,'lattice' if int(x0)%4==0 else 'pumpkin')
    elif theme in ('snow','snowman'):
        if theme=='snowman':
            p=back_ease((t-2.4)/0.7)
            snowman(g,872,294,p*0.95)
        for (x0,y0,s,sp,ph) in rng_state:
            k=t-0.3
            if k>0:
                y=(y0+sp*k*45)%(H+30)-15; x=x0+math.sin(k*1.5+ph)*10
                a=min(1,k/1.5)
                c=tuple(int(255*a) for _ in range(3))
                g.ellipse(((x-s)*S,(y-s)*S,(x+s)*S,(y+s)*S),fill=c)
    elif theme=='turkey':
        p=back_ease((t-2.4)/0.7); fan=seg(t,2.9,3.6)
        turkey(g,866,292,p*0.95,fan)
    elif theme=='tree':
        k=(t-1.9)/1.8                       # sparkle swirl duration
        glow=seg(t,3.6,4.1)
        top=tree(g,glow)
        if 0<k<1.15:
            for j in range(26):
                kk=min(1,k)-j*0.012
                if kk<0: continue
                yy=TREE_BASE-10-(TREE_BASE-10-top)*kk
                frac=(TREE_BASE-14-yy)/TREE_H
                rad=max(4,58*(1-frac))
                ang=kk*math.pi*6
                xx=TREE_X+rad*math.cos(ang)
                fade=max(0,1-j/26)*(1 if k<1 else max(0,1-(k-1)/0.15))
                c=tuple(int(GOLD[q]+(GLINT[q]-GOLD[q])*fade) for q in range(3))
                if j==0: sparkle(g,xx,yy,9,GLINT)
                else:
                    r=2.2*fade+0.4
                    g.ellipse(((xx-r)*S,(yy-r)*S,(xx+r)*S,(yy+r)*S),fill=c)
        if glow>0:   # twinkle rays at the star
            tw=0.6+0.4*math.sin(t*6)
            sparkle(g,TREE_X,top,16*glow*tw,GLINT)
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
        xs=[450,620,790,540,710,870]
        return [(x+rnd.uniform(-15,15),rnd.uniform(0,1.4),rnd.uniform(40,50),rnd.uniform(.85,1.1)) for x in xs]
    if theme in ('snow','snowman'):
        out=[]
        while len(out)<34:
            x,y=rnd.uniform(5,W-5),rnd.uniform(0,H)
            if (x-cx)**2+(y-cy)**2>(RR+8)**2: out.append((x,y,rnd.uniform(1.2,3.2),rnd.uniform(0.6,1.4),rnd.uniform(0,6.28)))
        return out
    if theme in ('newyear','sparkle'):
        pts=[]
        while len(pts)<30:
            x,y=rnd.uniform(20,W-20),rnd.uniform(15,H-15)
            if (x-cx)**2+(y-cy)**2>(RR+18)**2 and not (TX-10<x<840 and 25<y<230): pts.append((x,y,rnd.uniform(6,12),rnd.uniform(0,6.28)))
        return pts
    return None

DEFAULT_TAG={'turkey':'Happy Thanksgiving','snowman':'Happy Holidays','tree':'Merry Christmas','snow':'Happy Holidays','halloween':'Happy Halloween','pie':'Pie Night  ·  Nov 23','newyear':'Happy New Year','plain':'','sparkle':''}
DUR={'turkey':5.0,'snowman':5.0,'tree':5.2,'snow':5.0,'plain':3.5,'halloween':5.2,'pie':5.0,'newyear':5.5,'sparkle':5.0}

def main():
    ap=argparse.ArgumentParser(); ap.add_argument('theme'); ap.add_argument('--tagline'); ap.add_argument('--out',default='banner.gif'); ap.add_argument('--width',type=int,default=920); ap.add_argument('--name',choices=['script','print'],default='script')
    a=ap.parse_args(); theme=a.theme; tag=a.tagline if a.tagline is not None else DEFAULT_TAG.get(theme,'')
    base,name=build_base(a.name); st=theme_state(theme); T=DUR.get(theme,4); fps=20
    tmp=tempfile.mkdtemp(); n=int(T*fps)+1
    tag_start={'turkey':3.6,'snowman':3.3,'tree':4.1,'snow':2.6,'halloween':4.0,'pie':4.1,'newyear':2.6,'sparkle':2.6}.get(theme,2.6)
    for i in range(n):
        t=i/fps; im=base.copy(); g=signature(im,name,t); glint(g,t,2.45)
        theme_overlay(theme,im,g,t,st)
        tagline(im,tag,t,tag_start,right={'snowman':800,'tree':770,'turkey':790}.get(theme))
        im.resize((W,H),Image.LANCZOS).save(f'{tmp}/f{i:03d}.png')
    # hold last frame 1s more
    sc=f'scale={a.width}:-1:flags=lanczos,' if a.width!=W else ''
    subprocess.run(['ffmpeg','-loglevel','error','-y','-framerate',str(fps),'-i',f'{tmp}/f%03d.png','-vf',f'{sc}palettegen=max_colors=256',f'{tmp}/p.png'],check=True)
    subprocess.run(['ffmpeg','-loglevel','error','-y','-framerate',str(fps),'-i',f'{tmp}/f%03d.png','-i',f'{tmp}/p.png','-lavfi',f'{sc.rstrip(",") + "[x];[x]" if sc else ""}[1:v]paletteuse=dither=none:diff_mode=rectangle'.replace('[x];[x][1:v]','[x];[x][1:v]') if False else (f'{sc}null[x];[x][1:v]paletteuse=dither=none:diff_mode=rectangle'),'-loop','0','-final_delay','1000',a.out],check=True)
    Image.open(f'{tmp}/f{n-1:03d}.png').save(os.path.splitext(a.out)[0]+'_final.png')
    shutil.copy(f'{tmp}/f{int(min(n-1,4.0*fps)):03d}.png',os.path.splitext(a.out)[0]+'_mid.png')
    shutil.rmtree(tmp); print('wrote',a.out,os.path.getsize(a.out),'bytes')
if __name__=='__main__': main()
