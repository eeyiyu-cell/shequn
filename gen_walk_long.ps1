# 生成「全民一起走」公益活动长图
$OutputEncoding = [System.Text.Encoding]::UTF8
Add-Type -AssemblyName System.Drawing

function Z($s){ return [System.Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($s.Trim())) }

function BR($x,$y,$w,$h){
  $r = New-Object System.Drawing.Rectangle
  $r.X = [int]$x
  $r.Y = [int]$y
  $r.Width = [int]$w
  $r.Height = [int]$h
  return $r
}
function BRF($x,$y,$w,$h){
  $r = New-Object System.Drawing.RectangleF
  $r.X = [float]$x
  $r.Y = [float]$y
  $r.Width = [float]$w
  $r.Height = [float]$h
  return $r
}
function BP($x,$y){
  $p = New-Object System.Drawing.PointF
  $p.X = [float]$x
  $p.Y = [float]$y
  return $p
}

$W = 800
$H = 2200
$bmp = New-Object System.Drawing.Bitmap $W,$H
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode = "AntiAlias"
$g.TextRenderingHint = "AntiAliasGridFit"

$C_BG1    = [System.Drawing.Color]::FromArgb(255,18,21,38)
$C_BG2    = [System.Drawing.Color]::FromArgb(255,36,12,48)
$C_PINK   = [System.Drawing.Color]::FromArgb(255,255,0,134)
$C_PINK2  = [System.Drawing.Color]::FromArgb(255,255,126,182)
$C_GOLD   = [System.Drawing.Color]::FromArgb(255,255,197,61)
$C_WHITE  = [System.Drawing.Color]::FromArgb(255,255,255,255)
$C_TEXT   = [System.Drawing.Color]::FromArgb(255,235,232,240)
$C_SUB    = [System.Drawing.Color]::FromArgb(255,170,165,180)
$C_CARD   = [System.Drawing.Color]::FromArgb(255,30,28,46)
$C_LINE   = [System.Drawing.Color]::FromArgb(255,52,46,68)

# 背景渐变
$bgRect = BR 0 0 $W $H
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $bgRect,$C_BG1,$C_BG2,135.0
$g.FillRectangle($bgBrush, $bgRect)

# 顶部光晕
$glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$glowPath.AddEllipse(-200, -200, 900, 700)
$pbrush = New-Object System.Drawing.Drawing2D.PathGradientBrush $glowPath
$pbrush.CenterColor = [System.Drawing.Color]::FromArgb(120,255,80,160)
$pbrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0,255,0,134))
$g.FillPath($pbrush, $glowPath)

# 字体
$fontTitle = New-Object System.Drawing.Font("Microsoft YaHei",40,[System.Drawing.FontStyle]::Bold)
$fontSub   = New-Object System.Drawing.Font("Microsoft YaHei",16)
$fontBrand = New-Object System.Drawing.Font("Microsoft YaHei",13)
$fontH2    = New-Object System.Drawing.Font("Microsoft YaHei",22,[System.Drawing.FontStyle]::Bold)
$fontH3    = New-Object System.Drawing.Font("Microsoft YaHei",16,[System.Drawing.FontStyle]::Bold)
$fontP     = New-Object System.Drawing.Font("Microsoft YaHei",14)
$fontPsm   = New-Object System.Drawing.Font("Microsoft YaHei",12)
$fontTime  = New-Object System.Drawing.Font("Consolas",16,[System.Drawing.FontStyle]::Bold)
$fontNum   = New-Object System.Drawing.Font("Microsoft YaHei",28,[System.Drawing.FontStyle]::Bold)

$sf = New-Object System.Drawing.StringFormat
$sf.Alignment = "Center"
$sf.LineAlignment = "Center"
$sfLeft = New-Object System.Drawing.StringFormat
$sfLeft.Alignment = "Near"

