@echo off
set pypath=home = %~dp0python
set venvpath=_ENV=%~dp0venv
if exist venv (powershell -command "$text = (gc venv\pyvenv.cfg) -replace 'home = .*', $env:pypath; $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False);[System.IO.File]::WriteAllLines('venv\pyvenv.cfg', $text, $Utf8NoBomEncoding);$text = (gc venv\scripts\activate.bat) -replace '_ENV=.*', $env:venvpath; $Utf8NoBomEncoding = New-Object System.Text.UTF8Encoding($False);[System.IO.File]::WriteAllLines('venv\scripts\activate.bat', $text, $Utf8NoBomEncoding);")

for /d %%i in (tmp\tmp*,tmp\pip*) do rd /s /q "%%i" 2>nul || ("%%i" && exit /b 1) & del /q tmp\tmp* > nul 2>&1 & rd /s /q pip\cache 2>nul

set appdata=tmp
set userprofile=tmp
set temp=tmp
set PATH=git\cmd;python;venv\scripts;ffmpeg;venv\Lib\site-packages\torch\lib;tensorrt;tensorrt\lib;tensorrt\bin

set PYTORCH_CUDA_ALLOC_CONF=garbage_collection_threshold:0.8,max_split_size_mb:512
set CUDA_MODULE_LOADING=LAZY
set CUDA_PATH=venv\Lib\site-packages\torch\lib

call venv\Scripts\activate.bat
python -m pip uninstall onnxruntime-directml -y
python -m pip install onnxruntime_gpu-1.15.1-cp310-cp310-win_amd64.whl
python run.py --execution-threads 4 --execution-provider cuda --max-memory 16
pause

REM Упаковано и собрано телеграм каналом Neutogen News: https://t.me/neurogen_news
REM --execution-threads N - Количество потоков для вашей видеокарты. Слишком большое значение может вызвать ошибки или наоборот, снизить производительность. 4 потока потребляют примерно 5.5-6 Gb VRAM, 8 потоков - 10 Gb VRAM, но пиковое потребление бывает выше. 
REM --max-memory 8 - сколько вы готовы выделить оперативной памяти в гигабайтах
REM --frame-processor - выбор режима обработки. face_swapper - замена лица, face_enhancer - улучшение уже измененного лица через апскейлер
REM --execution-provider cuda - Наш бэкенд. Если у вас Nvidia - ставьте cuda, если Nvidia RTX 4000 - можете попробовать указать tensorrt.

