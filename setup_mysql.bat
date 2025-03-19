@echo off
echo =============================================
echo  Configuração do MySQL para Sistema de Pedidos
echo =============================================
echo.

REM Definir variáveis
set DB_NAME=sistema_pedidos
set DB_USER=root
set DB_PASSWORD=root
set DB_HOST=localhost
set MYSQL_PATH=C:\Program Files\MySQL\MySQL Server 8.0

echo [INFO] Verificando instalação do MySQL...
if not exist "%MYSQL_PATH%\bin\mysql.exe" (
    echo [ERRO] MySQL não encontrado no caminho padrão: %MYSQL_PATH%
    echo.
    echo Por favor, siga estas etapas para instalar o MySQL:
    echo 1. Baixe o MySQL Server 8.0 de https://dev.mysql.com/downloads/mysql/
    echo 2. Durante a instalação:
    echo    - Escolha "Developer Default" ou "Server only"
    echo    - Porta: mantenha a padrão (3306)
    echo    - Autenticação: Use Legacy Authentication Method
    echo    - Defina a senha de root como "root"
    echo 3. Depois de instalar, execute este script novamente
    echo.
    pause
    exit /b 1
)

echo [OK] MySQL encontrado!
echo.
echo [INFO] Criando banco de dados %DB_NAME%...

REM Criar arquivo SQL temporário
echo CREATE DATABASE IF NOT EXISTS %DB_NAME%; > temp_setup.sql

REM Executar o script SQL
"%MYSQL_PATH%\bin\mysql.exe" -u%DB_USER% -p%DB_PASSWORD% -h%DB_HOST% < temp_setup.sql
if %ERRORLEVEL% NEQ 0 (
    echo [ERRO] Falha ao criar o banco de dados!
    echo Verifique se:
    echo - O MySQL está em execução
    echo - A senha do usuário root está correta (deve ser "root")
    del temp_setup.sql
    pause
    exit /b 1
)

REM Remover arquivo temporário
del temp_setup.sql

echo [OK] Banco de dados %DB_NAME% criado com sucesso!
echo.
echo [INFO] MySQL está configurado e pronto para uso.
echo.
echo Agora você pode executar o script setup_projeto.bat para configurar o projeto.
echo.

pause 