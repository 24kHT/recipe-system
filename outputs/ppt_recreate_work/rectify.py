import cv2, numpy as np, pathlib
root=pathlib.Path(r'D:\create')
out=root/'outputs'/'ppt_recreate_work'/'rectified'
out.mkdir(parents=True, exist_ok=True)
for idx,p in enumerate(sorted(root.glob('*.jpg')),1):
    data=np.fromfile(str(p), dtype=np.uint8)
    img=cv2.imdecode(data, cv2.IMREAD_COLOR)
    if img is None:
        print('skip', p); continue
    h,w=img.shape[:2]
    gray=cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    blur=cv2.GaussianBlur(gray,(5,5),0)
    _,th=cv2.threshold(blur,105,255,cv2.THRESH_BINARY)
    kernel=cv2.getStructuringElement(cv2.MORPH_RECT,(31,31))
    th=cv2.morphologyEx(th, cv2.MORPH_CLOSE, kernel)
    contours,_=cv2.findContours(th, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
    best=None; best_score=-1e18
    for c in contours:
        area=cv2.contourArea(c)
        if area < 0.12*w*h: continue
        x,y,ww,hh=cv2.boundingRect(c)
        ratio=ww/max(hh,1)
        center_pen=abs((x+ww/2)-w/2)*8 + abs((y+hh/2)-h*0.43)*4
        score=area - abs(ratio-1.75)*60000 - center_pen
        if score>best_score:
            best_score=score; best=(c,(x,y,ww,hh))
    if best is None:
        pts=np.array([[int(w*0.06),int(h*0.16)],[int(w*0.95),int(h*0.16)],[int(w*0.95),int(h*0.72)],[int(w*0.06),int(h*0.72)]],dtype=np.float32)
    else:
        c,bb=best
        peri=cv2.arcLength(c,True)
        approx=cv2.approxPolyDP(c,0.025*peri,True)
        if len(approx)==4:
            pts=approx.reshape(4,2).astype(np.float32)
        else:
            x,y,ww,hh=bb
            pts=np.array([[x,y],[x+ww,y],[x+ww,y+hh],[x,y+hh]],dtype=np.float32)
    s=pts.sum(axis=1); diff=np.diff(pts,axis=1).reshape(-1)
    ordered=np.array([pts[np.argmin(s)],pts[np.argmin(diff)],pts[np.argmax(s)],pts[np.argmax(diff)]],dtype=np.float32)
    dst=np.array([[0,0],[1280,0],[1280,720],[0,720]],dtype=np.float32)
    M=cv2.getPerspectiveTransform(ordered,dst)
    crop=cv2.warpPerspective(img,M,(1280,720))
    crop=cv2.convertScaleAbs(crop, alpha=1.18, beta=8)
    ok,buf=cv2.imencode('.jpg', crop, [int(cv2.IMWRITE_JPEG_QUALITY), 95])
    (out/f'slide-{idx:02d}.jpg').write_bytes(buf.tobytes())
print(out)
