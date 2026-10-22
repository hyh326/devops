# 3주차 - 셸 스크립팅 (qwen-web)

## 1. 한 일

- Ollama를 설치하고 `ollama pull qwen3:0.6b`로 모델을 받았다
- LMS에서 받은 `chat.py`를 `python3 chat.py`로 실행해 `http://localhost:8000`에서 질문과 답변을 확인했다
- 실행할 때마다 `cd ~`, `cd devops`, `cd week03`, `cd qwen-web`으로 경로를 찾아간 뒤 `python3 chat.py`를 쳐야 하는 불편을 `start.sh`로 해결했다

## 2. 구조

- 브라우저 → `chat.py` (127.0.0.1:8000) → Ollama 서버 (127.0.0.1:11434) → `qwen3:0.6b`
- `Ctrl+C`로 끄면 Python 웹앱만 종료되고 Ollama 서버는 계속 켜져 있다
- 모델은 Ollama가 따로 보관해서 이 폴더에 복사하거나 GitHub에 올리지 않는다

## 3. start.sh

```bash
#!/bin/bash
cd "$(dirname "$0")" || exit 1
if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3를 먼저 설치하세요." >&2
    exit 1
fi
exec python3 chat.py
```

- `#!/bin/bash`: 이 파일을 Bash로 실행하라고 알려 주는 셔뱅이다 (`#` 하나만 있으면 주석)
- `cd "$(dirname "$0")" || exit 1`: 스크립트가 있는 폴더로 이동하고 실패하면 종료 코드 1로 끝낸다
- 그래서 홈 폴더에서 `./devops/week03/qwen-web/start.sh`로 실행해도 `chat.py`를 찾는다
- `command -v python3`로 python3가 있는지 확인하고, 없으면 안내 문구를 출력한 뒤 `exit 1`로 끝낸다
- 없는 프로그램 이름으로 바꿔 시험했더니 안내 문구가 나오고 종료 코드가 1이었다
- `exec`는 bash를 python3로 대체한다

## 4. 실행 권한

- 처음 `./start.sh`를 실행하면 `Permission denied`가 나왔다 (`ls -l`에 `x`가 없었다)
- `chmod u+x start.sh` 후에는 `-rwxr--r--`가 되어 실행됐다
- `./` 없이 `start.sh`만 치면 `start.sh: command not found`가 나왔다 (이름만 치면 PATH에 등록된 폴더에서만 찾기 때문)

## 5. exec 비교

- `exec` 있는 스크립트: `Ctrl+C` 후 `웹앱을 종료했습니다.`만 출력됐다
- `exec` 없는 스크립트: `웹앱을 종료했습니다.` 뒤에 `End`가 출력됐다
- `exec`가 있으면 bash 자체가 python3로 바뀌어서 그 뒤의 줄은 실행되지 않는다

## 6. 환경 변수

- `start_with_export.sh`: `export MODEL="qwen3:0.6b"` 후 `exec ./start.sh`
- `start_with_export_2.sh`: `export WEB_PORT="8080"`으로 `http://localhost:8080`에서 실행했다
- 스크립트 안의 `export`는 터미널의 환경 변수를 바꾸지 않았다 (`echo "[$MODEL]"` 결과가 `[]`)
- 처음에는 `Address already in use`가 났다. 7주차 guestbook의 nginx가 8080 포트를 쓰고 있어서 `docker compose down`으로 내린 뒤 실행했다
- heredoc에서 `'EOF'`처럼 따옴표를 붙이면 내용이 글자 그대로 저장되고, 따옴표가 없으면 `$MODEL`이 저장 전에 값으로 바뀐다

## 7. 출력 리다이렉션

- `>/dev/null 2>&1`: 출력과 오류를 모두 버린다. 종료 코드는 남는다 (`ls /nope` 결과 `echo $?`가 2)
- `2>&1 >/dev/null`은 순서가 달라서 오류가 화면에 다시 나온다
- `echo "..." >&2`는 안내 문구를 표준 오류로 내보낸다

## 새로 배운 명령어

```bash
ollama pull qwen3:0.6b
ollama list
chmod u+x start.sh
command -v python3
echo $?
exec python3 chat.py
export WEB_PORT="8080"
```
