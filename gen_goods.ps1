# 商品图：仿产品摄影风格，纯离线生成
$ErrorActionPreference = "Continue"
Add-Type -AssemblyName System.Drawing
$dst = "c:\Users\Admin\Desktop\身心灵\原型\红魔方社群积分系统\images\goods"

# ---- 工具函数（避免构造参数 cast 报错） ----
function BR($x,$y,$w,$h){
  $r = New-Object System.Drawing.Rectangle
  $r.X = [int]$x; $r.Y = [int]$y; $r.Width = [int]$w; $r.Height = [int]$h
  return $r
}
function BRF($x,$y,$w,$h){
  $r = New-Object System.Drawing.RectangleF
  $r.X = [float]$x; $r.Y = [float]$y; $r.Width = [float]$w; $r.Height = [float]$h
  return $r
}
function BP($c1,$c2,$x,$y,$w,$h,$mode){
  $r = BR $x $y $w $h
  return [Activator]::CreateInstance([System.Drawing.Drawing2D.LinearGradientBrush], @($r, $c1, $c2, $mode))
}
function Pen($color, $w){
  $p = [Activator]::CreateInstance([System.Drawing.Pen], $color)
  $p.Width = [float]$w
  return $p
}
function Brush($color){
  return [Activator]::CreateInstance([System.Drawing.SolidBrush], $color)
}
function C($a,$r,$g,$b){
  return [System.Drawing.Color]::FromArgb([int]$a,[int]$r,[int]$g,[int]$b)
}

function New-Canvas($size){
  $bmp = New-Object System.Drawing.Bitmap $size,$size
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  return @{ Bmp=$bmp; G=$g }
}

function Save-Png($c, $path){
  $fs = New-Object System.IO.FileStream $path, ([System.IO.FileMode]::Create)
  $c.Bmp.Save($fs, [System.Drawing.Imaging.ImageFormat]::Png)
  $fs.Close()
  $fs.Dispose()
  $c.G.Dispose()
  $c.Bmp.Dispose()
  Write-Host ("  saved " + (Get-Item $path).Length + " bytes")
}

