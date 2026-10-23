# week06 기록

## 1. 내 이미지 주소
- ghcr.io/hyh326/guestbook:v1
- ghcr.io/hyh326/guestbook:v2

## 2. Dockerfile 각 줄이 하는 일
- FROM python:3.12-slim: 파이썬이 설치된 가벼운 이미지에서 시작
- WORKDIR /app: 컨테이너 안의 작업 폴더 지정
- COPY requirements.txt . / RUN pip install: 의존성만 먼저 설치해서 캐시를 활용
- COPY . .: 앱 코드 복사
- RUN useradd / USER appuser: root가 아닌 사용자로 실행
- ENV: 기본 제목과 색 설정을 이미지에 고정
- EXPOSE 5000: 앱이 5000번 포트를 사용함을 표시
- CMD ["python", "app.py"]: 컨테이너 시작 시 실행할 명령

## 3. 빌드 캐시 동작 로그 (CACHED)
```
#4 [1/6] FROM docker.io/library/python:3.12-slim@sha256:05cda9777409a9c3ffddd94a4c476b79f0769a0b4857f0c7ed9226b6800b0d6f
#6 [4/6] RUN pip install --no-cache-dir -r requirements.txt
#6 CACHED
#7 [2/6] WORKDIR /app
#7 CACHED
#8 [5/6] COPY . .
#8 CACHED
#9 [3/6] COPY requirements.txt .
#9 CACHED
#10 [6/6] RUN useradd -m appuser
#10 CACHED
```

## 4. 설정을 넣는 세 가지 방법
- app.py 기본값: 코드에서 확정, 바꾸려면 코드 수정 후 재빌드
- Dockerfile ENV: 이미지 빌드 시점에 확정, 바꾸려면 재빌드
- docker run -e: 컨테이너 실행 시점에 확정, 컨테이너만 다시 실행
- 우선순위: app.py 기본값 < Dockerfile ENV < docker run -e
