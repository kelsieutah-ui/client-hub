# Signature banner engine

Builds Kelsie's animated email signature banner, published at
https://clients.kelsiejimenez.com/sig/banner.gif (her Gmail signature loads this URL).

    python3 banner.py THEME --name script|print [--tagline "text"] --out ../banner.gif

Themes: plain, halloween, pie, newyear, sparkle. Needs Pillow and ffmpeg.
The GIF loops: plays about 5s, holds the finished signature 10s, repeats.
