$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.Drawing

# 8 activities (Base64 encoded Chinese strings to avoid PowerShell encoding issues)
$acts = @(
    @{ id=1; mainB64="5L2T6IKy55CG55aX5YGl6Lqr5rS75Yqo"; subB64="5o+Q5Y2H5ZGY5bel6Lqr5L2T57Sg6LSo"; p1="#FF8AB8"; p2="#FF4E88"; accent="#FFE6F0"; icon="dumbbell" },
    @{ id=2; mainB64="5YWo5ZGYIuS4gOi1t+i1sCLlhaznm4o="; subB64="5YWx5ZCM5Y+C5LiO55qE5YWs55uK6KGM6LWw"; p1="#7CD0FF"; p2="#3B7EFF"; accent="#D9F1FF"; icon="shoe" },
    @{ id=3; mainB64="IuWPr+aMgee7reS4gOWOpiLlhaznm4o="; subB64="5b+X5oS/5Y+C5Yqg546v5L+d5YWs55uK"; p1="#9D7BFF"; p2="#5A4BFF"; accent="#E2DAFF"; icon="leaf" },
    @{ id=4; mainB64="5rWB5rWq5Yqo54mp5pWR5Yqp"; subB64="5Y+C5LiO5rWB5rWq5Yqo54mp5pWR5Yqp"; p1="#FFB27A"; p2="#FF7A45"; accent="#FFE7D4"; icon="paw" },
    @{ id=5; mainB64="Iumbhue+jui2hee+jiLoibrmnK/or4Tmr5Q="; subB64="5oyW5o6Y6ZuG576O6Im65pyv5Yy6"; p1="#FF7AB0"; p2="#C34DFF"; accent="#F5DDFF"; icon="palette" },
    @{ id=6; mainB64="57qi6aG26Im65pyv6aaG5Y+C6K6/"; subB64="5LiO6Im65pyv5a626L+R6Led56a75o6l6Kem"; p1="#FFC56B"; p2="#FF7E3A"; accent="#FFEED1"; icon="frame" },
    @{ id=7; mainB64="5Y+v5Zue5pS25aGR5paZ6aWw5ZOB5Yi25L2c"; subB64="55So5Y+v5Zue5pS25aGR5paZ5Yi25L2c"; p1="#7BE0B6"; p2="#36B58A"; accent="#DDF7EA"; icon="bottle" },
    @{ id=8; mainB64="5Lit6I2v5omL5Liy5Yi25L2c"; subB64="5omL5bel5Yi25L2c6Z2e6YGX5omL5L2c"; p1="#D4A77A"; p2="#A66E3A"; accent="#F2E1CC"; icon="beads" }
)

$slugs = @(
    "activity_1_fitness_therapy",
    "activity_2_walk_for_good",
    "activity_3_sustainable_xia",
    "activity_4_stray_animal",
    "activity_5_art_jimei",
    "activity_6_hongding_museum",
    "activity_7_recycle_craft",
    "activity_8_herb_bracelet"
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
    $font = New-Object System.Drawing.Font "Microsoft YaHei", ([single]$size), $style, ([System.Drawing.GraphicsUnit]::Pixel)
    $c = [System.Drawing.ColorTranslator]::FromHtml("#" + $hex.TrimStart('#'))
    $color = [System.Drawing.Color]::FromArgb($alpha, $c.R, $c.G, $c.B)
    $brush = New-Object System.Drawing.SolidBrush($color)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $rect = New-Object System.Drawing.RectangleF ([single]($x-360)), ([single]($y-$size)), 720.0, ([single]($size*2))
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

for ($i = 0; $i -lt $acts.Count; $i++) {
    $a = $acts[$i]
    $main = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($a.mainB64))
    $sub = [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($a.subB64))
    Write-Host "Generating $main"

    $bmp, $g = New-Background $w $h $a.p1 $a.p2
    Add-GlowOrb $g ($w - 120) 80 160 $a.accent 80
    Add-GlowOrb $g 80 ($h - 80) 140 $a.accent 70
    Add-GlowOrb $g ($w/2) ($h/2 + 40) 110 "#FFFFFF" 26
    Draw-Icon $g ($w/2) ($h/2 - 30) $a.icon
    Add-Text $g $main  ($w/2) ($h - 100) 48 "#FFFFFF" 255 $true
    Add-Text $g $sub   ($w/2) ($h - 50) 24 "#FFFFFF" 230 $false

    $outFile = Join-Path $PWD "images\activities\$($slugs[$i]).png"
    $bmp.Save($outFile, [System.Drawing.Imaging.ImageFormat]::Png)
    $g.Dispose()
    $bmp.Dispose()
    Write-Host "Saved $outFile"
}

Write-Host "All done"
