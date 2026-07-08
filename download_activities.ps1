$ErrorActionPreference = "Stop"
$OutputEncoding = [System.Text.Encoding]::UTF8

Add-Type -AssemblyName System.Drawing

$scriptPath = $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $scriptPath
$outDir = Join-Path $root (Join-Path "images" "activities")
if (-not (Test-Path $outDir)) { New-Item -ItemType Directory -Path $outDir -Force | Out-Null }

# 8 activities: id, slug, p1/p2, accent, main title (ASCII), sub title (ASCII), icon key
$acts = @(
  @{ id=1; slug="fitness_therapy";   p1="#FF8AB8"; p2="#FF4E88"; accent="#FFE6F0"; main="Sports Therapy";   sub="Fitness & Wellness"; icon="dumbbell" },
  @{ id=2; slug="walk_for_good";     p1="#7CD0FF"; p2="#3B7EFF"; accent="#D9F1FF"; main="Walk For Good";     sub="Together Move";      icon="shoe" },
  @{ id=3; slug="sustainable_xia";   p1="#9D7BFF"; p2="#5A4BFF"; accent="#E2DAFF"; main="Sustainable City";  sub="Green Care";         icon="leaf" },
  @{ id=4; slug="stray_animal";      p1="#FFB27A"; p2="#FF7A45"; accent="#FFE7D4"; main="Stray Rescue";      sub="Animal Care";        icon="paw" },
  @{ id=5; slug="art_jimei";         p1="#FF7AB0"; p2="#C34DFF"; accent="#F5DDFF"; main="Jimei Art Show";    sub="Beauty Contest";     icon="palette" },
  @{ id=6; slug="hongding_museum";   p1="#FFC56B"; p2="#FF7E3A"; accent="#FFEED1"; main="Hongding Museum";   sub="Art Visit";          icon="frame" },
  @{ id=7; slug="recycle_craft";     p1="#7BE0B6"; p2="#36B58A"; accent="#DDF7EA"; main="Recycled Craft";    sub="Plastic Reborn";     icon="bottle" },
  @{ id=8; slug="herb_bracelet";     p1="#D4A77A"; p2="#A66E3A"; accent="#F2E1CC"; main="Herb Beads";        sub="Heritage Handmade";  icon="beads" }
)

$w = 800
$h = 450

function New-Background([int]$W, [int]$H, [string]$c1, [string]$c2) {
  $bmp = New-Object System.Drawing.Bitmap $W, $H
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $rect = New-Object System.Drawing.Rectangle 0,0,$W,$H
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
    [System.Drawing.ColorTranslator]::FromHtml("#" + $c1.TrimStart('#')),
    [System.Drawing.ColorTranslator]::FromHtml("#" + $c2.TrimStart('#')), 45.0)
  $g.FillRectangle($brush, 0, 0, $W, $H)
  $brush.Dispose()
  return ,$bmp, $g
}

