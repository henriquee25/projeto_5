@echo off
chcp 65001 >nul
title Configuração do Git - Laboratório
:: Serviço utilizado pela instituição
set "HOST_GIT=github.com"
:menu
cls
echo =====================================================
echo CONFIGURACAO DO GIT - LABORATORIO
echo =====================================================
echo.
echo 1 - Configurar usuário neste projeto
echo 2 - Remover usuário deste projeto
echo 3 - Configurar usuário globalmente
echo 4 - Limpar usuário global e credenciais
echo 5 - Mostrar configuração atual
echo 0 - Sair
echo.
set /p opcao=Escolha uma opção:
if "%opcao%"=="1" goto configurar_local
if "%opcao%"=="2" goto remover_local
if "%opcao%"=="3" goto configurar_global
if "%opcao%"=="4" goto limpar_global
if "%opcao%"=="5" goto mostrar
if "%opcao%"=="0" exit
echo.
echo Opção inválida.
pause
goto menu

:configurar_local
cls
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
echo Esta pasta não é um repositório Git.
echo.
echo Abra o arquivo BAT dentro da pasta do projeto.
pause
goto menu
)
set /p nome=Digite seu nome completo:
set /p email=Digite seu e-mail do GitHub:
git config --local user.name "%nome%"
git config --local user.email "%email%"
echo.
echo Usuário configurado somente neste projeto.

echo.
git config --local --list
pause
goto menu

:remover_local
cls
git rev-parse --is-inside-work-tree >nul 2>&1
if errorlevel 1 (
echo Esta pasta não é um repositório Git.
pause
goto menu
)
git config --local --unset-all user.name >nul 2>&1
git config --local --unset-all user.email >nul 2>&1
echo.
echo Configuração local removida.
pause
goto menu

:configurar_global
cls
set /p nome=Digite seu nome completo:
set /p email=Digite seu e-mail do GitHub:
git config --global user.name "%nome%"
git config --global user.email "%email%"
git config --global user.useConfigOnly true
echo.
echo Usuário configurado globalmente neste computador.
echo.
git config --global --get user.name
git config --global --get user.email
pause
goto menu

:limpar_global
cls
echo Removendo nome e e-mail...
git config --global --unset-all user.name >nul 2>&1
git config --global --unset-all user.email >nul 2>&1
:: Impede que o Git tente descobrir automaticamente outro usuário
git config --global user.useConfigOnly true
echo Removendo credenciais salvas de %HOST_GIT%...

git credential-manager --version >nul 2>&1
if not errorlevel 1 (
(
echo protocol=https
echo host=%HOST_GIT%
echo.
) | git credential-manager erase >nul 2>&1
echo Credenciais removidas pelo Git Credential Manager.
) else (
echo.
echo Git Credential Manager não encontrado.
echo Verifique também:
echo Painel de Controle ^> Gerenciador de Credenciais
echo ^> Credenciais do Windows.
)
echo.
echo Limpeza concluída.
echo O próximo aluno deverá informar seus próprios dados.
pause
goto menu

:mostrar
cls
echo =====================================================
echo CONFIGURAÇÃO LOCAL DO PROJETO
echo =====================================================
git config --local --get user.name 2>nul
git config --local --get user.email 2>nul
echo.
echo =====================================================
echo CONFIGURAÇÃO GLOBAL DO COMPUTADOR
echo =====================================================
git config --global --get user.name 2>nul
git config --global --get user.email 2>nul
echo.
echo =====================================================
echo CONFIGURAÇÃO EFETIVAMENTE UTILIZADA
echo =====================================================
echo Nome:
git config --get user.name 2>nul
echo.
echo E-mail:
git config --get user.email 2>nul
echo.
pause
goto menu