# -*- coding: utf-8 -*-
"""把 prd_assets_v3/*.png 处理成 doc 可嵌入的 jpg → prd_assets_v3/_doc/
   PC/后台(pc-*/adm-*)：整页降采样到宽≤1100
   H5(mob-*)：超长竖图裁上半(ratio 2.15)再降采样到宽≤780
   输出 jpg quality 82，白底。
"""
import os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC = os.path.join(ROOT, "output", "prd_assets_v3")
DST = os.path.join(SRC, "_doc")
os.makedirs(DST, exist_ok=True)

MOB_RATIO = 2.15   # H5 裁剪高宽比上限
MOB_W = 780
PC_W = 1100

def process(name):
    p = os.path.join(SRC, name)
    im = Image.open(p).convert("RGB")
    w, h = im.size
    is_mob = name.startswith("mob-")
    if is_mob:
        max_h = int(w * MOB_RATIO)
        if h > max_h:
            im = im.crop((0, 0, w, max_h))
        tw = MOB_W
    else:
        tw = PC_W
    if im.size[0] > tw:
        r = tw / im.size[0]
        im = im.resize((tw, int(im.size[1] * r)), Image.LANCZOS)
    out = os.path.join(DST, os.path.splitext(name)[0] + ".jpg")
    im.save(out, "JPEG", quality=82)
    return out, im.size

if __name__ == "__main__":
    cnt = 0
    for n in sorted(os.listdir(SRC)):
        if n.lower().endswith(".png"):
            out, sz = process(n)
            print("OK", os.path.basename(out), sz)
            cnt += 1
    print(f"== {cnt} images prepped ==")
