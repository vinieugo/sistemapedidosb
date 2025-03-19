@echo off
echo ===================================================
echo  Instalação do Sistema de Pedidos - Setup Inicial
echo ===================================================
echo.

REM Verificar se o Node.js está instalado
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Node.js não encontrado! 
    echo Instale o Node.js antes de continuar: https://nodejs.org/
    pause
    exit /b 1
)

REM Mostrar versão do Node.js
echo [INFO] Versão do Node.js:
node -v
echo.

REM Instalar dependências do projeto principal
echo [INFO] Instalando dependências do frontend...
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao instalar as dependências do frontend!
    pause
    exit /b 1
)
echo [OK] Dependências do frontend instaladas com sucesso!
echo.

REM Instalar dependências do backend
echo [INFO] Instalando dependências do backend...
cd backend
call npm install
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao instalar as dependências do backend!
    pause
    exit /b 1
)
echo [OK] Dependências do backend instaladas com sucesso!
echo.

REM Executar as migrações do Prisma
echo [INFO] Executando migrações do Prisma...
call npx prisma migrate deploy
if %ERRORLEVEL% NEQ 0 (
    echo [AVISO] Falha ao executar as migrações do Prisma!
    echo         Verifique se o MySQL está configurado corretamente.
    echo         Execute o script setup_mysql.bat se ainda não o fez.
) else (
    echo [OK] Migrações do Prisma executadas com sucesso!
)
echo.

REM Gerar cliente Prisma
echo [INFO] Gerando cliente Prisma...
call npx prisma generate
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao gerar o cliente Prisma!
    pause
    exit /b 1
)
echo [OK] Cliente Prisma gerado com sucesso!

REM Voltar para o diretório raiz
cd ..

echo.
echo =====================================================
echo  Instalação concluída com sucesso!
echo  
echo  Para iniciar o backend: 
echo    cd backend
echo    npm run dev
echo  
echo  Para iniciar o frontend:
echo    npm run dev
echo =====================================================
echo.

pause 