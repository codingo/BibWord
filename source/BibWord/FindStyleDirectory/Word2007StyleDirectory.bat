FOR /F "tokens=2* delims=	 " %%A IN ('REG QUERY HKLM\SOFTWARE\Microsoft\Office\12.0\Common\InstallRoot /v Path') DO SET Word2007=%%B
explorer %Word2007%Bibliography\Style
