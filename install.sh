#!/bin/bash

clear
echo "======================================"
echo " INSTALADOR DEL PANEL"
echo "======================================"
echo ""

if [ "$(id -u)" != "0" ]; then
    echo "Debes ejecutar como root."
    exit 1
fi

echo "Instalando dependencias básicas..."
apt update -y
apt install -y curl wget unzip tar gzip bzip2 python3 python3-pip nginx openssh-server net-tools lsof cron

echo "Creando carpetas..."
mkdir -p /etc/adm-lite
mkdir -p /etc/ADMcgh
mkdir -p /etc/ADMcgh/bin

echo "Copiando archivos del panel..."
cp -a adm-lite/* /etc/adm-lite/ 2>/dev/null
cp -a ADMcgh/* /etc/ADMcgh/ 2>/dev/null

echo "Copiando comandos..."
cp -a usr-bin/menu /usr/bin/menu 2>/dev/null
cp -a usr-bin/verifysys /usr/bin/verifysys 2>/dev/null
cp -a usr-bin/vendor_code /usr/bin/vendor_code 2>/dev/null

ln -sf /etc/ADMcgh/bin/SBdm /usr/bin/toolmaster 2>/dev/null
ln -sf /etc/ADMcgh/bin/upLIC /usr/bin/upLIC 2>/dev/null

if [ -f bin/autoboot ]; then
    cp -a bin/autoboot /bin/autoboot
    chmod +x /bin/autoboot
fi

chmod +x /usr/bin/menu 2>/dev/null
chmod +x /usr/bin/toolmaster 2>/dev/null
chmod +x /usr/bin/upLIC 2>/dev/null
chmod -R 777 /etc/adm-lite 2>/dev/null
chmod -R 755 /etc/ADMcgh 2>/dev/null
chmod +x /etc/adm-lite/menu 2>/dev/null
chmod +x /etc/ADMcgh/bin/* 2>/dev/null

echo "Configurando autoarranque..."
if [ -f /bin/autoboot ]; then
    crontab -l 2>/dev/null | grep -v "/bin/autoboot" > /tmp/cronpanel
    echo "@reboot /bin/autoboot" >> /tmp/cronpanel
    crontab /tmp/cronpanel
    rm -f /tmp/cronpanel
fi

echo "Reiniciando servicios básicos..."
systemctl restart ssh 2>/dev/null
systemctl restart nginx 2>/dev/null
systemctl restart cron 2>/dev/null

clear
echo "======================================"
echo " PANEL INSTALADO"
echo "======================================"
echo ""
echo "Para abrir el panel usa:"
echo "menu"
echo ""