# ===== 标题 =====
$Title    = Z("5YWo5rCR5LiA6LW36LWwIOWFrOebiuihjOWKqA==")
$Subtitle = Z("5Lul6KGM6LWw5Lyg6YCS5rip5pqW77yM55So6ISa5q2l5a6I5oqk576O5aW9")
$Brand    = Z("6LeR57qi6ZuG5ZuiIMK3IOe6oumtlOaWueWFrOebig==")
$g.DrawString($Title, $fontTitle, (New-Object System.Drawing.SolidBrush $C_WHITE), (BRF 0 90 $W 80), $sf)
$g.DrawString($Subtitle, $fontSub, (New-Object System.Drawing.SolidBrush $C_PINK2), (BRF 0 175 $W 30), $sf)
$g.DrawString($Brand, $fontBrand, (New-Object System.Drawing.SolidBrush $C_SUB), (BRF 0 210 $W 24), $sf)

# ===== 数据条 =====
$stats = @(
  @{N=Z("MjA="); L=Z("5ZCN6aKdIOa7oeWRmOWNs+atog==")},
  @{N=Z("OC0xMg=="); L=Z("5pqW5Yas5YWs55uK5pyI")},
  @{N=Z("MTEg5YWs6YeM"); L=Z("546v5bKb6Lev57q/")},
  @{N=Z("NTAwMCDlhYM="); L=Z("5YWs55uK5Z+66YeR5rGg")}
)
$statY = 270
$statW = 170; $statGap = 20
$statStartX = [int](($W - ($statW*4 + $statGap*3)) / 2)
for($i=0;$i -lt 4;$i++){
  $x = $statStartX + $i*($statW+$statGap)
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $C_CARD), (BR $x $statY $statW 80))
  $g.DrawRectangle((New-Object System.Drawing.Pen $C_LINE,1), (BR $x $statY $statW 80))
  $g.DrawString($stats[$i].N, $fontNum, (New-Object System.Drawing.SolidBrush $C_PINK), (BRF $x ($statY+10) $statW 40), $sf)
  $g.DrawString($stats[$i].L, $fontPsm, (New-Object System.Drawing.SolidBrush $C_SUB), (BRF $x ($statY+48) $statW 24), $sf)
}

# ===== 活动目的 =====
$g.FillRectangle((New-Object System.Drawing.SolidBrush $C_PINK), (BR 40 408 4 28))
$g.DrawString((Z("5rS75Yqo55uu55qE")), $fontH2, (New-Object System.Drawing.SolidBrush $C_WHITE), (BP 56 400))
$desc1 = Z("5pys5qyhIuWFqOawkeS4gOi1t+i1sCLlhaznm4rmtLvliqjml6jlnKjpgJrov4fpm4bkvZPooYzotbDnmoTmlrnlvI/vvIzlh53ogZrlkZjlt6XniLHlv4Plipvph4/vvIzlgKHlr7zlgaXlurfnlJ/mtLvnkIblv7XvvIzkuLrnpL7ljLrlhaznm4rkuovkuJrotKHnjK7ot5HnuqLlipvph4/jgII=")
$g.DrawString($desc1, $fontP, (New-Object System.Drawing.SolidBrush $C_TEXT), (BRF 40 445 ($W-80) 120), $sfLeft)

# ===== 活动安排 =====
$g.FillRectangle((New-Object System.Drawing.SolidBrush $C_PINK), (BR 40 603 4 28))
$g.DrawString((Z("5rS75Yqo5a6J5o6S")), $fontH2, (New-Object System.Drawing.SolidBrush $C_WHITE), (BP 56 595))
$g.FillRectangle((New-Object System.Drawing.SolidBrush $C_PINK), (BR 79 650 2 330))

