m4_include(`commons.m4')

_HEADER(`Copyfile')

_HL1(`Copyfile:')

_HTML_IMG(`pix/copyfile.png',`screenshot')

m4_define(`_DOWNLOAD_URL', `http://conus.info/attic-files/copyfile/copyfile.exe')
m4_define(`_SOURCE_CODE_URL', `https://github.com/dennis714/Copyfile')

<hr>

<p>Это очень простая win32-утилита для копирования файлов игнорируя ошибки, включая CRC-ошибки.</p>
<p>Бывает полезной, когда нужно прочитать файл с поцарапанного CD или винчестера с бэд-блоками и если вы можете согласиться с тем что вместо оных в результирующем файле будут нулевые блоки.</p>
<p>_HTML_LINK(`_DOWNLOAD_URL',`Скачать')</p>
<p>_HTML_LINK(`_SOURCE_CODE_URL',`Исходный код')</p>

<hr>

<p>A very simple win32-utility to copy a file ignoring errors (including CRC errors).</p>
<p>This is useful when you try to recover a file from scratchy CD or hard disk with bad blocks and you can live with zeroed blocks instead of parts were not read.</p>
<p>_HTML_LINK(`_DOWNLOAD_URL',`Download')</p>
<p>_HTML_LINK(`_SOURCE_CODE_URL',`Source code')</p>

_FOOTER()