function Draw-Background($c, $size, $top, $bot){
  $g = $c.G
  $brush = BP $top $bot 0 0 $size $size ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
  $g.FillRectangle($brush, 0, 0, $size, $size)
  $brush.Dispose()
  # 地面阴影
  $shadowRect = BRF 0 ($size*0.74) $size ($size*0.18)
  $shadowBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($shadowRect, (C 60 40 40 40), (C 0 255 255 255), [System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
  $g.FillRectangle($shadowBrush, [single]0, [single]($size*0.74), [single]$size, [single]($size*0.18))
}

function Draw-SoftShadow($c, $cx, $cy, $w){
  $g = $c.G
  for($i=0; $i -lt 8; $i++){
    $alpha = 30 - $i*3
    $offset = $i*1.5
    $sh = Brush (C $alpha 0 0 0)
    $g.FillEllipse($sh, [float]($cx - $w/2 + $offset), [float]($cy - 6), [float]$w, [float]12)
    $sh.Dispose()
  }
}

# ---------- 1. 帆布包 ----------
function Make-CanvasBag($path){
  $size=800
  $c = New-Canvas $size
  $g = $c.G
  Draw-Background $c $size (C 255 245 239 228) (C 255 225 213 196)
  Draw-SoftShadow $c 400 600 360

  # 包身
  $bagRect = BRF 250 320 300 280
  $bagPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $bagPath.AddRectangle($bagRect)

  $bagBrush = BP (C 255 250 245 235) (C 255 225 210 188) 250 320 300 280 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
  $g.FillPath($bagBrush, $bagPath)
  $g.DrawPath((Pen (C 255 170 140 110) 2), $bagPath)

  # 把手
  $handle1 = New-Object System.Drawing.Drawing2D.GraphicsPath
  $handle1.AddBezier(310, 330, 305, 240, 345, 220, 365, 320)
  $handle2 = New-Object System.Drawing.Drawing2D.GraphicsPath
  $handle2.AddBezier(435, 320, 440, 220, 480, 220, 495, 320)
  $penHandle = Pen (C 255 140 90 60) 8
  $penHandle.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $penHandle.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawPath($penHandle, $handle1)
  $g.DrawPath($penHandle, $handle2)

  # 品牌色印花
  $strip = Brush (C 255 255 0 134)
  $g.FillRectangle($strip, 280, 460, 240, 14)
  $g.FillRectangle($strip, 280, 484, 180, 14)

  # 高光
  $hl = BP (C 80 255 255 255) (C 0 255 255 255) 270 330 50 260 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
  $g.FillRectangle($hl, 270, 330, 50, 260)
  Save-Png $c $path
}

# ---------- 2. 口红礼盒 ----------
function Make-LipstickGift($path){
  $size=800
  $c = New-Canvas $size
  $g = $c.G
  Draw-Background $c $size (C 255 250 238 242) (C 255 235 222 230)
  Draw-SoftShadow $c 400 600 360

  # 礼盒
  $g.FillRectangle((BP (C 255 32 28 32) (C 255 60 50 55) 220 360 360 250 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 220, 360, 360, 250)
  $g.DrawRectangle((Pen (C 255 180 150 80) 2), 220, 360, 360, 250)

  # 金色 LOGO
  $g.FillRectangle((BP (C 255 212 175 55) (C 255 180 140 40) 240 380 320 40 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 240, 380, 320, 40)

  # 三支口红
  $lips = @( @{x=300;c=(C 255 200 30 60)}, @{x=380;c=(C 255 220 40 80)}, @{x=460;c=(C 255 180 25 55)} )
  foreach($lp in $lips){
    $cx = $lp.x; $col = $lp.c
    $g.FillRectangle((BP (C 255 212 175 55) (C 255 160 125 30) ($cx-22) 460 44 30 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), ($cx-22), 460, 44, 30)
    $g.FillRectangle((BP (C 255 220 40 80) (C 255 140 20 55) ($cx-15) 340 30 120 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), ($cx-15), 340, 30, 120)
    $top = Brush $col
    $g.FillEllipse($top, ($cx-12), 320, 24, 24)
  }

  # 盒面高光
  $hl = BP (C 60 255 255 255) (C 0 255 255 255) 230 365 25 240 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
  $g.FillRectangle($hl, 230, 365, 25, 240)
  Save-Png $c $path
}

# ---------- 3. 洁面巾两盒装 ----------
function Make-FacialTowel($path){
  $size=800
  $c = New-Canvas $size
  $g = $c.G
  Draw-Background $c $size (C 255 242 247 243) (C 255 225 235 228)
  Draw-SoftShadow $c 400 620 420

  # 两盒
  $g.FillRectangle((BP (C 255 255 253 250) (C 255 225 228 222) 180 410 240 220 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 180, 410, 240, 220)
  $g.FillRectangle((BP (C 255 255 253 250) (C 255 220 225 218) 380 360 240 270 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 380, 360, 240, 270)
  $g.DrawRectangle((Pen (C 255 180 195 180) 2), 180, 410, 240, 220)
  $g.DrawRectangle((Pen (C 255 180 195 180) 2), 380, 360, 240, 270)

  # 标签条
  $col1 = C 255 255 180 200
  $col2 = C 255 255 150 180
  $lblBrush = BP $col1 $col2 180 460 240 36 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)
  $g.FillRectangle($lblBrush, 180, 460, 240, 36)
  $g.FillRectangle($lblBrush, 380, 410, 240, 36)

  # 中文 Base64
  $Z64 = "5rWL6K+V5biC"  # 洁面巾
  $txt = [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($Z64))
  $f = New-Object System.Drawing.Font ("Microsoft YaHei", 16, [System.Drawing.FontStyle]::Bold)
  $tb = Brush (C 255 255 255 255)
  $g.DrawString($txt, $f, $tb, 290, 466)
  $g.DrawString($txt, $f, $tb, 490, 416)

  # 高光
  $hl = BP (C 60 255 255 255) (C 0 255 255 255) 195 415 18 210 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
  $g.FillRectangle($hl, 195, 415, 18, 210)
  $hl2 = BP (C 60 255 255 255) (C 0 255 255 255) 395 365 18 260 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
  $g.FillRectangle($hl2, 395, 365, 18, 260)
  Save-Png $c $path
}

# ---------- 4. 马克杯 ----------
function Make-Mug($path){
  $size=800
  $c = New-Canvas $size
  $g = $c.G
  Draw-Background $c $size (C 255 250 245 250) (C 255 235 225 235)
  Draw-SoftShadow $c 400 620 280

  # 杯体
  $cupBrush = BP (C 255 255 253 250) (C 255 200 190 200) 300 320 200 300 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
  $g.FillRectangle($cupBrush, 300, 320, 200, 300)
  $g.DrawRectangle((Pen (C 255 200 190 200) 2), 300, 320, 200, 300)

  # 杯口椭圆
  $g.FillEllipse((BP (C 255 90 75 90) (C 255 40 30 40) 300 305 200 36 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 300, 305, 200, 36)
  # 杯底椭圆
  $g.FillEllipse((BP (C 255 160 150 160) (C 255 110 100 110) 300 605 200 28 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 300, 605, 200, 28)

  # 把手
  $handlePath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $handlePath.AddBezier(500, 380, 580, 380, 580, 540, 500, 540)
  $handlePath.AddBezier(500, 540, 540, 540, 540, 380, 500, 380)
  $g.FillPath($cupBrush, $handlePath)
  $g.DrawPath((Pen (C 255 200 190 200) 2), $handlePath)

  # 杯身高光
  $hl = BP (C 110 255 255 255) (C 0 255 255 255) 320 340 25 270 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
  $g.FillRectangle($hl, 320, 340, 25, 270)

  # 玫红花纹带
  $colStrip = C 255 255 0 134
  $strip = Brush $colStrip
  $g.FillRectangle($strip, 300, 470, 200, 12)
  $g.FillRectangle($strip, 300, 492, 200, 6)
  # 花瓣
  for($i=0;$i -lt 5;$i++){
    $px = 340 + $i*32
    $petal = Brush (C 180 255 150 200)
    $g.FillEllipse($petal, $px, 440, 14, 14)
  }
  Save-Png $c $path
}

# ---------- 5. 精华小样 ----------
function Make-Serum($path){
  $size=800
  $c = New-Canvas $size
  $g = $c.G
  Draw-Background $c $size (C 255 247 242 236) (C 255 225 215 205)
  Draw-SoftShadow $c 400 640 380

  # 礼盒
  $g.FillRectangle((BP (C 255 255 250 240) (C 255 225 210 190) 200 400 400 230 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 200, 400, 400, 230)
  $g.DrawRectangle((Pen (C 255 180 150 120) 2), 200, 400, 400, 230)
  # 礼盒顶
  $g.FillRectangle((BP (C 255 235 215 195) (C 255 210 190 170) 190 380 420 30 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), 190, 380, 420, 30)

  # 三支小瓶
  $b1c = C 255 255 200 210
  $b1s = C 255 200 150 170
  $b2c = C 255 255 180 200
  $b2s = C 255 200 150 170
  $b3c = C 255 255 210 220
  $b3s = C 255 200 150 170
  $bottles = @( @{x=300;c=$b1c}, @{x=400;c=$b2c}, @{x=500;c=$b3c} )
  $colN1 = C 255 210 195 190
  $colN2 = C 255 160 145 140
  $colCap1 = C 255 60 50 55
  $colCap2 = C 255 30 25 30
  $colGhl = C 140 255 255 255
  $ghl = Brush $colGhl
  foreach($bt in $bottles){
    $cx = $bt.x; $col = $bt.c
    $colS = C 255 200 150 170
    $g.FillRectangle((BP $col $colS ($cx-25) 280 50 140 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)), ($cx-25), 280, 50, 140)
    $g.FillRectangle((BP $colN1 $colN2 ($cx-12) 240 24 45 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), ($cx-12), 240, 24, 45)
    $g.FillRectangle((BP $colCap1 $colCap2 ($cx-15) 220 30 24 ([System.Drawing.Drawing2D.LinearGradientMode]::Vertical)), ($cx-15), 220, 30, 24)
    $g.FillRectangle($ghl, ($cx-22), 285, 6, 130)
  }

  # 礼盒高光
  $hl = BP (C 60 255 255 255) (C 0 255 255 255) 215 405 22 220 ([System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
  $g.FillRectangle($hl, 215, 405, 22, 220)
  Save-Png $c $path
}

Write-Host "生成商品图..."
Make-CanvasBag (Join-Path $dst "canvas_bag.png")
Make-LipstickGift (Join-Path $dst "lipstick_gift.png")
Make-FacialTowel (Join-Path $dst "facial_towel.png")
Make-Mug (Join-Path $dst "mug_limited.png")
Make-Serum (Join-Path $dst "serum_trial.png")
Write-Host "ALL DONE"