function Add-GlowOrb([System.Drawing.Graphics]$g, [int]$cx, [int]$cy, [int]$r, [string]$hex, [int]$alpha) {
  $c = [System.Drawing.ColorTranslator]::FromHtml("#" + $hex.TrimStart('#'))
  $color = [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
  $brush = New-Object System.Drawing.SolidBrush($color)
  $g.FillEllipse($brush, $cx-$r, $cy-$r, $r*2, $r*2)
  $brush.Dispose()
}

function Add-Line([System.Drawing.Graphics]$g, [int]$x1, [int]$y1, [int]$x2, [int]$y2, [string]$hex, [int]$alpha, [int]$thickness) {
  $c = [System.Drawing.ColorTranslator]::FromHtml("#" + $hex.TrimStart('#'))
  $color = [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
  $pen = New-Object System.Drawing.Pen($color, ([single]$thickness))
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  $g.DrawLine($pen, $x1, $y1, $x2, $y2)
  $pen.Dispose()
}

function Add-Text([System.Drawing.Graphics]$g, [string]$text, [int]$x, [int]$y, [int]$size, [string]$hex, [int]$alpha, [bool]$bold=$false) {
  $style = if ($bold) { [System.Drawing.FontStyle]::Bold } else { [System.Drawing.FontStyle]::Regular }
  $font = New-Object System.Drawing.Font "Arial", ([single]$size), $style, ([System.Drawing.GraphicsUnit]::Pixel)
  $c = [System.Drawing.ColorTranslator]::FromHtml("#" + $hex.TrimStart('#'))
  $color = [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
  $brush = New-Object System.Drawing.SolidBrush($color)
  $sf = New-Object System.Drawing.StringFormat
  $sf.Alignment = [System.Drawing.StringAlignment]::Center
  $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
  $rect = New-Object System.Drawing.RectangleF ([single]($x-360)), ([single]($y-32)), 720.0, 64.0
  $g.DrawString($text, $font, $brush, $rect, $sf)
  $brush.Dispose()
  $font.Dispose()
}

function Draw-Icon([System.Drawing.Graphics]$g, [int]$cx, [int]$cy, [string]$kind) {
  $white = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(235,255,255,255))
  $shadow = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(70,0,0,0))
  $pen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 90, 30, 60)), 5.0
  $pen.StartCap = [System.Drawing.Drawing2D.LineCap]::Round
  $pen.EndCap = [System.Drawing.Drawing2D.LineCap]::Round
  switch ($kind) {
    "dumbbell" {
      $g.FillEllipse($shadow, [int]($cx-90), [int]($cy+72), 200, 16)
      $g.FillRectangle($white, [int]($cx-70), [int]($cy-22), 140, 44)
      $g.DrawRectangle($pen, [int]($cx-70), [int]($cy-22), 140, 44)
      $g.FillRectangle($white, [int]($cx-100), [int]($cy-44), 30, 88)
      $g.FillRectangle($white, [int]($cx+70), [int]($cy-44), 30, 88)
      $g.DrawRectangle($pen, [int]($cx-100), [int]($cy-44), 30, 88)
      $g.DrawRectangle($pen, [int]($cx+70), [int]($cy-44), 30, 88)
    }
    "shoe" {
      $g.FillEllipse($shadow, [int]($cx-90), [int]($cy+62), 200, 14)
      $pts = New-Object System.Drawing.Point[] 5
      $pts[0] = New-Object System.Drawing.Point([int]($cx-90), [int]($cy+30))
      $pts[1] = New-Object System.Drawing.Point([int]($cx+90), [int]($cy+30))
      $pts[2] = New-Object System.Drawing.Point([int]($cx+80), [int]($cy-10))
      $pts[3] = New-Object System.Drawing.Point([int]($cx-60), [int]($cy-30))
      $pts[4] = New-Object System.Drawing.Point([int]($cx-90), [int]($cy-10))
      $g.FillPolygon($white, $pts)
      $g.DrawPolygon($pen, $pts)
    }
    "leaf" {
      $g.FillEllipse($shadow, [int]($cx-80), [int]($cy+72), 180, 14)
      $pts = New-Object System.Drawing.Point[] 4
      $pts[0] = New-Object System.Drawing.Point([int]($cx-70), [int]($cy+40))
      $pts[1] = New-Object System.Drawing.Point([int]($cx+70), [int]($cy-30))
      $pts[2] = New-Object System.Drawing.Point([int]($cx+90), [int]($cy+10))
      $pts[3] = New-Object System.Drawing.Point([int]($cx-50), [int]($cy+60))
      $g.FillPolygon($white, $pts)
      $g.DrawPolygon($pen, $pts)
      $lx1 = [int]($cx-50); $ly1 = [int]($cy+50); $lx2 = [int]($cx+60); $ly2 = [int]($cy-20)
      Add-Line $g $lx1 $ly1 $lx2 $ly2 "#5A4BFF" 200 4
    }
    "paw" {
      $g.FillEllipse($shadow, [int]($cx-80), [int]($cy+72), 180, 14)
      $g.FillEllipse($white, [int]($cx-30), [int]($cy-10), 80, 70)
      $g.DrawEllipse($pen, [int]($cx-30), [int]($cy-10), 80, 70)
      $g.FillEllipse($white, [int]($cx-70), [int]($cy-50), 28, 34)
      $g.FillEllipse($white, [int]($cx-30), [int]($cy-70), 28, 34)
      $g.FillEllipse($white, [int]($cx+10), [int]($cy-70), 28, 34)
      $g.FillEllipse($white, [int]($cx+50), [int]($cy-50), 28, 34)
      $g.DrawEllipse($pen, [int]($cx-70), [int]($cy-50), 28, 34)
      $g.DrawEllipse($pen, [int]($cx-30), [int]($cy-70), 28, 34)
      $g.DrawEllipse($pen, [int]($cx+10), [int]($cy-70), 28, 34)
      $g.DrawEllipse($pen, [int]($cx+50), [int]($cy-50), 28, 34)
    }
    "palette" {
      $g.FillEllipse($shadow, [int]($cx-90), [int]($cy+72), 200, 16)
      $g.FillEllipse($white, [int]($cx-80), [int]($cy-50), 180, 150)
      $g.DrawEllipse($pen, [int]($cx-80), [int]($cy-50), 180, 150)
      foreach ($i in 0..4) {
        $ang = ($i * 72) * [math]::PI / 180
        $rx = [int]($cx + [math]::Cos($ang) * 50)
        $ry = [int]($cy - 10 + [math]::Sin($ang) * 40)
        $g.FillEllipse($white, [int]($rx-12), [int]($ry-12), 24, 24)
        $g.DrawEllipse($pen, [int]($rx-12), [int]($ry-12), 24, 24)
      }
    }
    "frame" {
      $g.FillEllipse($shadow, [int]($cx-90), [int]($cy+72), 200, 16)
      $g.FillRectangle($white, [int]($cx-90), [int]($cy-70), 180, 140)
      $g.DrawRectangle($pen, [int]($cx-90), [int]($cy-70), 180, 140)
      $g.FillRectangle($white, [int]($cx-70), [int]($cy-50), 140, 100)
      $fx1 = [int]($cx-50); $fy1 = [int]($cy-10); $fx2 = [int]($cx-20); $fy2 = [int]($cy+20)
      Add-Line $g $fx1 $fy1 $fx2 $fy2 "#FF7E3A" 220 4
      $fx3 = [int]($cx-20); $fy3 = [int]($cy+20); $fx4 = [int]($cx+10); $fy4 = [int]($cy-30)
      Add-Line $g $fx3 $fy3 $fx4 $fy4 "#FF7E3A" 220 4
    }
    "bottle" {
      $g.FillEllipse($shadow, [int]($cx-70), [int]($cy+72), 160, 14)
      $g.FillRectangle($white, [int]($cx-30), [int]($cy-80), 60, 30)
      $g.DrawRectangle($pen, [int]($cx-30), [int]($cy-80), 60, 30)
      $g.FillRectangle($white, [int]($cx-50), [int]($cy-50), 100, 120)
      $g.DrawRectangle($pen, [int]($cx-50), [int]($cy-50), 100, 120)
      $bx1 = [int]($cx-30); $by1 = [int]($cy-20); $bx2 = [int]($cx+30); $by2 = [int]($cy-20)
      Add-Line $g $bx1 $by1 $bx2 $by2 "#36B58A" 220 3
      $bx3 = [int]($cx-30); $by3 = [int]($cy); $bx4 = [int]($cx+30); $by4 = [int]($cy)
      Add-Line $g $bx3 $by3 $bx4 $by4 "#36B58A" 220 3
    }
    "beads" {
      $g.FillEllipse($shadow, [int]($cx-80), [int]($cy+72), 180, 14)
      $g.DrawArc($pen, [int]($cx-80), [int]($cy-70), 160, 140, 0, 180)
      $positions = @( @([int]($cx-50),[int]($cy-50)), @([int]($cx-20),[int]($cy-60)), @([int]($cx+10),[int]($cy-50)), @([int]($cx+40),[int]($cy-30)), @([int]($cx+50),[int]($cy+10)), @([int]($cx+30),[int]($cy+40)), @([int]($cx-10),[int]($cy+50)), @([int]($cx-50),[int]($cy+30)) )
      foreach ($p in $positions) {
        $g.FillEllipse($white, [int]($p[0]-14), [int]($p[1]-14), 28, 28)
        $g.DrawEllipse($pen, [int]($p[0]-14), [int]($p[1]-14), 28, 28)
      }
    }
  }
  $white.Dispose()
  $shadow.Dispose()
  $pen.Dispose()
}

foreach ($a in $acts) {
  $bmp, $g = New-Background $w $h $a.p1 $a.p2
  Add-GlowOrb $g ($w - 120) 80 160 $a.accent 80
  Add-GlowOrb $g 80 ($h - 80) 140 $a.accent 70
  Add-GlowOrb $g ($w/2) ($h/2 + 40) 110 "#FFFFFF" 26
  Draw-Icon $g ($w/2) ($h/2 - 20) $a.icon
  Add-Text $g $a.main  ($w/2) ($h - 90) 56 "#FFFFFF" 255 $true
  Add-Text $g $a.sub   ($w/2) ($h - 40) 22 "#FFFFFF" 230 $false
  $path = Join-Path $outDir ("activity_" + $a.id + "_" + $a.slug + ".png")
  $bmp.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $bmp.Dispose()
  Write-Host ("saved: " + $path)
}

Write-Host "done"
