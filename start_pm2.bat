@echo off
echo Iniciando o sistema de pedidos...

echo Instalando dependencias do frontend...
call npm install

echo Instalando dependencias do backend...
cd backend
call npm install
cd ..

echo Construindo o frontend...
call npm run build

echo Iniciando os servicos com PM2...
pm2 start "%CD%\ecosystem.config.cjs"

echo Sistema iniciado com sucesso!
echo Use 'pm2 status' para verificar o status dos servicos
echo Use 'pm2 logs' para ver os logs dos servicos 