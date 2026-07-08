Add-Type -AssemblyName System.Drawing
$bmp = New-Object System.Drawing.Bitmap 400, 200
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.Clear([System.Drawing.Color]::White)
$font = New-Object System.Drawing.Font "Microsoft YaHei", 30
$brush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::Black)
$bytes = [Convert]::FromBase64String("5L2T6IKy55CG55aX5YGl6Lqr5rS75Yqo")
$str = [System.Text.Encoding]::UTF8.GetString($bytes)
$g.DrawString($str, $font, $brush, 10, 50)
$bmp.Save("$PWD\test_zh.png", [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose()
$bmp.Dispose()
