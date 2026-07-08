$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type -AssemblyName System.Drawing

$root = "C:\Users\Admin\Desktop\shen_xin_ling\yuan_xing\hong_mo_fang_she_qun_ji_fen_xi_tong"
# fallback: detect real root from script location
$scriptPath = $MyInvocation.MyCommand.Path
if ($scriptPath) {
  $root = Split-Path -Parent $scriptPath
}
$outDir = Join-Path $root (Join-Path "images" "goods")
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

$goods = @(
  @{ id=1; file="canvas_bag.png";     title="Canvas Bag";   sub="Brand Tote";     p1="#FFD3E1"; p2="#FF6FA5"; accent="#FFFFFF" },
  @{ id=2; file="lipstick_gift.png";  title="Lipstick Set"; sub="Mini Gift Box";  p1="#FFC9DA"; p2="#FF7AA8"; accent="#FFE7EE" },
  @{ id=3; file="facial_towel.png";   title="Facial Towel"; sub="Clean Care";     p1="#FFE0E9"; p2="#F58FB3"; accent="#FFFFFF" },
  @{ id=4; file="mug_limited.png";    title="Limited Mug";  sub="Art Co-Brand";   p1="#FFD9C2"; p2="#FF8A6B"; accent="#FFFFFF" },
  @{ id=5; file="serum_trial.png";    title="Serum Trial";  sub="Premium Skincare"; p1="#FFE5D2"; p2="#FFAE83"; accent="#FFFFFF" }
)

$size = 512

function New-GradientBitmap([int]$w, [int]$h, [string]$c1, [string]$c2) {
  $bmp = New-Object System.Drawing.Bitmap $w, $h
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $rect = New-Object System.Drawing.Rectangle 0,0,$w,$h
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
    [System.Drawing.ColorTranslator]::FromHtml("#" + $c1.TrimStart('#')),
    [System.Drawing.ColorTranslator]::FromHtml("#" + $c2.TrimStart('#')), 45.0)
  $g.FillRectangle($brush, 0, 0, $w, $h)
  $brush.Dispose()
  $g.Dispose()
  return $bmp
}

function Add-GlowCircle([System.Drawing.Bitmap]$bmp, [int]$cx, [int]$cy, [int]$r, [string]$hex, [int]$alpha) {
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $c = [System.Drawing.ColorTranslator]::FromHtml("#" + $hex.TrimStart('#'))
  $color = [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
  $brush = New-Object System.Drawing.SolidBrush($color)
  $g.FillEllipse($brush, $cx-$r, $cy-$r, $r*2, $r*2)
  $brush.Dispose()
  $g.Dispose()
}

function Add-Text([System.Drawing.Bitmap]$bmp, [string]$text, [int]$x, [int]$y, [int]$size, [string]$hex, [int]$alpha, [bool]$bold=$false) {
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
  $style = if ($bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
  $font = New-Object System.Drawing.Font "Arial", ([single]$size), $style, ([System.Drawing.GraphicsUnit]::Pixel)
  $c = [System.Drawing.ColorTranslator]::FromHtml("#" + $hex.TrimStart('#'))
  $color = [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
  $brush = New-Object System.Drawing.SolidBrush($color)
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
  $rect = New-Object System.Drawing.RectangleF ([single]($x-220)), ([single]($y-30)), 440.0, 60.0
  $g.DrawString($text, $font, $brush, $rect, $sf)
  $brush.Dispose()
  $font.Dispose()
  $g.Dispose()
}

function Add-ProductShape([System.Drawing.Bitmap]$bmp, [int]$id) {
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(235,255,255,255))
  $shadow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70,200,80,120))
  $strokePen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 90, 30, 60)), 3.0
  switch ($id) {
    1 {
      $g.FillEllipse($shadow, 150, 400, 220, 24)
      $g.FillRectangle($white, 175, 220, 160, 180)
      $g.DrawRectangle($strokePen, 175, 220, 160, 180)
      $g.DrawArc($strokePen, 200, 170, 50, 90, 0, 180)
      $g.DrawArc($strokePen, 260, 170, 50, 90, 0, 180)
    }
    2 {
      $g.FillEllipse($shadow, 130, 400, 260, 24)
      $g.FillRectangle($white, 160, 250, 200, 130)
      $g.DrawRectangle($strokePen, 160, 250, 200, 130)
      $g.FillRectangle($white, 210, 160, 100, 110)
      $g.DrawRectangle($strokePen, 210, 160, 100, 110)
      $g.FillEllipse($white, 240, 140, 40, 40)
      $g.DrawEllipse($strokePen, 240, 140, 40, 40)
    }
    3 {
      $g.FillEllipse($shadow, 130, 400, 260, 24)
      $g.FillRectangle($white, 150, 230, 100, 150)
      $g.DrawRectangle($strokePen, 150, 230, 100, 150)
      $g.FillRectangle($white, 270, 230, 100, 150)
      $g.DrawRectangle($strokePen, 270, 230, 100, 150)
    }
    4 {
      $g.FillEllipse($shadow, 140, 420, 240, 24)
      $g.FillRectangle($white, 180, 200, 150, 200)
      $g.DrawRectangle($strokePen, 180, 200, 150, 200)
      $g.DrawArc($strokePen, 330, 240, 50, 100, -90, 180)
    }
    5 {
      $g.FillEllipse($shadow, 150, 420, 220, 24)
      $g.FillRectangle($white, 200, 160, 120, 30)
      $g.DrawRectangle($strokePen, 200, 160, 120, 30)
      $g.FillRectangle($white, 220, 190, 80, 210)
      $g.DrawRectangle($strokePen, 220, 190, 80, 210)
    }
  }
  $white.Dispose()
  $shadow.Dispose()
  $strokePen.Dispose()
  $g.Dispose()
}

foreach ($g in $goods) {
  $bmp = New-GradientBitmap $size $size $g.p1 $g.p2
  Add-GlowCircle $bmp ($size - 80) 60 90 $g.accent 60
  Add-GlowCircle $bmp 60 ($size - 60) 70 $g.accent 50
  Add-ProductShape $bmp $g.id
  Add-Text $bmp $g.title 256 90 40 "#FFFFFF" 255 $true
  Add-Text $bmp $g.sub   256 140 18 "#FFFFFF" 220 $false
  $path = Join-Path $outDir $g.file
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Host ("saved: " + $path)
}

Write-Host "done"
