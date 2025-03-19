@echo off
echo ============================================
echo    SISTEMA DE PEDIDOS - BUILD E EXECUCAO
echo ============================================
echo.

REM Verificar se o Node.js está instalado
node -v >nul 2>&1
if %errorlevel% neq 0 (
    echo Node.js nao encontrado! Por favor, instale o Node.js primeiro.
    pause
    exit /b 1
)

REM Verificar se o MySQL está instalado
mysql --version >nul 2>&1
if %errorlevel% neq 0 (
    echo MySQL nao encontrado! Por favor, instale o MySQL primeiro.
    pause
    exit /b 1
)

echo Iniciando processo de build e execucao...
echo.

REM Instalar dependências do frontend
echo Instalando dependencias do frontend...
cd frontend
call npm install
if %errorlevel% neq 0 (
    echo Erro ao instalar dependencias do frontend!
    pause
    exit /b 1
)

REM Build do frontend
echo Fazendo build do frontend...
call npm run build
if %errorlevel% neq 0 (
    echo Erro ao fazer build do frontend!
    pause
    exit /b 1
)

REM Instalar dependências do backend
echo Instalando dependencias do backend...
cd ../backend
call npm install
if %errorlevel% neq 0 (
    echo Erro ao instalar dependencias do backend!
    pause
    exit /b 1
)

REM Gerar cliente Prisma
echo Gerando cliente Prisma...
call npx prisma generate
if %errorlevel% neq 0 (
    echo Erro ao gerar cliente Prisma!
    pause
    exit /b 1
)

REM Executar migrações
echo Executando migracoes do banco de dados...
call npx prisma migrate deploy
if %errorlevel% neq 0 (
    echo Erro ao executar migracoes!
    pause
    exit /b 1
)

echo.
echo ============================================
echo    BUILD CONCLUIDO COM SUCESSO!
echo ============================================
echo.
echo Para iniciar o sistema:
echo 1. Abra um novo terminal e execute: cd backend && npm run dev
echo 2. Abra outro terminal e execute: cd frontend && npm run dev
echo.
echo O sistema estara disponivel em:
echo Frontend: http://localhost:5173
echo Backend: http://localhost:8081
echo.
pause 