$timeline = @(
  @{T="08:00"; H=Z("562+5Yiw6ZuG5ZCI"); D=Z("5rS75Yqo5Y+C5LiO6ICFIDA4OjAwIOWJjeWIsOi+vumbhue+juW4guawkeW5v+Wcug==")},
  @{T="08:30"; H=Z("5byA5bmV5Luq5byP"); D=Z("6aKG5a+86Ie06L6eIOa0u+WKqOWuo+iusiDlm6LpmJ/liIbnu4Q=")},
  @{T="09:00"; H=Z("5YWs55uK6KGM6LWw"); D=Z("546v5bKb6Lev57q/IOWFqOWRmOWBpeatpSAxMSDlhazph4w=")},
  @{T="11:00"; H=Z("5Lit6L2s5LyR5oGv"); D=Z("6IO96YeP6KGl57uZIOWFrOebiuS6kuWKqCDmi43nhafmiZPljaE=")},
  @{T="12:00"; H=Z("5ZyG5ruh6L+U56iL"); D=Z("5ZCI5b2x55WZ5b+1IOmigeWlluaAu+e7kyDlronlhajov5TnqIs=")}
)
$tlY = 645
for($i=0;$i -lt $timeline.Count;$i++){
  $item = $timeline[$i]
  $y = $tlY + $i*70
  $dotX = 70; $dotY = [int]($y+5)
  $g.FillEllipse((New-Object System.Drawing.SolidBrush $C_BG1), (BR $dotX $dotY 20 20))
  $g.FillEllipse((New-Object System.Drawing.SolidBrush $C_PINK), (BR $dotX $dotY 20 20))
  $g.DrawString($item.T, $fontTime, (New-Object System.Drawing.SolidBrush $C_GOLD), (BP 110 $y))
  $g.DrawString($item.H, $fontH3, (New-Object System.Drawing.SolidBrush $C_WHITE), (BP 200 $y))
  $g.DrawString($item.D, $fontPsm, (New-Object System.Drawing.SolidBrush $C_SUB), (BP 200 ($y+24)))
}

# ===== 活动路线 =====
$g.FillRectangle((New-Object System.Drawing.SolidBrush $C_PINK), (BR 40 1018 4 28))
$g.DrawString((Z("5rS75Yqo6Lev57q/")), $fontH2, (New-Object System.Drawing.SolidBrush $C_WHITE), (BP 56 1010))
$mapY = 1060
$mapH = 240
$mapW = [int]($W-80)
$g.FillRectangle((New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255,42,38,60))), (BR 40 $mapY $mapW $mapH))
$g.DrawRectangle((New-Object System.Drawing.Pen $C_LINE,1), (BR 40 $mapY $mapW $mapH))

$points = @(
  @{X=110; Y=[int]($mapY+180); N="1"; L=Z("6LW354K5IMK3IOmbhue+juW4guawkeW5v+Wcug==")},
  @{X=290; Y=[int]($mapY+90);  N="2"; L=Z("6KGl57uZIMK3IOS4reWkruWFrOWbrempv+ermQ==")},
  @{X=470; Y=[int]($mapY+150); N="3"; L=Z("5omT5Y2hIMK3IOWNgemHjOmVv+WgpA==")},
  @{X=650; Y=[int]($mapY+60);  N="4"; L=Z("57uI54K5IMK3IOadj+a7qOaWh+WMluW5v+Wcug==")}
)
for($i=0;$i -lt $points.Count-1;$i++){
  $g.DrawLine((New-Object System.Drawing.Pen $C_PINK,3), $points[$i].X,$points[$i].Y, $points[$i+1].X,$points[$i+1].Y)
}
foreach($p in $points){
  $dx = [int]($p.X-16); $dy = [int]($p.Y-16)
  $g.FillEllipse((New-Object System.Drawing.SolidBrush $C_PINK), (BR $dx $dy 32 32))
  $g.DrawString($p.N, $fontH3, (New-Object System.Drawing.SolidBrush $C_WHITE), (BRF $dx $dy 32 32), $sf)
  $g.DrawString($p.L, $fontPsm, (New-Object System.Drawing.SolidBrush $C_TEXT), (BP ([int]($p.X-30)) ([int]($p.Y+22))))
}

