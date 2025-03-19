@echo off
echo Iniciando o backend...
start "Backend" cmd /c "cd backend && npm run start"

echo Iniciando o frontend...
start "Frontend" cmd /c "serve -s dist -l 5173"

echo Serviços iniciados!
echo Backend: http://192.168.5.3:8081
echo Frontend: http://192.168.5.3:5173 