# ===== 公益捐赠 =====
$g.FillRectangle((New-Object System.Drawing.SolidBrush $C_PINK), (BR 40 1348 4 28))
$g.DrawString((Z("5YWs55uK5o2Q6LWg")), $fontH2, (New-Object System.Drawing.SolidBrush $C_WHITE), (BP 56 1340))
$donations = @()
$donations += @{I="01"; T=(Z "5rip5pqW5YyF"); D=(Z "5Li65bGx5Yy65o2QNTAwMOWFg+eJqei1hA==")}
$donations += @{I="02"; T=(Z "5Zu+5Lmm6KeS"); D=(Z "5Li656S+5Yy65o2QNTAwMOWFg+WbvuS5pg==")}
$donations += @{I="03"; T=(Z "5b6u5b+D5oS/"); D=(Z "5Li65a2p5a2Q5a6e546wNTAwMOWFg+W/g+aEvw==")}
$dY = 1395
for($i=0;$i -lt 3;$i++){
  $x = 40 + $i*247
  $g.FillRectangle((New-Object System.Drawing.SolidBrush $C_CARD), (BR $x $dY 237 120))
  $g.DrawRectangle((New-Object System.Drawing.Pen $C_LINE,1), (BR $x $dY 237 120))
  $g.DrawString($donations[$i].I, $fontH2, (New-Object System.Drawing.SolidBrush $C_PINK), (BP ($x+16) ($dY+12)))
  $g.DrawString($donations[$i].T, $fontH3, (New-Object System.Drawing.SolidBrush $C_WHITE), (BP ($x+16) ($dY+50)))
  $g.DrawString($donations[$i].D, $fontPsm, (New-Object System.Drawing.SolidBrush $C_SUB), (BRF ($x+16) ($dY+78) 205 40))
}

# ===== 注意事项 =====
$g.FillRectangle((New-Object System.Drawing.SolidBrush $C_PINK), (BR 40 1573 4 28))
$g.DrawString((Z("5rOo5oSP5LqL6aG5")), $fontH2, (New-Object System.Drawing.SolidBrush $C_WHITE), (BP 56 1565))
$notes = @()
$notes += (Z "5rS75Yqo5b2T5aSp6K+3552A6L+Q5Yqo6KOF6L+Q5Yqo6Z6LIOiHquWkh+mlrueUqOawtA==")
$notes += (Z "5rK/6YCU5ZCs5LuO5b+X5oS/6ICF5oyH5byVIOazqOaEj+S6pOmAmuWuieWFqA==")
$notes += (Z "546w5Zy65pyJ5pGE5b2x5pGE5YOPIOaKpeWQjeWNs+inhuS4uuWQjOaEj+S9v+eUqOiCluWDjw==")
$nY = 1620
$noteBrush = New-Object System.Drawing.SolidBrush $C_TEXT
for($i=0;$i -lt 3;$i++){
  $yy = [int]($nY+$i*40)
  $g.FillEllipse((New-Object System.Drawing.SolidBrush $C_PINK), (BR 50 ($yy+5) 10 10))
  $g.DrawString($notes[$i], $fontP, $noteBrush, (BP 72 $yy))
}

# ===== 报名入口 =====
$joinY = 1780
$joinH = 200
$joinRect = BR 0 $joinY $W $joinH
$joinBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush $joinRect,$C_PINK,$C_PINK2,90.0
$g.FillRectangle($joinBrush, $joinRect)
$g.DrawString((Z("5pyf5b6F5oKo55qE5Y+C5LiO")), $fontH2, (New-Object System.Drawing.SolidBrush $C_WHITE), (BRF 0 ($joinY+30) $W 40), $sf)
$g.DrawString((Z("5omr5o+P5LiL5pa55LqM57u056CB5oiW54K55Ye75oql5ZCN")), $fontP, (New-Object System.Drawing.SolidBrush $C_WHITE), (BRF 0 ($joinY+80) $W 24), $sf)
$btnX = [int](($W-200)/2); $btnY = [int]($joinY+130)
$g.FillRectangle((New-Object System.Drawing.SolidBrush $C_WHITE), (BR $btnX $btnY 200 46))
$g.DrawString((Z("56uL5Y2z5oql5ZCN")), $fontH3, (New-Object System.Drawing.SolidBrush $C_PINK), (BRF $btnX $btnY 200 46), $sf)

# ===== 底部信息 =====
$g.DrawString($Brand, $fontPsm, (New-Object System.Drawing.SolidBrush $C_SUB), (BRF 0 2020 $W 24), $sf)
$g.DrawString((Z("MjAyNi0wNy0xMiDpm4bnvo7luILmsJHlub/lnLrkuI3op4HkuI3mlaM=")), $fontPsm, (New-Object System.Drawing.SolidBrush $C_SUB), (BRF 0 2050 $W 24), $sf)

$savePath = Join-Path (Get-Location) "images\activities\walk_long.png"
$bmp.Save($savePath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
Write-Host "已生成: $savePath" -ForegroundColor Green
